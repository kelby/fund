// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
// require_tree .
//= require jquery
//= require jquery_ujs
//= require bootstrap-sprockets
//= require ie10-viewport-bug-workaround
//= require select2-full

$(document).on("click", "a.rucaptcha-image-box", function(e){
  reLoadRucaptchaImage(e)
});

var reLoadRucaptchaImage = function(e) {
  var btn, currentSrc, img;

  btn = $(e.currentTarget);
  // console.log(btn)
  // console.log('end btn')


  img = btn.find('img:first');
  // console.log(img)
  // console.log('end img')


  currentSrc = img.attr('src');
  // console.log(currentSrc)
  // console.log('end currentSrc')

  img.attr('src', currentSrc.split('?')[0] + '?' + (new Date()).getTime());
  return false;
}
