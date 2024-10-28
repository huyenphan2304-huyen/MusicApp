using MusicApp.Models;
using MusicApp.ViewModels;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace MusicApp.Controllers
{
    public class LibraryController : Controller
    {
        private MusicDbDataContext db = new MusicDbDataContext(ConfigurationManager.ConnectionStrings["MusicDbDataContext"].ConnectionString);

        // GET: Library
        public ActionResult Index()
        {
            return View("Library");
        }
        // Action để lấy danh sách playlist
        public ActionResult MyPlaylists()
        {
            ViewBag.MyPlaylistName = "My Playlist";
            // Lấy danh sách playlist từ cơ sở dữ liệu
            var playlists = db.Playlists
                .Select(p => new PlaylistViewModel
                {
                    Id = p.Id,
                    PlaylistName = p.PlaylistName,
                    PlaylistDescription = p.PlaylistDescription,
                    CreatedBy = p.User.Username, // Tên người tạo playlist
                    CreatedDate = p.CreatedDate.GetValueOrDefault(DateTime.Now), // Sử dụng giá trị mặc định nếu null
                    FirstSongCoverImageUrl = p.PlaylistSongs
                        .OrderBy(ps => ps.AddedDate) // Lấy bài hát được thêm đầu tiên
                        .Select(ps => ps.Song.CoverImageUrl) // Lấy ảnh bìa bài hát
                        .FirstOrDefault() // Lấy ảnh bìa của bài hát đầu tiên
                }).ToList();

            return PartialView("MyPlaylists", playlists); // Trả về partial view
        }
        public ActionResult MyFavorite()
        {
            var favoriteSongs = db.Songs
                 .Where(s => (bool)s.IsFavorite)  // Chỉ lấy những bài hát có IsFavorite = 1 (true)
                 .Select(s => new SongViewModel
                 {
                     Song = s,
                     ArtistName = s.Artist.Name  // Lấy tên nghệ sĩ từ bảng Artists
                }).ToList();

            ViewBag.Title = "My Favorite"; // Đặt tiêu đề cho view

            return PartialView("Myfavorite",favoriteSongs);  // Trả về view với danh sách các bài hát yêu thích
        }
    }
    
}