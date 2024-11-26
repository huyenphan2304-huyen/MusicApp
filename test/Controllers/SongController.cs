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
        public ActionResult LastestSongs()
        {
            // Lấy danh sách tất cả các bài hát
            var songs = from s in db.Songs
                        join a in db.Artists on s.ArtistId equals a.Id
                        select new SongViewModel
                        {
                            Song = s,
                            ArtistName = a.Name
                        };

            // Trả về view ListSong với danh sách các bài hát
            return PartialView("LastestSongs", songs.ToList());
        }


        // Phương thức để hiển thị chi tiết bài hát theo Id
        public ActionResult SongDetail(int id)
        {
            // Lấy danh sách các bài hát
            var songs = db.Songs.ToList();

            // Tìm bài hát theo Id
            var song = songs.FirstOrDefault(s => s.Id == id);

            // Lấy danh sách Miscellaneous từ cơ sở dữ liệu, sắp xếp và lọc các mục không ẩn
            var miscellaneousItems = db.Miscellaneous
                .Where(m => !m.Hide) 
                .OrderBy(m => m.OrderPosition) 
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
                WeeksTop = weeksTop,
                WeeksTopTitle = "This Week's Top Hits", 
                CategoryId = (int)song.CategoryId 

            };
            ViewBag.Lyrics = song.Lyrics;

            return View("SongDetail", viewModel);
        }
        public ActionResult SongsByCategory(int categoryId)
        {
            // Lấy tên thể loại từ bảng Category
            var category = db.Categories.FirstOrDefault(c => c.Id == categoryId);
            if (category == null)
            {
                return HttpNotFound("Thể loại không tồn tại.");
            }
            // Lấy danh sách các bài hát theo CategoryId được chỉ định
            var songs = from s in db.Songs
                        join a in db.Artists on s.ArtistId equals a.Id
                        where s.CategoryId == categoryId // Lọc theo CategoryId
                        select new SongViewModel
                        {
                            Song = s,
                            ArtistName = a.Name
                        };
            if (!songs.Any())
            {
                return HttpNotFound("Không tìm thấy bài hát trong thể loại này.");
            }
            // Trả về view với danh sách các bài hát theo thể loại
            ViewBag.CategoryName = category.Name; // Ghi nhận CategoryName để sử dụng trong view
            return PartialView("SongsByCategory", songs.ToList());
        }
        public ActionResult LoadSongs()
        {
            var songs = db.Songs.ToList(); // Lấy dữ liệu mới nhất từ cơ sở dữ liệu
            return PartialView("LoadSongs", songs); // Trả về PartialView với danh sách bài hát
        }

        public ActionResult GetListSongByCategory(String categoryName)
        {
            // Get the list of songs by category from the database
            var songs = db.Songs.Where(s => s.Category.Name == categoryName).ToList();  // Example query, adjust as needed

            // Create a list of SongViewModel
            var songViewModels = from s in songs
                                 join a in db.Artists on s.ArtistId equals a.Id
                                 select new SongViewModel
                                 {
                                     Song = s,
                                     ArtistName = a.Name
                                 };

            // Create CategoryViewModel
            var categoryViewModel = new CategoryViewModel
            {
                Category = new Category { Name = categoryName },
                Songs = songViewModels.ToList()
            };

            // Pass data to the View
            return PartialView("GetListSongByCategory", categoryViewModel); // Passing CategoryViewModel to the view
        }

    }
}
