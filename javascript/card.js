// $(function() {
//   setTimeout(function(){
//     $('#modal').addClass('loading-content loading-form fadeUp')
//     $('.call-modal').addClass('hide');
//     $('html').addClass('full-screen');
//     $('body').addClass('animated');
//     $('.submit-card').removeClass('hide');
//     $("#full_name").focus();
// },1000);
// });

$(".button-load").click(function(){
    setTimeout(function(){
        var iframe = $("#myiFrame");
        iframe.attr("src", iframe.data("src"));
        $("#myiFrame").show();
        $("#myiFrame").addClass('fadeUp');
    },1000);
});



