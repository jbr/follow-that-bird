var FollowThatBird = {
  voteClicked: function() {
    var tweetDiv = $(this).parents('.tweet');
    var matcher = /tweet_(\d+)/;
    var match = matcher.exec(tweetDiv.attr('id'));
    var tweetId = match[1];

    var vote;
    if ($(this).hasClass("up")) {
      vote = "up";
    } else if ($(this).hasClass("down")) {
      vote = "down";
    }

    $.ajax({
      url: "/tweets/"+tweetId+"/"+vote,
      type: "POST",
      success: function () {
        if (tweetDiv.siblings().length == 0) {
          $('#show_more_tweets').show();  
        }
        tweetDiv.remove();
      },
      error: function(xhr, textStatus, errorThrown) {
        alert("Sorry, there was an error recording your vote.  Please try again later.");
      }
    });
  }
}

$(document).ready(function() {
  $('.tweet .vote').bind('click', FollowThatBird.voteClicked);
});
