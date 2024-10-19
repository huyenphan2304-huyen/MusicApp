using MusicApp.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace MusicApp.ViewModels
{
    public class AlbumDetailViewModel
    {
        public int Id { get; set; }
        public string Title { get; set; }
        public string Artist { get; set; }
        public string CoverImageUrl { get; set; }
        public DateTime? ReleaseDate { get; set; }
        public List<Song> Songs { get; set; } = new List<Song>();
        public List<Menu> Menus { get; set; } // Thêm thuộc tính Menus

    }
}