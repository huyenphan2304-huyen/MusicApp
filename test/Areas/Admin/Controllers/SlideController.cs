using MusicApp.Models;
using MusicApp.ViewModels;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace MusicApp.Areas.Admin.Controllers
{
    public class SlideController : Controller
    {
        private MusicDbDataContext db = new MusicDbDataContext(ConfigurationManager.ConnectionStrings["MusicDbDataContext"].ConnectionString);

        // GET: Admin/Slide
        // GET: Admin/Slide
        public ActionResult Index()
        {
            var slides = db.Slides.Select(s => new SlideViewModel
            {
                Id = s.Id,
                AlbumTitle = s.Album.Title,
                CreatedDate = s.CreatedDate, // No need to cast to DateTime
                Meta = s.Meta,
                Hide = s.Hide, // Handle nullable bool
                Order = s.Order.HasValue ? s.Order.Value : 0, // Handle nullable int
                DateBegin = s.DateBegin // No need to cast to DateTime
            }).ToList();

            if (slides == null || !slides.Any())
            {
                ViewBag.Message = "No slides found.";
                return View();
            }
            return View(slides);
        }



        // GET: Admin/Slide/Create
        // GET: Admin/Slide/Create
        public ActionResult Create()
        {
            // Lấy tổng số slide hiện có
            var totalSlides = db.Slides.Count();

            // Tạo model mới
            var model = new Slide
            {
                Hide = false
            };

            // Thêm Slide mới và gán Meta là "slide-id"
            db.Slides.InsertOnSubmit(model);
            db.SubmitChanges();

            // Cập nhật Meta sau khi tạo slide và lấy ID của slide mới
            model.Meta = "slide-" + model.Id;

            // Cập nhật Meta vào cơ sở dữ liệu
            db.SubmitChanges();

            ViewBag.AlbumList = new SelectList(db.Albums, "Id", "Title");

            return View(model);
        }


        // POST: Admin/Slide/Create
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Create(Slide slide)
        {
            if (ModelState.IsValid)
            {
                db.Slides.InsertOnSubmit(slide);
                db.SubmitChanges();

                // Cập nhật lại Meta sau khi có ID
                slide.Meta = "slide-" + slide.Id;

                // Cập nhật Meta vào cơ sở dữ liệu
                db.SubmitChanges();

                return RedirectToAction("Index");
            }

            ViewBag.AlbumId = new SelectList(db.Albums, "Id", "Title", slide.AlbumId);
            return View(slide);
        }


        // GET: Admin/Slide/Edit/5
        public ActionResult Edit(int id)
        {
            var slide = db.Slides.FirstOrDefault(s => s.Id == id);
            if (slide == null)
            {
                return HttpNotFound();
            }
            ViewBag.AlbumId = new SelectList(db.Albums, "Id", "Title", slide.AlbumId);
            return View(slide);
        }

        // POST: Admin/Slide/Edit/5
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Edit(Slide slide)
        {
            if (ModelState.IsValid)
            {
                db.Slides.Attach(slide);
                db.Refresh(System.Data.Linq.RefreshMode.KeepCurrentValues, slide);
                db.SubmitChanges();
                return RedirectToAction("Index");
            }

            ViewBag.AlbumId = new SelectList(db.Albums, "Id", "Title", slide.AlbumId);
            return View(slide);
        }

        // GET: Admin/Slide/Delete/5
        public ActionResult Delete(int id)
        {
            var slide = db.Slides.FirstOrDefault(s => s.Id == id);
            if (slide == null)
            {
                return HttpNotFound();
            }
            return View(slide);
        }

        // POST: Admin/Slide/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public ActionResult DeleteConfirmed(int id)
        {
            var slide = db.Slides.FirstOrDefault(s => s.Id == id);
            if (slide == null)
            {
                return HttpNotFound();
            }

            db.Slides.DeleteOnSubmit(slide);
            db.SubmitChanges();
            return RedirectToAction("Index");
        }

        public JsonResult GetAlbumInfo(int id)
        {
            var album = db.Albums.FirstOrDefault(a => a.Id == id);
            if (album != null)
            {
                return Json(new { Title = album.Title, Artist = album.Artist }, JsonRequestBehavior.AllowGet);
            }
            return Json(null, JsonRequestBehavior.AllowGet);
        }
    }
}
