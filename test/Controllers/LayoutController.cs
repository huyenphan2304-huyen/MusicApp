using test.Models;
using System;
using System.Linq;
using System.Web.Mvc;

namespace test.Controllers
{
    public class LayoutController : Controller
    {
        private MusicDbDataContext db = new MusicDbDataContext(System.Configuration.ConfigurationManager.ConnectionStrings["MusicDbDataContext"].ConnectionString);

        // GET: Layout
        protected override void OnActionExecuting(ActionExecutingContext filterContext)
        {
            base.OnActionExecuting(filterContext);
            // Fetch all the menus from the database
            var menus = db.Menus.ToList();

            // Pass the menu list to the ViewBag
            ViewBag.Menus = menus;
        }
    }
}
