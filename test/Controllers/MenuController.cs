using MusicApp.Models;  // Chứa lớp Menu
using System.Collections.Generic;
using System.Linq;
using System.Web.Mvc;

namespace MusicApp.Controllers
{
    public class MenuController : Controller
    {
        private MusicDbDataContext db = new MusicDbDataContext(System.Configuration.ConfigurationManager.ConnectionStrings["MusicDbDataContext"].ConnectionString);

        // GET: Menu
        public ActionResult GetMenu()
        {
            // Lấy tất cả các menu từ cơ sở dữ liệu
            var menus = db.Menus.ToList();

            // Trả về view _Menu với danh sách menus
            return PartialView("GetMenu", menus);
        }
        public ActionResult GetMenuForFooter()
        {
            // Lấy tất cả các menu từ cơ sở dữ liệu
            var menus = db.Menus.Where(m => m.Name != "Login" && m.Name != "Register").ToList();

            // Trả về view _Menu với danh sách menus đã loại bỏ phần "Account"
            return PartialView("FooterMenu", menus);
        }

    }
}
