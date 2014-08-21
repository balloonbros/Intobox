/**
 * グローバルメニューの初期化をする
 * メニューアイコンのクリックでメニューの表示をトグルさせる
 */
$(document).ready(function() {
  var icon = $('#popover-menu-icon');

  if (icon.length > 0) {
    var el = $('#popover-menu');

    // メニューアイコンのホバー画像をトグルする
    icon.hover(
      function() {
        $('#popover-menu-icon-image').hide();
        $('#popover-menu-icon-hover-image').show();
      },
      function() {
        $('#popover-menu-icon-image').show();
        $('#popover-menu-icon-hover-image').hide();
      }
    );

    // メニューアイコンをクリックしたらメニューエリアの表示をトグルさせる
    icon.bind('click', function() {
      if (el.is(':visible')) {
        el.hide();

        // bodyタグのクリックイベントを削除
        $('body').unbind('click.globalmenu');
      } else {
        var iconImage = $('#popover-menu-icon-hover-image');
        el.css({
          top: iconImage.offset().top + iconImage.height(),
          left: iconImage.offset().left - el.width() + 40
        }).show();

        // クリックされたのがグローバルメニューアイコン以外かつ
        // グローバルメニューエリア外であれば隠すようにする
        $('body').bind('click.globalmenu', function(e) {
          // イベント発生元の要素を取得
          var target = $(e.target);

          // 発生元要素がグローバルメニューエリア内かどうかをチェック
          var isMenuArea = false;
          target.parents().each(function() {
            if ($(this).hasClass('js-popover-menu')) {
              isMenuArea = true;
              return false;
            }
          });

          // グローバルメニューアイコン内かどうかもチェックして
          // エリア外をクリックされたのであればメニューエリアを閉じる
          if (!isMenuArea && !target.parent().hasClass('js-popover-menu-icon')) {
            el.hide();

            // bodyタグのクリックイベントを削除
            $('body').unbind('click.globalmenu');
          }
        });
      }
    });
  }

  $('#account-setting').click(function() {
    $('#popover-menu').hide();
    return false;
  }).modal();

  $('#about-intobox').click(function() {
    $('#popover-menu').hide();
    return false;
  }).modal();
});
