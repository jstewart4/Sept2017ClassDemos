using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

#region Additional Namespaces
using ChinookSystem.BLL;
using Chinook.Data.POCOs;

#endregion
public partial class SamplePages_ManagePlaylist : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Request.IsAuthenticated)
        {
            Response.Redirect("~/Account/Login.aspx");
        }
        else
        {
            TracksSelectionList.DataSource = null;
        }
    }

    protected void CheckForException(object sender, ObjectDataSourceStatusEventArgs e)
    {
        MessageUserControl.HandleDataBoundException(e);
    }

    protected void Page_PreRenderComplete(object sender, EventArgs e)
    {
        //PreRenderComplete occurs just after databinding page events
        //load a pointer to point to your DataPager control
        DataPager thePager = TracksSelectionList.FindControl("DataPager1") as DataPager;
        if (thePager !=null)
        {
            //this code will check the StartRowIndex to see if it is greater that the
            //total count of the collection
            if (thePager.StartRowIndex > thePager.TotalRowCount)
            {
                thePager.SetPageProperties(0, thePager.MaximumRows, true);
            }
        }
    }

    protected void ArtistFetch_Click(object sender, EventArgs e)
    {
        TracksBy.Text = "Artist";
        SearchArgID.Text = ArtistDDL.SelectedValue;
        TracksSelectionList.DataBind();
    }

    protected void MediaTypeFetch_Click(object sender, EventArgs e)
    {
        TracksBy.Text = "MediaType";
        SearchArgID.Text = MediaTypeDDL.SelectedValue;
        TracksSelectionList.DataBind();
    }

    protected void GenreFetch_Click(object sender, EventArgs e)
    {
        TracksBy.Text = "Genre";
        SearchArgID.Text = GenreDDL.SelectedValue;
        TracksSelectionList.DataBind();
    }

    protected void AlbumFetch_Click(object sender, EventArgs e)
    {
        TracksBy.Text = "Album";
        SearchArgID.Text = AlbumDDL.SelectedValue;
        TracksSelectionList.DataBind();
    }

    protected void PlayListFetch_Click(object sender, EventArgs e)
    {
        //standard query
        if (string.IsNullOrEmpty(PlaylistName.Text))
        {
            // put out an error message. This form uses a User Control called MessageUserControl. 
            // the user control will be the mechanism to display messages on this form
            MessageUserControl.ShowInfo("Warning", "Playlist name is required.");
        }
        else
        {
            // obtain the username from the security part of the application
            string username = User.Identity.Name;
            // You do not have to do try/catch. The MessageUserControl has the try/catch coding embedded in the control
            MessageUserControl.TryRun(() =>
            {
                // this is the process coding block to be executed under the "watchful eye" of the MessageUser control
                PlaylistTracksController sysmgr = new PlaylistTracksController();
                List<UserPlaylistTrack> playlist = sysmgr.List_TracksForPlaylist(PlaylistName.Text, username);
                PlayList.DataSource = playlist;
                PlayList.DataBind();
            },"Information","Here is your current playlist.");
        }
    }

    protected void TracksSelectionList_ItemCommand(object sender, ListViewCommandEventArgs e)
    {
        //ListViewCommandEventArgs parameter e contains the CommandArg value
        if (string.IsNullOrEmpty(PlaylistName.Text))
        {
            MessageUserControl.ShowInfo("Warning", "Playlist name is required.");
        }
        else
        {
            string username = User.Identity.Name;

            // TrackID is going to come from e.CommandArgument
            // e.CommandArgument is an object, therefore you MUST convert to string
            int trackid = int.Parse(e.CommandArgument.ToString());

            // the following code calls a BLL method to add to the database
            MessageUserControl.TryRun(() =>
           {
               PlaylistTracksController sysmgr = new PlaylistTracksController();
               List<UserPlaylistTrack> refreshresults = sysmgr.Add_TrackToPLaylist(PlaylistName.Text, username, trackid);
               PlayList.DataSource = refreshresults;
               PlayList.DataBind();
           }, "Success", "Track added to playlist");
        }
    }
    protected void MoveUp_Click(object sender, EventArgs e)
    {
        // check if you have a list
        if (PlayList.Rows.Count == 0)
        {
            MessageUserControl.ShowInfo("Warning", "No playlist has been retreived.");
        }
        else
        {
            // check if playlist name field is empty
            if (string.IsNullOrEmpty(PlaylistName.Text))
            {
                MessageUserControl.ShowInfo("Warning", "No playlist name has been supplied.");
            }
            else
            {
                // check only one row selected
                int trackid = 0;
                int tracknumber = 0; // optional
                int rowselected = 0; // search flag
                // create a pointer to use for the access of the GridView control. Says "this is the checkbox in this row".
                CheckBox playlistselection = null;
                // traverse the GridView checking each row for a selected checkbox
                for (int i = 0; i < PlayList.Rows.Count; i++)
                {
                    // find the checkbox on the indexed GridView row. playlistselection will point to the checkbox.
                    playlistselection = PlayList.Rows[i].FindControl("Selected") as CheckBox;
                    // check if it is checked
                    if (playlistselection.Checked)
                    {
                        trackid = int.Parse((PlayList.Rows[i].FindControl("TrackId") as Label).Text);
                        tracknumber = int.Parse((PlayList.Rows[i].FindControl("TrackNumber") as Label).Text);
                        rowselected++;
                    }
                }
                // check if only one track is selected
                if (rowselected != 1)
                {
                    MessageUserControl.ShowInfo("Warning", "Select only one track to move.");
                }
                else
                {
                    // check if track is at the top of the playlist
                    if (tracknumber == 1)
                    {
                        MessageUserControl.ShowInfo("Information", "Track can not be moved, it is already at top of the list.");
                    }
                    else
                    {
                        // at this point you have playlist name, username, and trackid which is needed to move the track

                        // move the track via your BLL
                        MoveTrack(trackid, tracknumber, "up");
                    }
                }
            }
        }
    }

    protected void MoveDown_Click(object sender, EventArgs e)
    {
        // check if you have a list
        if (PlayList.Rows.Count == 0)
        {
            MessageUserControl.ShowInfo("Warning", "No playlist has been retreived.");
        }
        else
        {
            // check if playlist name field is empty
            if (string.IsNullOrEmpty(PlaylistName.Text))
            {
                MessageUserControl.ShowInfo("Warning", "No playlist name has been supplied.");
            }
            else
            {
                // check only one row selected
                int trackid = 0;
                int tracknumber = 0; // optional
                int rowselected = 0; // search flag
                // create a pointer to use for the access of the GridView control. Says "this is the checkbox in this row".
                CheckBox playlistselection = null;
                // traverse the GridView checking each row for a selected checkbox
                for (int i = 0; i < PlayList.Rows.Count; i++)
                {
                    // find the checkbox on the indexed GridView row. playlistselection will point to the checkbox.
                    playlistselection = PlayList.Rows[i].FindControl("Selected") as CheckBox;
                    // check if it is checked
                    if (playlistselection.Checked)
                    {
                        trackid = int.Parse((PlayList.Rows[i].FindControl("TrackId") as Label).Text);
                        tracknumber = int.Parse((PlayList.Rows[i].FindControl("TrackNumber") as Label).Text);
                        rowselected++;
                    }
                }
                // check if only one track is selected
                if (rowselected != 1)
                {
                    MessageUserControl.ShowInfo("Warning", "Select only one track to move.");
                }
                else
                {
                    // check if track is at the top of the playlist
                    if (tracknumber == PlayList.Rows.Count)
                    {
                        MessageUserControl.ShowInfo("Information", "Track can not be moved, it is already at bottom of the list.");
                    }
                    else
                    {
                        // at this point you have playlist name, username, and trackid which is needed to move the track

                        // move the track via your BLL
                        MoveTrack(trackid, tracknumber, "down");
                    }
                }
            }
        }
    }
    protected void MoveTrack(int trackid, int tracknumber, string direction)
    {
        // Wrap in MessageUserControl tryrun (try catch) for error handling
        MessageUserControl.TryRun(() =>
        {
            // standard call to a BLL method
            // update call
            PlaylistTracksController sysmgr = new PlaylistTracksController();
            sysmgr.MoveTrack(User.Identity.Name, PlaylistName.Text, trackid, tracknumber, direction);
            // after you move, refresh the list
            // query call
            List<UserPlaylistTrack> results = sysmgr.List_TracksForPlaylist(PlaylistName.Text, User.Identity.Name);
            PlayList.DataSource = results;
            PlayList.DataBind();
        },"Success", "Track moved.");
    }
    protected void DeleteTrack_Click(object sender, EventArgs e)
    {
        //code to go here
    }
}
