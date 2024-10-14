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

            // Lấy danh sách các menu chính (ParentId = NULL)
            var mainMenus = menus.Where(m => m.ParentId == null).ToList();

            // Tạo một dictionary để lưu các menu con dựa trên ParentId
            Dictionary<int, List<Menu>> subMenus = new Dictionary<int, List<Menu>>();

            foreach (var menu in mainMenus)
            {
                // Lấy các menu con tương ứng với từng menu chính
                var children = menus.Where(m => m.ParentId == menu.Id).ToList();
                subMenus[menu.Id] = children; // Lưu vào dictionary
            }

            // Đưa mainMenus và subMenus vào ViewBag để truyền đến PartialView
            ViewBag.MainMenus = mainMenus;
            ViewBag.SubMenus = subMenus;

            // Trả về view _Menu với danh sách menus
            return PartialView("GetMenu");
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
