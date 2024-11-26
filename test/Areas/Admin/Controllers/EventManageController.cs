using MusicApp.Models;
using PagedList;
using System;
using System.Configuration;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace MusicApp.Areas.Admin.Controllers
{
    public class EventManageController : Controller
    {
        private MusicDbDataContext db = new MusicDbDataContext(ConfigurationManager.ConnectionStrings["MusicDbDataContext"].ConnectionString);

        // GET: Admin/Event
        public ActionResult Index(int? page, int pageSize = 10)
        {
            var events = db.Events.ToList();
            if (events == null || !events.Any())
            {
                ViewBag.Message = "No events found.";
                return View();
            }
            ViewBag.Message =  events;

            int pageNumber = page ?? 1;
            var pagedEvents = events.ToPagedList(pageNumber, pageSize);

            return View(pagedEvents);
        }


        // GET: Admin/Event/Create
        public ActionResult Create()
        {
            return View();
        }

        // POST: Admin/Event/Create
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Create(MusicApp.Models.Event model, HttpPostedFileBase ImageFile)
        {
            if (string.IsNullOrEmpty(model.Place))
            {
                ModelState.AddModelError("Place", "The Place field is required.");
                return View(model);
            }
            if (ModelState.IsValid)
            {
                if (ImageFile != null && ImageFile.ContentLength > 0)
                {
                    // Lưu hình ảnh vào thư mục trên server
                    var fileName = Path.GetFileName(ImageFile.FileName);
                    var path = Path.Combine(Server.MapPath("~/Content/Img/"), fileName);
                    ImageFile.SaveAs(path);

                    // Cập nhật đường dẫn hình ảnh
                    model.ImageUrl = "~/Content/img/" + fileName;
                }


                db.Events.InsertOnSubmit(model);
                db.SubmitChanges();
                return RedirectToAction("Index");
            }

            return View(model);
        }


        // GET: Admin/Event/Edit/5
        public ActionResult Edit(int id)
        {
            var @event = db.Events.FirstOrDefault(e => e.Id == id);
            if (@event == null)
            {
                return HttpNotFound();
            }
            return View(@event);
        }

        // POST: Admin/Event/Edit/5
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Edit(int id, MusicApp.Models.Event model)
        {
            var existingEvent = db.Events.FirstOrDefault(e => e.Id == id);
            if (existingEvent == null)
            {
                return HttpNotFound();
            }

            if (string.IsNullOrEmpty(model.Place))
            {
                ModelState.AddModelError("Place", "The Place field is required.");
                return View(model);
            }

            if (ModelState.IsValid)
            {
                // Update properties that do not involve the image
                existingEvent.Title = model.Title;
                existingEvent.Place = model.Place;
                existingEvent.Date = model.Date;
                existingEvent.Description = model.Description;
                existingEvent.Meta = model.Meta;
                existingEvent.Hide = model.Hide;
                existingEvent.Order = model.Order;
                existingEvent.DateBegin = model.DateBegin;

                // Check if a new image was uploaded
                var imageFile = Request.Files["ImageFile"];
                var imageUrl = SaveImage(imageFile);
                if (imageUrl != null)
                {
                    existingEvent.ImageUrl = imageUrl;
                }

                // Save changes to the database
                db.SubmitChanges();
                return RedirectToAction("Index");
            }

            return View(existingEvent);
        }


        // GET: Admin/Event/Delete/5
        public ActionResult Delete(int id)
        {
            var @event = db.Events.FirstOrDefault(e => e.Id == id);
            if (@event == null)
            {
                return HttpNotFound();
            }
            return View(@event);
        }

        // POST: Admin/Event/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public ActionResult DeleteConfirmed(int id)
        {
            var @event = db.Events.FirstOrDefault(e => e.Id == id);
            if (@event != null)
            {
                db.Events.DeleteOnSubmit(@event);
                db.SubmitChanges();
            }
            return RedirectToAction("Index");
        }

        private string SaveImage(HttpPostedFileBase imageFile)
        {
            if (imageFile == null || imageFile.ContentLength == 0)
            {
                return null;
            }

            // Extract the file name from the uploaded image
            var fileName = Path.GetFileName(imageFile.FileName);
            // Generate a unique file name (optional) to prevent overwriting
            var uniqueFileName = Guid.NewGuid().ToString() + Path.GetExtension(fileName);

            // Set the directory where you want to save the image
            var directoryPath = Server.MapPath("~/Content/img/");
            if (!Directory.Exists(directoryPath))
            {
                Directory.CreateDirectory(directoryPath); // Create the directory if it doesn't exist
            }

            // Save the image to the directory
            var filePath = Path.Combine(directoryPath, uniqueFileName);
            imageFile.SaveAs(filePath);

            // Return the relative path to the image
            return "/Content/img/" + uniqueFileName;
        }


    }
}
