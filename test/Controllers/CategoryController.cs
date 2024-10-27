using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Configuration;

using MusicApp.Models;
using MusicApp.ViewModels;
namespace MusicApp.Controllers
{
    public class CategoryController : Controller
    {
        private MusicDbDataContext db = new MusicDbDataContext(ConfigurationManager.ConnectionStrings["MusicDbDataContext"].ConnectionString);

        // GET: Category
        public ActionResult Index()
        {
            // Lấy 5 thể loại đầu tiên
            var categories = db.Categories.Take(5).ToList();

            // Trả về view với danh sách thể loại và bài hát
            return View("Category", categories);
        }
    }
}