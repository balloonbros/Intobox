$(document).ready(function() {
  $('#about-facebook-signin-icon').hover(function() {
    var icon = $(this);
    $('#about-facebook-signin').css({
      top: icon.offset().top + icon.height() + 18,
      left: icon.offset().left - ($('#about-facebook-signin').width() / 2) - 2
    }).show();
  }, function() {
    $('#about-facebook-signin').hide();
  });

  slider = $('#intobox-screens').bxSlider({
    controls: false,
    pager: false,
    auto: true,
    pause: 7000
  });
  $('#next-screen').click(function() { slider.goToNextSlide(); });
  $('#prev-screen').click(function() { slider.goToPrevSlide(); });
});
