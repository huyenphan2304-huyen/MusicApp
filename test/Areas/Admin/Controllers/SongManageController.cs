using MusicApp.Models;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using PagedList; // Thư viện để phân trang

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
        public ActionResult Create(Song song)
        {
            if (ModelState.IsValid)
            {
                db.Songs.InsertOnSubmit(song); // Thêm bài hát vào cơ sở dữ liệu
                db.SubmitChanges(); // Lưu thay đổi vào database
                return RedirectToAction("Index"); // Quay lại danh sách bài hát
            }
            else
            {
                // Kiểm tra lỗi của ModelState
                var errors = ModelState.Values.SelectMany(v => v.Errors);
                foreach (var error in errors)
                {
                    System.Diagnostics.Debug.WriteLine(error.ErrorMessage);
                }
            }

            return View(song); // Nếu không hợp lệ, hiển thị lại form nhập dữ liệu
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
        public ActionResult Edit(Song song)
        {
            if (ModelState.IsValid)
            {
                db.Songs.Attach(song); // Gắn bài hát đã chỉnh sửa vào database
                db.Refresh(System.Data.Linq.RefreshMode.KeepCurrentValues, song); // Cập nhật giá trị mới cho bài hát
                db.SubmitChanges(); // Lưu thay đổi vào database
                return RedirectToAction("Index"); // Quay lại danh sách bài hát
            }
            return View(song); // Nếu không hợp lệ, hiển thị lại form chỉnh sửa
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