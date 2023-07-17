$(function() {
    // AjaxリクエストにCSRFトークンを追加する設定
    $.ajaxSetup({
        headers: {
            'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content')
        }
    });

    $('.favourite-link').on('click', function(e) {
      e.preventDefault();

      const postId = $(this).data('postId');
      const userId = $(this).data('userId');
      const isFavourited = $(this).data('isFavourited');

      if (isFavourited) {
        $.ajax({
          url: `/posts/${postId}/favourites`,
          type: 'DELETE',
          dataType: 'json',
          success: function(data) {
            const favouriteCount = $('.favourite-count');
            favouriteCount.text(data.favourite_count);
            $(this).data('isFavourited', false);
          },
          error: function(data) {
            alert('Error: ' + data);
          }
        });
      } else {
        $.ajax({
          url: `/posts/${postId}/favourites`,
          type: 'POST',
          data: { user_id: userId },
          dataType: 'json',
          success: function(data) {
            const favouriteCount = $('.favourite-count');
            favouriteCount.text(data.favourite_count);
            $(this).data('isFavourited', true);
          },
          error: function(data) {
            alert('Error: ' + data);
          }
        });
      }
    });
});
