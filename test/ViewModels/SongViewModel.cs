using MusicApp.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace MusicApp.ViewModels
{
    public class SongViewModel
    {
        public Song Song { get; set; }
        public string ArtistName { get; set; }

    }
}