function voteClicked() {
    var tweetDiv = $(this).parents('.tweet');
    var tweetDivId = tweetDiv.attr('id');
    var matcher = /tweet_(\d+)/;
    var match = matcher.exec(tweetDivId);
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
            tweetDiv.slideUp();
        },
        error: function(xhr, textStatus, errorThrown) {
            alert("Sorry, there was an error recording your vote.  Please try again later.");
        }
    });
}

$(function() {
    $('.tweet .vote').bind('click', voteClicked);
});