using MusicApp.Models;
using PagedList;
using System;
using System.Configuration;
using System.Linq;
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
        public ActionResult Create(Event @event)
        {
            if (ModelState.IsValid)
            {
                db.Events.InsertOnSubmit(@event);
                db.SubmitChanges();
                return RedirectToAction("Index");
            }
            return View(@event);
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
        public ActionResult Edit(Event @event)
        {
            if (ModelState.IsValid)
            {
                var existingEvent = db.Events.FirstOrDefault(e => e.Id == @event.Id);
                if (existingEvent != null)
                {
                    existingEvent.Title = @event.Title;
                    existingEvent.Place = @event.Place;
                    existingEvent.Date = @event.Date;
                    existingEvent.ImageUrl = @event.ImageUrl;
                    existingEvent.Description = @event.Description;
                    existingEvent.Meta = @event.Meta;
                    existingEvent.Hide = @event.Hide;
                    existingEvent.Order = @event.Order;
                    existingEvent.DateBegin = @event.DateBegin;

                    db.SubmitChanges();
                }
                return RedirectToAction("Index");
            }
            return View(@event);
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
    }
}
