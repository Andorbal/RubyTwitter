jQuery().ready(function() {
  jQuery("#micropost_content").bind("keyup click blur focus change paste", function() {
    jQuery("#micropost_content_length").text(140 - this.value.length);
  });
});
