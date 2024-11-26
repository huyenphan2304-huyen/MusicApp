using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace MusicApp.ViewModels
{
    public class SlideViewModel
    {
        public int Id { get; set; }
        public string AlbumTitle { get; set; }
        public DateTime? CreatedDate { get; set; } // Nullable DateTime
        public string Meta { get; set; }
        public bool Hide { get; set; }
        public int Order { get; set; }
        public DateTime? DateBegin { get; set; } // Nullable DateTime
    }


}