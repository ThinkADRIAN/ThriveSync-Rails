//= require startup-framework/common-files/js/modernizr.custom
//= require startup-framework/common-files/js/page-transitions
//= require startup-framework/common-files/js/jquery.scrollTo-1.4.3.1-min
//= require startup-framework/common-files/js/jquery.parallax.min
//= require startup-framework/common-files/js/easing.min
//= require startup-framework/common-files/js/startup-kit
//= require startup-framework/common-files/js/jquery.svg.js
//= require startup-framework/common-files/js/jquery.svganim
//= require startup-framework/common-files/js/jquery.backgroundvideo.min

// Dropdown Menu Fix for Mobile
// https://github.com/designmodo/startup-support/issues/43
$('a.dropdown-toggle').click('button', function() {
  $('a.dropdown-toggle').collapse('display');
});