using MusicApp.Models;
using System;
using System.Collections.Generic;

namespace MusicApp.ViewModels
{
    public class SongDetailViewModel
    {
        public Song Song { get; set; }
        public List<Miscellaneous> WeeksTop { get; set; }
        public string WeeksTopTitle { get; set; }
    }
}
