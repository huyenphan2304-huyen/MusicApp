using MusicApp.Models;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using PagedList; // Thư viện để phân trang
using System.IO;

namespace MusicApp.Areas.Admin.Controllers
{
    public class SongManageController : Controller
    {
        private MusicDbDataContext db = new MusicDbDataContext(ConfigurationManager.ConnectionStrings["MusicDbDataContext"].ConnectionString);

        // GET: Admin/Song
        public ActionResult Index(int? page, int pageSize = 10)
        {
            var songs = db.Songs.ToList();
            if (songs == null || !songs.Any())
            {
                ViewBag.Message = "No songs found.";
                return View();
            }

            int pageNumber = page ?? 1;
            var pagedSongs = songs.ToPagedList(pageNumber, pageSize);

            return View(pagedSongs);
        }




        // GET: Admin/Song/Create
        public ActionResult Create()
        {
            return View();
        }

        // POST: Admin/Song/Create
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Create(Song Song, HttpPostedFileBase CoverImage, HttpPostedFileBase AudioFile)
        {
            if (ModelState.IsValid)
            {
                // Handle the Cover Image Upload
                if (CoverImage != null && CoverImage.ContentLength > 0)
                {
                    var coverImageFileName = Path.GetFileName(CoverImage.FileName);
                    var coverImagePath = Path.Combine(Server.MapPath("~/Content/img"), coverImageFileName);
                    CoverImage.SaveAs(coverImagePath);
                    Song.CoverImageUrl = "/Content/img/" + coverImageFileName;
                }

                // Handle the Audio File Upload (Song.Url)
                if (AudioFile != null && AudioFile.ContentLength > 0)
                {
                    var audioFileName = Path.GetFileName(AudioFile.FileName);
                    var audioFilePath = Path.Combine(Server.MapPath("~/Content/Audio/"), audioFileName);
                    AudioFile.SaveAs(audioFilePath);
                    Song.Url = "/Content/Audio/" + audioFileName;
                }

                // Insert the Song into the database
                db.Songs.InsertOnSubmit(Song);
                db.SubmitChanges();

                return RedirectToAction("Index");
            }
            else
            {
                // If there are model validation errors, output them to the debug console
                var errors = ModelState.Values.SelectMany(v => v.Errors);
                foreach (var error in errors)
                {
                    System.Diagnostics.Debug.WriteLine(error.ErrorMessage);
                }
            }

            // Return the Song model back to the view if there's a validation error
            return View(Song);
        }


        // GET: Admin/Song/Edit/5
        public ActionResult Edit(int id)
        {
            var song = db.Songs.FirstOrDefault(s => s.Id == id); // Tìm bài hát theo Id
            if (song == null)
            {
                return HttpNotFound(); // Nếu không tìm thấy bài hát, trả về lỗi 404
            }
            return View(song); // Trả về form chỉnh sửa bài hát
        }


        // POST: Admin/Song/Edit/5
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Edit(int id, Song Song, HttpPostedFileBase CoverImage, HttpPostedFileBase AudioFile)
        {
            if (ModelState.IsValid)
            {
                var existingSong = db.Songs.SingleOrDefault(s => s.Id == id);
                if (existingSong == null)
                {
                    return HttpNotFound();
                }

                string imgDirectory = Server.MapPath("~/Content/img");
                string audioDirectory = Server.MapPath("~/Content/Audio/");

                // Ensure directories exist
                if (!Directory.Exists(imgDirectory))
                {
                    Directory.CreateDirectory(imgDirectory);
                }

                if (!Directory.Exists(audioDirectory))
                {
                    Directory.CreateDirectory(audioDirectory);
                }

                // Handle the Cover Image Upload (if a new one is uploaded)
                if (CoverImage != null && CoverImage.ContentLength > 0)
                {
                    var allowedExtensions = new[] { ".jpg", ".jpeg", ".png", ".gif" };
                    var fileExtension = Path.GetExtension(CoverImage.FileName).ToLower();
                    if (!allowedExtensions.Contains(fileExtension))
                    {
                        ModelState.AddModelError("CoverImage", "Invalid file type for cover image.");
                        return View(Song);
                    }

                    var coverImageFileName = Path.GetFileName(CoverImage.FileName);
                    var coverImagePath = Path.Combine(imgDirectory, coverImageFileName);

                    // Ensure unique file name
                    int i = 1;
                    while (System.IO.File.Exists(coverImagePath))
                    {
                        coverImageFileName = Path.GetFileNameWithoutExtension(CoverImage.FileName) + i + fileExtension;
                        coverImagePath = Path.Combine(imgDirectory, coverImageFileName);
                        i++;
                    }

                    CoverImage.SaveAs(coverImagePath);
                    existingSong.CoverImageUrl = "/Content/img/" + coverImageFileName;
                }

                // Handle the Audio File Upload (if a new one is uploaded)
                if (AudioFile != null && AudioFile.ContentLength > 0)
                {
                    var allowedAudioExtensions = new[] { ".mp3", ".wav", ".ogg" };
                    var audioExtension = Path.GetExtension(AudioFile.FileName).ToLower();
                    if (!allowedAudioExtensions.Contains(audioExtension))
                    {
                        ModelState.AddModelError("AudioFile", "Invalid file type for audio.");
                        return View(Song);
                    }

                    var audioFileName = Path.GetFileName(AudioFile.FileName);
                    var audioFilePath = Path.Combine(audioDirectory, audioFileName);

                    // Ensure unique file name
                    int i = 1;
                    while (System.IO.File.Exists(audioFilePath))
                    {
                        audioFileName = Path.GetFileNameWithoutExtension(AudioFile.FileName) + i + audioExtension;
                        audioFilePath = Path.Combine(audioDirectory, audioFileName);
                        i++;
                    }

                    AudioFile.SaveAs(audioFilePath);
                    existingSong.Url = "/Content/Audio/" + audioFileName;
                }

                // Update the other properties
                existingSong.Title = Song.Title;
                existingSong.ArtistId = Song.ArtistId;
                existingSong.CategoryId = Song.CategoryId;
                existingSong.ReleaseDate = Song.ReleaseDate;
                existingSong.IsFeatured = Song.IsFeatured;
                existingSong.AlbumId = Song.AlbumId;
                existingSong.Meta = Song.Meta;
                existingSong.Hide = Song.Hide;
                existingSong.Order = Song.Order;
                existingSong.DateBegin = Song.DateBegin;
                existingSong.Lyrics = Song.Lyrics;
                existingSong.IsFavorite = Song.IsFavorite;

                // Save changes to the database
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

            return View(Song);
        }

        // GET: Admin/Song/Delete/5
        public ActionResult Delete(int id)
        {
            var song = db.Songs.FirstOrDefault(s => s.Id == id); // Tìm bài hát theo Id
            if (song == null)
            {
                return HttpNotFound(); // Nếu không tìm thấy bài hát, trả về lỗi 404
            }
            return View(song); // Trả về trang xác nhận xóa bài hát
        }

        // POST: Admin/Song/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public ActionResult DeleteConfirmed(int id)
        {
            var song = db.Songs.FirstOrDefault(s => s.Id == id); // Tìm bài hát cần xóa
            if (song == null)
            {
                return HttpNotFound(); // Nếu không tìm thấy bài hát, trả về lỗi 404
            }

            db.Songs.DeleteOnSubmit(song); // Xóa bài hát khỏi cơ sở dữ liệu
            db.SubmitChanges(); // Lưu thay đổi vào database
            return RedirectToAction("Index"); // Quay lại danh sách bài hát
        }

    }
}