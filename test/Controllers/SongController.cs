using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Web.Mvc;
using MusicApp.Models;
using MusicApp.ViewModels;

namespace MusicApp.Controllers
{
    public class SongController : Controller
    {
        private MusicDbDataContext db = new MusicDbDataContext(ConfigurationManager.ConnectionStrings["MusicDbDataContext"].ConnectionString);

        public ActionResult Index()
        {
            return View("Song");
        }
        public ActionResult ListSong()
        {
            // Lấy danh sách tất cả các bài hát
            var songs = db.Songs.ToList();

            // Trả về view ListSong với danh sách các bài hát
            return View("ListSong", songs);
        }

        // GET: Song/Detail/5
        // Phương thức để hiển thị chi tiết bài hát theo Id
        public ActionResult SongDetail(int id)
        {
            // Lấy danh sách các bài hát
            var songs = db.Songs.ToList();

            // Tìm bài hát theo Id
            var song = songs.FirstOrDefault(s => s.Id == id);

            // Lấy danh sách Miscellaneous từ cơ sở dữ liệu, sắp xếp và lọc các mục không ẩn
            var miscellaneousItems = db.Miscellaneous
                .Where(m => !m.Hide) // Chỉ lấy những mục không bị ẩn
                .OrderBy(m => m.OrderPosition) // Sắp xếp theo OrderPosition
                .ToList();

            // Chia thành các nhóm cho This Week's Top Hits
            var weeksTop = miscellaneousItems.Where(m => m.Type == "Top").ToList();

            // Nếu không tìm thấy bài hát, trả về trang lỗi hoặc thông báo
            if (song == null)
            {
                return HttpNotFound("Song not found");
            }

            // Tạo ViewModel cho bài hát và các thông tin liên quan
            var viewModel = new SongDetailViewModel
            {
                Song = song,
                WeeksTop = weeksTop, // Danh sách top hits tuần này
                WeeksTopTitle = "This Week's Top Hits" // Tiêu đề cho phần top hits
            };

            // Trả về view SongDetail với dữ liệu ViewModel
            return View("SongDetail", viewModel);
        }
    }
}
