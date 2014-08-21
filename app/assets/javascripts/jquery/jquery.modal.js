/**
 * モーダルダイアログを表示するjQueryプラグイン
 */
;(function($){
  /**
   * マスクレイヤーのID
   */
  var MASK_LAYER_ID = 'modal-box-mask-layer';

  var globalOptions = {};

  var animationPixel = 10;

  $.fn.extend({
    /**
     * モーダルダイアログを表示する元となる要素に対してこのmodal関数を実行します。
     * モーダルダイアログは常に画面中央に表示されます。
     *
     * [仕様について]
     *   以下のdata属性を指定します。
     *
     *   [data-modal-dialog]
     *   ここに指定してある要素をダイアログボックスとして表示します。
     *
     *   [data-modal-dialog-closer]
     *   ここに指定してある要素をクリックするとダイアログボックスを閉じます。
     *
     * [オプション]
     *   top     ブラウザの画面の一番上からのマージン
     *   open    モーダルダイアログが開かれた時にコールバックされる関数
     *   closing モーダルダイアログが閉じられようとする時にコールバックされる関数
     *   closed  モーダルダイアログが閉じられた時にコールバックされる関数
     */
    modal: function(options) {
      options = $.extend({
        top: 100,
        open: undefined,
        closing: undefined,
        closed: undefined
      }, options);
      globalOptions = options;

      // ダイアログとして表示する要素を取得
      var modalDialog = $('#' + $(this).data('modal-dialog'));

      // ダイアログボックスを閉じるイベントを登録
      $('#' + $(this).data('modal-dialog-closer')).click(function() {
        closeModalDialog(modalDialog, options);
      });

      // 要素に対してクリックイベントを登録
      return this.click(function(e) {
        modalDialog.showModal(options);

        // デフォルトのクリック動作はキャンセル
        e.preventDefault();
      });
    },

    /**
     * モーダルダイアログを表示します。
     */
    showModal: function(options) {
      options = $.extend({
        top: 100,
        open: undefined,
        closeWithMask: false
      }, options);

      // マスクレイヤーがなければ作る
      var maskElement = $('#' + MASK_LAYER_ID);
      if (maskElement.length == 0) {
        maskElement = $('<div>').attr('id', MASK_LAYER_ID).appendTo($('body')).css({
          'position': 'fixed',
          'z-index': '10999',
          'top': '0px',
          'left': '0px',
          'height': '100%',
          'width': '100%',
          'background-color': '#000',
          'display': 'none',
          'opacity': '0.8'
        });
      }

      // マスクレイヤーを表示
      maskElement.fadeIn(300);

      // マスクをクリックして閉じる場合はマスク要素に閉じるイベントを登録しておく
      if (options.closeWithMask) {
        var context = $(this);
        maskElement.click(function() {
          closeModalDialog(context, options);
        });
      }

      // ダイアログボックスを表示
      $(this).css({
        'position' : 'fixed',
        'z-index': 11000,
        'left' : '50%',
        'margin-left' : -($(this).outerWidth() / 2) + 'px',
        'top' : (options.top - animationPixel) + 'px'
      }).animate({
        'top' : '+=' + animationPixel + 'px'
      }, {
        easing: 'easeOutQuint',
        duration: 900,
        queue: false,
      }).fadeIn(150, function() {
        // ダイアログボックス表示時のコールバック関数が指定されていれば呼び出す
        if (typeof options.open == 'function') {
          options.open.call(this);
        }
      });
    }
  });

  $.closeModal = function(modalDialog) {
    closeModalDialog(modalDialog, globalOptions)
  };

  /**
   * モーダルダイアログを閉じます。
   *
   * @param string modalDialog 閉じる対象のダイアログ要素
   * @param object options     modalを呼ばれた時に渡されたオプション
   */
  function closeModalDialog(modalDialog, options)
  {
    options = options || {};

    // マスクレイヤーとモーダルダイアログを非表示にする
    $('#' + MASK_LAYER_ID).fadeOut(300);
    modalDialog.animate({
      'top' : '-=' + animationPixel + 'px'
    }, {
      easing: 'easeOutQuint',
      duration: 900,
      queue: false
    });
    modalDialog.fadeOut(150, function() {
      if (typeof options.closed == 'function') {
        options.closed.call(modalDialog);
      }
    });

    // ダイアログボックスを閉じる時のコールバック関数が指定されていれば呼び出す
    if (typeof options.closing == 'function') {
      options.closing.call(modalDialog);
    }
  }
})(jQuery);
