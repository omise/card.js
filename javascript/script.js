//= require jquery
//= require bootstrap
//= require_self

$(function() {
  $('body').addClass('show-time');
});

$(".call-modal").on("click", function(){
  $("#modal").load($(this).attr("page"));
  $('#modal').addClass('loading-form');
  $('.call-modal').addClass('hide');
  $('#modal').addClass('animated bounceIn');
});
