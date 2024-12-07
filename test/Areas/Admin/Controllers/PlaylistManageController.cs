using MusicApp.Models;
using System;
using System.Linq;
using System.Configuration;
using System.Web.Mvc;
using PagedList;

namespace MusicApp.Areas.Admin.Controllers
{
    public class PlaylistManageController : Controller
    {
        private MusicDbDataContext db = new MusicDbDataContext(ConfigurationManager.ConnectionStrings["MusicDbDataContext"].ConnectionString);

        // GET: Admin/Playlist
        public ActionResult Index(int? page, int pageSize = 10)
        {
            var playlists = db.Playlists.OrderBy(p => p.PlaylistName); // Sắp xếp để phân trang ổn định
            if (playlists == null || !playlists.Any())
            {
                ViewBag.Message = "No playlists found.";
                return View();
            }

            int pageNumber = page ?? 1; // Nếu không có page thì mặc định là trang 1
            var pagedPlaylists = playlists.ToPagedList(pageNumber, pageSize); // Đảm bảo trả về IPagedList

            return View(pagedPlaylists); // Trả về IPagedList<MusicApp.Models.Playlist>
        }



        // GET: Admin/Playlist/Create
        public ActionResult Create()
        {
            ViewBag.Users = db.Users.ToList(); // Lấy danh sách user từ cơ sở dữ liệu

            return View();
        }

        // POST: Admin/Playlist/Create
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Create(Playlist playlist)
        {
            if (ModelState.IsValid)
            {
                playlist.CreatedDate = DateTime.Now;
                db.Playlists.InsertOnSubmit(playlist);
                db.SubmitChanges();
                return RedirectToAction("Index");
            }
            return View(playlist);
        }

        // GET: Admin/Playlist/Edit/5
        public ActionResult Edit(int id)
        {
            var playlist = db.Playlists.FirstOrDefault(p => p.Id == id);
            if (playlist == null)
            {
                return HttpNotFound();
            }
            ViewBag.Users = db.Users.ToList(); // Lấy danh sách user từ cơ sở dữ liệu

            return View(playlist);
        }

        // POST: Admin/Playlist/Edit/5
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Edit(Playlist playlist)
        {
            if (ModelState.IsValid)
            {
                var existingPlaylist = db.Playlists.FirstOrDefault(p => p.Id == playlist.Id);
                if (existingPlaylist != null)
                {
                    existingPlaylist.PlaylistName = playlist.PlaylistName;
                    existingPlaylist.PlaylistDescription = playlist.PlaylistDescription;
                    existingPlaylist.UserId = playlist.UserId;

                    db.SubmitChanges();
                }
                return RedirectToAction("Index");
            }
            return View(playlist);
        }

        // GET: Admin/Playlist/Delete/5
        public ActionResult Delete(int id)
        {
            var playlist = db.Playlists.FirstOrDefault(p => p.Id == id);
            if (playlist == null)
            {
                return HttpNotFound();
            }
            return View(playlist);
        }

        // POST: Admin/Playlist/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public ActionResult DeleteConfirmed(int id)
        {
            var playlist = db.Playlists.FirstOrDefault(p => p.Id == id);
            if (playlist != null)
            {
                db.Playlists.DeleteOnSubmit(playlist);
                db.SubmitChanges();
            }
            return RedirectToAction("Index");
        }
    }
}
