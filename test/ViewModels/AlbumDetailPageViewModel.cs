using MusicApp.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace MusicApp.ViewModels
{
    public class AlbumDetailPageViewModel
    {
        public AlbumDetailViewModel AlbumDetail { get; set; }
        public List<Menu> Menus { get; set; }
    }
}