# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
Rails.application.config.assets.precompile += %w( projects.js projects.css
  home.css catalogs.css categories.css project_search.css episodes.css
  bootstrap-datetimepicker.css bootstrap-datetimepicker.js bootstrap-datetimepicker.zh-CN.js
  simditor/simditor.css simditor/all.js simditor/use.js
  rich_media.css fund_rankings.css quickrank.css
  one_page.css
  headers/header-default.css footers/footer-v1.css theme-colors/theme.css plugins/animate.css
  one_page.js
  one_page/app.js plugins/back-to-top.js plugins/smoothScroll.js
  owl-carousel/owl.carousel.css owl-carousel/owl.carousel.js owl-carousel/owl-carousel.js
  pages/page_log_reg_v1.css
  select2.css select2.js select2-zh-CN.js)
