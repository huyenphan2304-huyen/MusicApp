using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using MusicApp.Models;
namespace MusicApp.Controllers
{
    public class HomeController : Controller
    {
        private MusicDbDataContext db = new MusicDbDataContext(ConfigurationManager.ConnectionStrings["MusicDbDataContext"].ConnectionString);

        public ActionResult Index()
        {
            return View();
        }

        public ActionResult About()
        {
            ViewBag.Message = "Your application description page.";

            return View();
        }

        public ActionResult Contact()
        {
            ViewBag.Message = "Your contact page.";

            return View();
        }
        public ActionResult RecommendLatestAlbums()
        {
            // Lấy danh sách các bài hát nổi bật (IsFeatured = 1)
            var recommendLatestAlbums = db.Albums.OrderByDescending(album => album.ReleaseDate).Take(2).ToList();

            // Trả về view với dữ liệu các bài hát nổi bật
            return PartialView("RecommendLatestAlbums", recommendLatestAlbums);
        }

        public ActionResult LatestAlbums()
        {
            // Lấy danh sách các album từ database
            var latestAlbums = db.Albums.ToList();

            // Truyền danh sách album vào View
            return PartialView("LatestAlbums",latestAlbums);
        }

        public ActionResult RecommendedAlbums()
        {
            // Lấy danh sách các album được đề xuất từ database
            var recommendedAlbums = db.Albums.ToList(); // Có thể thay đổi điều kiện nếu cần

            // Truyền danh sách album vào View
            return PartialView("RecommendedAlbums", recommendedAlbums);
        }

        public ActionResult FirstFeaturedArtist()
        {
            // Lấy nghệ sĩ nổi bật (giả sử có điều kiện cho nghệ sĩ nổi bật)
            var featuredArtist = db.Artists.FirstOrDefault();

            // Trả về PartialView với dữ liệu nghệ sĩ nổi bật
            return PartialView("FirstFeaturedArtist", featuredArtist);
        }


    }
}