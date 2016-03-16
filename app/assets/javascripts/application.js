// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require chartkick
//= require jquery
//= require jquery-ui
//= require jquery_ujs
//= require sharrre
//= require twitter/bootstrap
// require flatui
// require startup_framework
//= require jquery.slick
//= require chosen-jquery
//= require slick
//= require messages
// require bootstrap-material-design
//= require cocoon
//= require analytics
//= require custom_overrides

(function () {
    var qs, js, q, s, d = document, gi = d.getElementById, ce = d.createElement, gt = d.getElementsByTagName, id = 'typef_orm', b = 'https://s3-eu-west-1.amazonaws.com/share.typeform.com/';
    if (!gi.call(d, id)) {
        js = ce.call(d, 'script');
        js.id = id;
        js.src = b + 'share.js';
        q = gt.call(d, 'script')[0];
        q.parentNode.insertBefore(js, q)
    }
    id = id + '_';
    if (!gi.call(d, id)) {
        qs = ce.call(d, 'link');
        qs.rel = 'stylesheet';
        qs.id = id;
        qs.href = b + 'share-button.css';
        s = gt.call(d, 'head')[0];
        s.appendChild(qs, s)
    }
})()
