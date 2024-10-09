using System.Web.Mvc;
using System.Web.Optimization;
using System.Web.Routing; // Đảm bảo dòng này đã có
using System.Web; // Đảm bảo dòng này đã có

namespace MusicApp
{
    public class MvcApplication : HttpApplication
    {
        protected void Application_Start()
        {
            AreaRegistration.RegisterAllAreas();
            FilterConfig.RegisterGlobalFilters(GlobalFilters.Filters);
            RouteConfig.RegisterRoutes(RouteTable.Routes); // Đây là dòng gây lỗi
            BundleConfig.RegisterBundles(BundleTable.Bundles);
        }
    }
}
