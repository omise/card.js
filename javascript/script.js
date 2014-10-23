//= require jquery
//= require bootstrap
//= require_self

$(function() {
  $('.container-form-modal').addClass('animated bounceInDown');
});

$(".call-modal").on("click", function(){
  $("#modal").load($(this).attr("page"));
  $('#modal').addClass('loading-form animated bounceIn');
  $('.call-modal').addClass('hide');
  $('body').addClass('animated');
});
