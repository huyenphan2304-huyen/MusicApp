using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace MusicApp.ViewModels
{
    public class PlaylistViewModel
    {
        public int Id { get; set; }
        public string PlaylistName { get; set; }
        public string PlaylistDescription { get; set; }
        public string FirstSongCoverImageUrl { get; set; } // URL của hình ảnh bìa bài hát đầu tiên
        public string CreatedBy { get; set; } // Tên người tạo playlist
        public DateTime CreatedDate { get; set; } // Ngày tạo
    }
}
