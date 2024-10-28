using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace MusicApp.ViewModels
{
    public class PlaylistDetailViewModel
    {
        public int Id { get; set; }
        public string PlaylistName { get; set; }
        public string PlaylistDescription { get; set; }
        public string CreatedBy { get; set; }
        public DateTime? CreatedDate { get; set; }
        public List<SongViewModel> Songs { get; set; }
    }

}