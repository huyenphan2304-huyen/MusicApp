using MusicApp.Models;
using PagedList;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace MusicApp.Areas.Admin.Controllers
{
    public class AlbumManageController : Controller
    {
        private MusicDbDataContext db = new MusicDbDataContext(ConfigurationManager.ConnectionStrings["MusicDbDataContext"].ConnectionString);

        // GET: Admin/Album
        public ActionResult Index(int? page, int pageSize = 10)
        {
            var albums = db.Albums.ToList();
            if (albums == null || !albums.Any())
            {
                ViewBag.Message = "No albums found.";
                return View();
            }
            ViewBag.Albums = albums;
            int pageNumber = page ?? 1;
            var pagedAlbums = albums.ToPagedList(pageNumber, pageSize);
            return View(pagedAlbums);
        }

        public ActionResult Create()
        {
            return View();
        }

        // POST: Admin/Album/Create
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Create(Album album, HttpPostedFileBase CoverImage)
        {
            if (ModelState.IsValid)
            {
                if (CoverImage != null && CoverImage.ContentLength > 0)
                {
                    // Tạo đường dẫn để lưu file
                    var fileName = Path.GetFileName(CoverImage.FileName);
                    var path = Path.Combine(Server.MapPath("~/Content/img"), fileName);

                    // Lưu file vào thư mục
                    CoverImage.SaveAs(path);

                    // Lưu đường dẫn file vào database
                    album.CoverImageUrl = "/Content/img/" + fileName;
                }

                db.Albums.InsertOnSubmit(album);
                db.SubmitChanges();

                return RedirectToAction("Index");
            }
            else
            {
                var errors = ModelState.Values.SelectMany(v => v.Errors);
                foreach (var error in errors)
                {
                    System.Diagnostics.Debug.WriteLine(error.ErrorMessage);
                }
            }
            return View(album);
        }

        public ActionResult Delete(int id)
        {
            var album = db.Albums.FirstOrDefault(a => a.Id == id);
            if (album == null)
            {
                return HttpNotFound();
            }
            return View(album);
        }

        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public ActionResult DeleteConfirmed(int id)
        {
            var album = db.Albums.FirstOrDefault(a => a.Id == id);
            if (album == null)
            {
                return HttpNotFound();
            }

            db.Albums.DeleteOnSubmit(album);
            db.SubmitChanges();
            return RedirectToAction("Index");
        }

        public ActionResult Edit(int id)
        {
            var album = db.Albums.FirstOrDefault(a => a.Id == id);
            if (album == null)
            {
                return HttpNotFound();
            }
            return View(album);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Edit(Album album)
        {
            if (ModelState.IsValid)
            {
                db.Albums.Attach(album);
                db.Refresh(System.Data.Linq.RefreshMode.KeepCurrentValues, album);
                db.SubmitChanges();
                return RedirectToAction("Index");
            }
            return View(album);
        }
    }
}
