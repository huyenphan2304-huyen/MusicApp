using MusicApp.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace MusicApp.ViewModels
{
    public class MiscellaneousViewModel
    {
        public List<Miscellaneous> WeeksTop { get; set; }
        public List<Miscellaneous> NewHits { get; set; }
        public List<Miscellaneous> PopularArtists { get; set; }
    }

}