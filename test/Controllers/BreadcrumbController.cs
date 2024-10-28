using System.Linq;
using System.Web.Mvc;
using MusicApp.Models;

namespace MusicApp.Controllers
{
    public class BreadcrumbController : Controller
    {
        private MusicDbDataContext db = new MusicDbDataContext();

        // Action để lấy breadcrumb dựa trên trang hiện tại
        public PartialViewResult GetBreadcrumb(string pageTitle)
        {
            // Lấy thông tin breadcrumb từ cơ sở dữ liệu dựa trên tiêu đề trang
            var breadcrumb = db.Breadcrumbs.FirstOrDefault(b => b.Title == pageTitle);

            if (breadcrumb == null)
            {
                // Nếu không có breadcrumb cho trang này, trả về một breadcrumb mặc định
                breadcrumb = new Breadcrumb
                {
                    Title =  pageTitle,
                    Subtitle = pageTitle,
                    BackgroundImage = "/Content/img/bg-img/breadcumb3.jpg"
                };
            }

            // Trả về PartialView với model là breadcrumb
            return PartialView("_Breadcrumb", breadcrumb);
        }
    }
}
