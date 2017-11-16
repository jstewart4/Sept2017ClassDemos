using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

#region Additional Namespaces
using Chinook.Data.Entities;
using Chinook.Data.DTOs;
using Chinook.Data.POCOs;
using ChinookSystem.DAL;
using System.ComponentModel;
#endregion

namespace ChinookSystem.BLL
{
    public class PlaylistTracksController
    {
        public List<UserPlaylistTrack> List_TracksForPlaylist(string playlistname, string username)
        {
            using (var context = new ChinookContext())
            {
                // what would happen if there is no match for the incoming parameter values
                // we need to ensure that results have a valid value
                // this values will be an IEnumerable<T> collection or it should be null
                // to ensure that results does end up with a valid value use the .FirstOrDefault()
                var results = (from x in context.Playlists
                              where x.UserName.Equals(username) && x.Name.Equals(playlistname)
                              select x).FirstOrDefault();

                var theTracks = from x in context.PlaylistTracks
                                where x.PlaylistId.Equals(results.PlaylistId)
                                orderby x.TrackNumber
                                select new UserPlaylistTrack
                                {
                                    TrackID = x.TrackId,
                                    TrackNumber = x.TrackNumber,
                                    TrackName = x.Track.Name,
                                    Milliseconds = x.Track.Milliseconds,
                                    UnitPrice = x.Track.UnitPrice
                                };
                return theTracks.ToList();
            }
        }//eom
        public List<UserPlaylistTrack> Add_TrackToPLaylist(string playlistname, string username, int trackid)
        {
            using (var context = new ChinookContext())
            {
                // PART ONE: Handle playlist record
                // query to get the playlist id
                var exists = (from x in context.Playlists
                               where x.UserName.Equals(username) && x.Name.Equals(playlistname)
                               select x).FirstOrDefault();
                // initialize the tracknumber for the track going into playlisttracks
                int tracknumber = 0;
                // I need to create an instance of PlaylistTrack
                PlaylistTrack newtrack = null;
                //now determine if this is an addition to an existing list or if a new list needs to be created
                if (exists == null)
                {
                    // if exists == null, then this is a new playlist and you must create the playlist
                    exists = new Playlist();
                    exists.Name = playlistname;
                    exists.UserName = username;
                    exists = context.Playlists.Add(exists);
                    tracknumber = 1;
                }
                else
                {
                    // the playlist already exists. I need to know the number of tracks currently on the list
                    // tracknumber = count + 1
                    tracknumber = exists.PlaylistTracks.Count() + 1;
                    // in our example, tracks exist only once on each playlist
                    newtrack = exists.PlaylistTracks.SingleOrDefault(x => x.TrackId == trackid);
                    // this will be null if the track is not on the playlist tracks
                    if (newtrack != null)
                    {
                        throw new Exception("Playlist already has requested track.");
                    }
                }

                // PART TWO: Handle the track for PlaylistTrack

                // use navigation to .Add the new track to PlaylistTrack
                newtrack = new PlaylistTrack();
                newtrack.TrackId = trackid;
                newtrack.TrackNumber = tracknumber;

                // NOTE: The pkey for PlaylistId may not yet exist 
                // Using navigation one can let HashSet handle the PlaylistId pkey
                exists.PlaylistTracks.Add(newtrack);

                // physically commit your work to the database
                context.SaveChanges();
                // refresh list
                return List_TracksForPlaylist(playlistname, username);
            }
        }//eom
        public void MoveTrack(string username, string playlistname, int trackid, int tracknumber, string direction)
        {
            using (var context = new ChinookContext())
            {
                // query to get the playlist id
                var exists = (from x in context.Playlists
                              where x.UserName.Equals(username) && x.Name.Equals(playlistname)
                              select x).FirstOrDefault();
                if (exists == null)
                {
                    throw new Exception("Playlist has been removed");
                }
                else
                {
                    // limit your search to the particular playlist (using exists not context)
                    PlaylistTrack movetrack = (from x in exists.PlaylistTracks
                                               where x.TrackId == trackid
                                               select x).FirstOrDefault();
                    if (movetrack == null)
                    {
                        throw new Exception("Playlist track has been removed");
                    }
                    else
                    {
                        PlaylistTrack othertrack = null;
                        if (direction.Equals("up")) // for up button
                        {
                            if (movetrack.TrackNumber == 1)
                            {
                                throw new Exception("Playlist track cannot be moved up.");
                            }
                            else
                            {
                                // get the other track
                                othertrack = (from x in exists.PlaylistTracks
                                              where x.TrackNumber == movetrack.TrackNumber - 1
                                              select x).FirstOrDefault();

                                if (othertrack == null)
                                {
                                    throw new Exception("Playlist track cannot be moved up.");
                                }
                                else
                                {
                                    // at this point you can exchange track numbers
                                    movetrack.TrackNumber -= 1;
                                    othertrack.TrackNumber += 1;
                                }
                            }
                        }
                        else // for down button
                        {
                            if (movetrack.TrackNumber == exists.PlaylistTracks.Count)
                            {
                                throw new Exception("Playlist track cannot be moved down.");
                            }
                            else
                            {
                                // get the other track
                                othertrack = (from x in exists.PlaylistTracks
                                              where x.TrackNumber == movetrack.TrackNumber + 1
                                              select x).FirstOrDefault();

                                if (othertrack == null)
                                {
                                    throw new Exception("Playlist track cannot be moved down.");
                                }
                                else
                                {
                                    // at this point you can exchange track numbers
                                    movetrack.TrackNumber += 1;
                                    othertrack.TrackNumber -= 1;
                                }
                            }
                        }
                        // stage the changes for SaveChanges()
                        // indicate only the field that needs to be updated
                        context.Entry(movetrack).Property(y => y.TrackNumber).IsModified = true;
                        context.Entry(othertrack).Property(y => y.TrackNumber).IsModified = true;
                        context.SaveChanges();

                    }
                }

            }
        }//eom


        public void DeleteTracks(string username, string playlistname, List<int> trackstodelete)
        {
            using (var context = new ChinookContext())
            {
            }
        }//eom
    }
}
