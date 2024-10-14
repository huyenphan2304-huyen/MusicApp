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
        public ActionResult BreadcumbArea()
        {
            var breadcrumb = db.Breadcrumbs.FirstOrDefault();

            return PartialView("BreadcumbArea",breadcrumb);
        }

    }
}