using MusicApp.Models;
using PagedList;
using System;
using System.Collections.Generic;
using System.Configuration;
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
            var albums = db.Albums.ToList(); // Giả sử bạn có bảng Albums
            if (albums == null || !albums.Any())
            {
                // Nếu không có album nào hoặc albums null
                ViewBag.Message = "No albums found.";
                return View(); // Trả về view trống hoặc thông báo
            }
            ViewBag.Albums = albums;
            int pageNumber = page ?? 1; // Nếu không có page thì mặc định là trang 1
            var pagedAlbums = albums.ToPagedList(pageNumber, pageSize); // Đảm bảo trả về IPagedList
            return View(pagedAlbums); // Trả về IPagedList<MusicApp.Models.Playlist>
        }
      

        public ActionResult Create()
        {
            return View();
        }

        // POST: Admin/Album/Create
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Create(Album album)
        {
            if (ModelState.IsValid)
            {
                db.Albums.InsertOnSubmit(album); // Thêm album vào bảng Albums
                db.SubmitChanges(); // Lưu thay đổi vào database
                return RedirectToAction("Index"); // Chuyển hướng về trang Index
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
            return View(album); // Nếu không hợp lệ, giữ nguyên view Create với lỗi
        }


        // GET: Admin/Album/Delete/5
        public ActionResult Delete(int id)
        {
            var album = db.Albums.FirstOrDefault(a => a.Id == id); // Tìm album theo Id
            if (album == null)
            {
                return HttpNotFound(); // Nếu album không tồn tại, trả về lỗi 404
            }
            return View(album); // Trả về view với album cần xóa
        }

        // POST: Admin/Album/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public ActionResult DeleteConfirmed(int id)
        {
            var album = db.Albums.FirstOrDefault(a => a.Id == id); // Tìm album cần xóa
            if (album == null)
            {
                return HttpNotFound(); // Nếu album không tồn tại, trả về lỗi 404
            }

            db.Albums.DeleteOnSubmit(album); // Xóa album khỏi bảng
            db.SubmitChanges(); // Lưu thay đổi vào database
            return RedirectToAction("Index"); // Chuyển hướng về trang danh sách
        }

        // GET: Admin/Album/Edit/5
        public ActionResult Edit(int id)
        {
            var album = db.Albums.FirstOrDefault(a => a.Id == id); // Tìm album theo Id
            if (album == null)
            {
                return HttpNotFound(); // Nếu album không tồn tại, trả về lỗi 404
            }
            return View(album); // Trả về view với album cần sửa
        }

        // POST: Admin/Album/Edit/5
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Edit(Album album)
        {
            if (ModelState.IsValid)
            {
                db.Albums.Attach(album); // Gắn album đã chỉnh sửa vào database
                db.Refresh(System.Data.Linq.RefreshMode.KeepCurrentValues, album); // Cập nhật album với giá trị mới
                db.SubmitChanges(); // Lưu thay đổi vào database
                return RedirectToAction("Index"); // Chuyển hướng về trang danh sách
            }
            return View(album); // Nếu dữ liệu không hợp lệ, trả về form chỉnh sửa với lỗi
        }

    }
}
