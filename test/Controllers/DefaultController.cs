using MusicApp.Models; // Make sure to include your models namespace
using System.Configuration;
using System.Linq;
using System.Web.Mvc;

namespace MusicApp.Controllers
{
    public class DefaultController : Controller
    {
        private MusicDbDataContext db = new MusicDbDataContext(ConfigurationManager.ConnectionStrings["MusicDbDataContext"].ConnectionString);

        // GET: Default
        public ActionResult Menu()
        {
            // Fetch all the menus from the database
            var menus = db.Menus.ToList();

            // Pass the menu list to the view
            return View(menus);
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
