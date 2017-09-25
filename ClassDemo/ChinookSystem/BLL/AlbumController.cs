using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

#region Additional Namespaces
using Chinook.Data.Entities;
using ChinookSystem.DAL;
using Chinook.Data.POCOs;
using System.ComponentModel;
#endregion

namespace ChinookSystem.BLL
{
    [DataObject]
    public class AlbumController
    {
        [DataObjectMethod(DataObjectMethodType.Select,false)]
        public List<ArtistAlbumByReleaseYear> Albums_ByArtist(int artistId)
        {
            using (var context = new ChinookContext())
            {
                var results = from x in context.Albums
                              where x.ArtistId.Equals(artistId)
                              select new ArtistAlbumByReleaseYear
                              {
                                  Title = x.Title,
                                  Released = x.ReleaseYear
                              };
                return results.ToList();
            }

        }// end of method

        [DataObjectMethod(DataObjectMethodType.Select,false)]
        public List<Album> Albums_FindByYearRange(int minYear, int maxYear)
        {
            using (var context = new ChinookContext())
            {
                var results = from date in context.Albums
                              where date.ReleaseYear >= minYear && date.ReleaseYear <= maxYear
                              orderby date.ReleaseYear, date.Title
                              select date;
                return results.ToList();
            }
        }
    }
}
