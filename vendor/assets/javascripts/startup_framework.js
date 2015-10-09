//= require common-files/js/modernizr.custom
//= require common-files/js/page-transitions
//= require common-files/js/jquery.scrollTo-1.4.3.1-min
//= require common-files/js/jquery.parallax.min
//= require common-files/js/easing.min
//= require common-files/js/startup-kit
//= require common-files/js/jquery.svg.js
//= require common-files/js/jquery.svganim
//= require common-files/js/jquery.backgroundvideo.min

// Dropdown Menu Fix for Mobile
// https://github.com/designmodo/startup-support/issues/43
$('a.dropdown-toggle').click('button', function() {
  $('a.dropdown-toggle').collapse('display');
});