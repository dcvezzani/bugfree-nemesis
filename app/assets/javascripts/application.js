// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require underscore
// require backbone
// require backbone_rails_sync
// require backbone_datalink
// require backbone/clf004
//
//= require_tree .
//
// THIS MUST GO LAST
//= require ../bootstrap/js/bootstrap.min
//= require ../bootstrap_wizard/prettify
//= require ../bootstrap_wizard/jquery.bootstrap.wizard
//= require ../jquery.ui.theme.lightness/js/jquery-ui-1.8.22.custom.min
//= require ../jquery.timepicker/js/jquery-ui-timepicker-addon

// void() stopped working?!
function xvoid(){}

  //va.add(".page-navigation", 
  function adjust_page_navigation(prop, win){
    var size = {small: 170, medium: 220, large: 270};

    if($(win).width() > 1180){
      $(prop).width(size.large);
    } else if($(win).width() > 960){
      $(prop).width(size.medium);
    } else if($(win).width() > 750){
      $(prop).width(size.small);
      $(prop).removeClass("narrow");
    }
    
    if($(win).width() < 750){
      $(prop).width("auto");
      $(prop).addClass("narrow");
    }
  }

