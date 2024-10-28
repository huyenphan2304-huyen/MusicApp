using System; // Đảm bảo rằng namespace System được bao gồm để sử dụng DateTime
using System.Linq;
using System.Web.Mvc;
using System.Configuration; // Thư viện để sử dụng ConfigurationManager
using MusicApp.Models;
using MusicApp.ViewModels;

namespace YourNamespace.Controllers // Thay bằng namespace của bạn
{
    public class PlaylistController : Controller
    {
        private MusicDbDataContext db = new MusicDbDataContext(ConfigurationManager.ConnectionStrings["MusicDbDataContext"].ConnectionString);

        public ActionResult Index()
        {
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

            ViewBag.CategoryName = "Playlists"; // Đặt tên thể loại

            return View(playlists);
        }
        // Action để lấy thông tin chi tiết của một playlist
        // Action để lấy thông tin chi tiết của một playlist
        public ActionResult PlaylistDetail(int id)
        {
            // Tìm playlist theo ID
            var playlist = db.Playlists
                .Where(p => p.Id == id)
                .Select(p => new PlaylistDetailViewModel
                {
                    Id = p.Id,
                    PlaylistName = p.PlaylistName,
                    PlaylistDescription = p.PlaylistDescription,
                    CreatedBy = p.User.Username,
                    CreatedDate = p.CreatedDate,
                    Songs = p.PlaylistSongs.Select(ps => new SongViewModel
                    {
                        Song = ps.Song,
                        ArtistName = ps.Song.Artist.Name // Lấy tên của nghệ sĩ
                    }).ToList()
                })
                .FirstOrDefault();

            if (playlist == null)
            {
                return HttpNotFound("Playlist not found");
            }

            return View(playlist);
        }
    }
}
