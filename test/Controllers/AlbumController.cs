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
    public class AlbumController : Controller
    {
        private MusicDbDataContext db = new MusicDbDataContext(ConfigurationManager.ConnectionStrings["MusicDbDataContext"].ConnectionString);

        // GET: Album
        public ActionResult Index()
        {
            // Lấy danh sách album từ cơ sở dữ liệu
            var albums = db.Albums.ToList(); // Giả sử bạn có bảng Albums
            ViewBag.Albums = albums;

            return View("Album");
        }

        // Lấy danh sách BrowserCategories
        public ActionResult BrowserCategories()
        {
            var categories = db.BrowserCategories.ToList();
            return PartialView("BrowserCategories", categories);
        }
        // GET: Album/AlbumDetail/5
        // Trong AlbumController.cs
        public ActionResult AlbumDetail(String meta, int id)
        {
            var album = db.Albums
                .Where(a => a.Id == id && a.Meta == meta)
                .Select(a => new AlbumDetailViewModel
                {
                    Id = a.Id,
                    Title = a.Title,
                    Artist = a.Artist,
                    CoverImageUrl = a.CoverImageUrl,
                    ReleaseDate = a.ReleaseDate,
                    Songs = db.Songs.Where(s => s.AlbumId == a.Id).ToList()
                })
                .SingleOrDefault();

            if (album == null)
            {
                return HttpNotFound();
            }

            var viewModel = new AlbumDetailPageViewModel
            {
                AlbumDetail = album,
                Menus = db.Menus.ToList()
            };

            return View(viewModel);
        }

    }
}
