$(function() {
  setTimeout(function(){
    $('#modal').addClass('loading-content loading-form fadeUp')
    $('.call-modal').addClass('hide');
    $('html').addClass('full-screen');
    $('body').addClass('animated');
    $('.submit-card').removeClass('hide');
    $("#full_name").focus();
  },1000);
});

// $(".call-modal").on("click", function(){
//   $("#modal").load($(this).attr("page"));
//   $('#modal').addClass('loading-form animated bounceIn');
//   $('.call-modal').addClass('hide');
//   $('html').addClass('full-screen');
//   $('body').addClass('animated');
//   $('.submit-card').removeClass('hide');
// });

$(".button-load").click(function(){
    var iframe = $("#myiFrame");
    iframe.attr("src", iframe.data("src"));
    $("#myiFrame").show();
    $("#myiFrame").addClass('fadeUp');
});



