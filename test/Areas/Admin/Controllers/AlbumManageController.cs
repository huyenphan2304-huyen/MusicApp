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
                // Xử lý hình ảnh tải lên
                if (CoverImage != null && CoverImage.ContentLength > 0)
                {
                    var fileName = Path.GetFileName(CoverImage.FileName);
                    var path = Path.Combine(Server.MapPath("~/Content/img"), fileName);
                    CoverImage.SaveAs(path);
                    album.CoverImageUrl = "/Content/img/" + fileName;
                }

                // Tạo giá trị meta và Url từ Title
                album.Meta = GenerateSlug(album.Title);
                album.Url = "/album/" + album.Meta;

                // Lưu album vào cơ sở dữ liệu
                db.Albums.InsertOnSubmit(album);
                db.SubmitChanges();

                return RedirectToAction("Index");
            }
            return View(album);
        }

        private string GenerateSlug(string title)
        {
            // Chuyển đổi tiêu đề thành dạng URL thân thiện (slug)
            string slug = title.ToLower().Trim();
            slug = System.Text.RegularExpressions.Regex.Replace(slug, @"\s+", "-"); // Thay khoảng trắng bằng dấu gạch ngang
            slug = System.Text.RegularExpressions.Regex.Replace(slug, @"[^a-z0-9-]", ""); // Loại bỏ ký tự đặc biệt
            return slug;
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
                // Tạo lại giá trị meta và Url từ Title (nếu Title bị thay đổi)
                album.Meta = GenerateSlug(album.Title);
                album.Url = "/album/" + album.Meta;

                // Cập nhật album
                db.Albums.Attach(album);
                db.Refresh(System.Data.Linq.RefreshMode.KeepCurrentValues, album);
                db.SubmitChanges();

                return RedirectToAction("Index");
            }
            return View(album);
        }

    }
}
