using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using test.Models;
namespace test.Controllers
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
        public ActionResult GetFeaturedSongs()
        {
            // Lấy danh sách các bài hát nổi bật (IsFeatured = 1)
            var featuredSongs = db.Songs.Where(song => (bool)song.IsFeatured).ToList();

            // Trả về view với dữ liệu các bài hát nổi bật
            return PartialView("_FeaturedSongsSlide", featuredSongs);
        }
    }
}