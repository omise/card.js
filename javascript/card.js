$(".call-api-omise-card").click(function(){
    setTimeout(function(){
    $(".include-omise-card").addClass('loading-content');
    },600);
    var iframe = $(".card-iframe");
    iframe.attr("src", iframe.data("src"));
    $(".card-iframe").show();

    $(".wrapper-section-card").addClass('active');
    $("body").addClass('fix-scroll');
});

$(".close-modal").click(function(){
    $(".include-omise-card").removeClass('loading-content');
    $("body").removeClass('fix-scroll');
    alert("Hey");
});

