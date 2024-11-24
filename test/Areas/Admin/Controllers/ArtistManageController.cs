using MusicApp.Models;
using PagedList;
using System;
using System.Configuration;
using System.Linq;
using System.Web.Mvc;

namespace MusicApp.Areas.Admin.Controllers
{
    public class ArtistManageController : Controller
    {
        private MusicDbDataContext db = new MusicDbDataContext(ConfigurationManager.ConnectionStrings["MusicDbDataContext"].ConnectionString);

        // GET: Admin/Artist
        public ActionResult Index(int? page, int pageSize = 10)
        {
            var Artists = db.Artists.ToList();
            if (Artists == null || !Artists.Any())
            {
                ViewBag.Message = "No Artists found.";
                return View();
            }

            int pageNumber = page ?? 1;
            var pagedArtists = Artists.ToPagedList(pageNumber, pageSize);

            return View(pagedArtists);
        }

       

        //  MusicDbContext(MusicApp.Models)
        // GET: Admin/Artist/Create
        public ActionResult Create()
        {

            return View(new Artist()); // Truyền đối tượng Artist rỗng vào View
        }

        // POST: Admin/Artist/Create
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Create(Artist artist)
        {
            if (ModelState.IsValid)
            {
                db.Artists.InsertOnSubmit(artist);
                db.SubmitChanges();
                return RedirectToAction("Index");
            }
            return View(artist);
        }

        // GET: Admin/Artist/Edit/5
        public ActionResult Edit(int id)
        {
            var artist = db.Artists.FirstOrDefault(a => a.Id == id);
            if (artist == null)
            {
                return HttpNotFound();
            }
            return View(artist);
        }

        // POST: Admin/Artist/Edit/5
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Edit(Artist artist)
        {
            if (ModelState.IsValid)
            {
                var existingArtist = db.Artists.FirstOrDefault(a => a.Id == artist.Id);
                if (existingArtist != null)
                {
                    existingArtist.Name = artist.Name;
                    existingArtist.ImageUrl = artist.ImageUrl;
                    existingArtist.BackgroundImageUrl = artist.BackgroundImageUrl;
                    existingArtist.Description = artist.Description;
                    existingArtist.Meta = artist.Meta;
                    existingArtist.Hide = artist.Hide;
                    existingArtist.Order = artist.Order;
                    existingArtist.DateBegin = artist.DateBegin;

                    db.SubmitChanges();
                }
                return RedirectToAction("Index");
            }
            return View(artist);
        }

        // GET: Admin/Artist/Delete/5
        public ActionResult Delete(int id)
        {
            var artist = db.Artists.FirstOrDefault(a => a.Id == id);
            if (artist == null)
            {
                return HttpNotFound();
            }
            return View(artist);
        }

        // POST: Admin/Artist/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public ActionResult DeleteConfirmed(int id)
        {
            var artist = db.Artists.FirstOrDefault(a => a.Id == id);
            if (artist != null)
            {
                db.Artists.DeleteOnSubmit(artist);
                db.SubmitChanges();
            }
            return RedirectToAction("Index");
        }
    }
}
