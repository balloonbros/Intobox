function setTutorial(tutorialElement, nextElement, prevElement, pager)
{
  var slider = tutorialElement.bxSlider({
    controls: false,
    pagerCustom: pager,
    onSlideBefore: function(slideElement, oldIndex, newIndex) {
      if (newIndex == slider.getSlideCount() - 1) {
        prevElement.fadeIn(300);
        nextElement.fadeOut(300);
      }
      else if (newIndex == 0) {
        nextElement.fadeIn(300);
        prevElement.fadeOut(300);
      }
      else {
        nextElement.fadeIn(300);
        prevElement.fadeIn(300);
      }
    }
  });

  nextElement.click(function() {
    if (slider.getCurrentSlide() == slider.getSlideCount() - 1) {
      return;
    }
    slider.goToNextSlide();
  });

  prevElement.click(function() {
    if (slider.getCurrentSlide() == 0) {
      return;
    }
    slider.goToPrevSlide();
  });
}

$(document).ready(function() {
  var next = $('#next-tutorial img');
  var prev = $('#prev-tutorial img');
  var tutorial = $('#intobox-tutorial .js-tutorial');
  setTutorial(tutorial, next, prev, '#bx-pager');
});
