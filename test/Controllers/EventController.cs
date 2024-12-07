using MusicApp.Models;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace MusicApp.Controllers
{
    public class EventController : Controller
    {
        private MusicDbDataContext db = new MusicDbDataContext(ConfigurationManager.ConnectionStrings["MusicDbDataContext"].ConnectionString);

        // GET: Event
        public ActionResult Index()
        {

            return View("events");
        }

        public ActionResult getEvents()
        {
            var events = db.Events.ToList();
            return PartialView("getEvents",events);
        }
        public ActionResult getOtherEvents(int currentEventId)
        {
            var events = db.Events.Where(e => e.Id != currentEventId).Take(5).ToList();
            return PartialView("getOtherEvents", events);
        }



        public ActionResult EventDetails(int id)
        {
            // Truy vấn sự kiện từ cơ sở dữ liệu
            var eventDetail = db.Events.SingleOrDefault(e => e.Id == id);

            if (eventDetail == null)
            {
                return HttpNotFound();
            }

            // Lưu thông tin sự kiện vào ViewBag
            ViewBag.Id = eventDetail.Id;
            ViewBag.Title = eventDetail.Title;
            ViewBag.Place = eventDetail.Place;
            ViewBag.Description = eventDetail.Description;
            ViewBag.ImageUrl = eventDetail.ImageUrl;
            ViewBag.Date = eventDetail.Date; // Đảm bảo Date là DateTime

            return View("EventDetails",eventDetail); // Trả về view
        }
        public ActionResult BreadcumbArea()
        {
            var breadcrumb = db.Breadcrumbs.FirstOrDefault();

            return PartialView("BreadcumbArea", breadcrumb);
        }

    }
}