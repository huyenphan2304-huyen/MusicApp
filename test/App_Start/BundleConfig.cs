using System.Web;
using System.Web.Optimization;

namespace MusicApp
{
    public class BundleConfig
    {
        public static void RegisterBundles(BundleCollection bundles)
        {

            // Bundles cho jQuery
            bundles.Add(new ScriptBundle("~/bundles/jquery").Include(
                        "~/Scripts/jquery/jquery-2.2.4.min.js"));

            // Bundles cho Bootstrap và Popper.js
            bundles.Add(new ScriptBundle("~/bundles/bootstrap").Include(
                        "~/Scripts/bootstrap/popper.min.js",
                        "~/Scripts/bootstrap/bootstrap.min.js"));

            // Bundles cho các plugin JS
            bundles.Add(new ScriptBundle("~/bundles/plugins").Include(
                        "~/Scripts/plugins/plugins.js",
                        "~/Scripts/active.js"));

            // Bundles cho các tệp CSS
            bundles.Add(new StyleBundle("~/Content/css").Include(
                        "~/Content/css/bootstrap.min.css",
                        "~/Content/css/classy-nav.css",
                        "~/Content/css/owl.carousel.min.css",
                        "~/Content/css/animate.css",
                        "~/Content/css/magnific-popup.css",
                        "~/Content/css/font-awesome.min.css",
                        "~/Content/css/audioplayer.css",
                        "~/Content/css/one-music-icon.css",
                        "~/Content/style.css"));


            // Bundle cho SCSS
            bundles.Add(new StyleBundle("~/Content/scss").Include(
                "~/Content/scss/fonts.scss",
                "~/Content/scss/mixin.scss",
                "~/Content/scss/responsive.scss",
                "~/Content/scss/theme_color.scss",
                "~/Content/style.scss"
            ));

            // Modernizr (nếu bạn cần dùng)
            bundles.Add(new ScriptBundle("~/bundles/modernizr").Include(
                        "~/Scripts/modernizr-*"));

        }
    }
}
