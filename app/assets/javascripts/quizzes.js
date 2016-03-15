$(document).ready(function() {
  var quiz = new UserTest('question_container', 'next_question', 'timer')
  quiz.initialise();
});

function UserTest(questionContainerId, nextButtonId, timerId) {
  var that = this;

  this.initialise = function() {
    this.questionContainer = $("#" + questionContainerId);
    this.addEvents();
    this.startTimer();
  };

  this.addEvents = function() {
    this.questionContainer.on('click', '#' + nextButtonId, this.getNextQuestion);
  };

  this.startTimer = function() {
    this.timer = $('#' + timerId);
    if (this.timer.length) {
      this.remainingTime = this.timer.data('polling_time');
      var time = Number(this.questionContainer.find('.panel').data('timer'));
      this.setTimer(time);
      this.timerId = setTimeout(this.updateTimer, this.remainingTime * 1000);
      this.secondsTimerId = setInterval(this.updateSecondsTimer, 1000);
      console.log(this.timerId, this.secondsTimerId);
    }
  };

  this.updateSecondsTimer = function() {
    var secondsArea = $('#seconds');
    var minutesArea = $('#minutes');
    var seconds = Number(secondsArea.text());
    var minutes = Number(minutesArea.text());
    that.remainingTime--;
    if (!seconds) {
      secondsArea.text(59);
      minutes--;
      minutesArea.text(minutes);
    }
    else {
      seconds--;
      secondsArea.text(seconds);
    }
  };

  this.updateTimer = function() {
    var time = Number($('#minutes').text());
    $.ajax({
      url: that.timer.data('href'),
      data: { format: 'js', code: that.questionContainer.data('code') },
      dataType: 'html',
      success: function(data) {
          if (data < that.timer.data('polling_time'))
            that.timerId = setTimeout(that.updateTimer, (data - 1) * 1000);
          else {
            that.setTimer(Number(data));
            that.timerId = setTimeout(that.updateTimer, that.timer.data('polling_time') *  1000);
          }
      },
      error: function(jqXHR, textStatus, errorThrown) {
        if (jqXHR.status == 302) {
          clearInterval(that.secondsTimerId);
          clearTimeout(that.timerId);
          window.location.href = jqXHR.responseText;
        } else
          $('body').html("<h1>" + textStatus + ": " + jqXHR.status + ", " + errorThrown + "</h1>");
      }
    });
    that.remainingTime = that.timer.data('polling_time');
  };

  this.setTimer = function(time) {
    minutes = parseInt(time/60, 10);
    seconds = time%60;
    if (!seconds) {
      minutes --;
      seconds = 59;
    }
    this.timer.html(["Time Left - ", this.createTimerBox(minutes).attr('id','minutes'), ":", this.createTimerBox(seconds).attr('id', 'seconds')]);
  };

  this.createTimerBox = function(value) {
    return $('<span/>').text(value).addClass('timer-box');
  }

  
  this.getNextQuestion = function() {
    clearInterval(that.secondsTimerId);
    clearTimeout(that.timerId);
    var answer = that.getAnswer();
    $.ajax({
      url: $(this).data('href'),
      data: { 'answer': answer, 'code': that.questionContainer.data('code') },
      dataType: 'html',
      success: function(data, textStatus, xhr){
        that.questionContainer.find('.question-box').html(data);
        that.timerId = setTimeout(that.updateTimer, that.remainingTime * 1000);
        that.secondsTimerId = setInterval(that.updateSecondsTimer, 1000);
      },
      error: function(jqXHR, textStatus, errorThrown){
        if (jqXHR.status == 302) {
          clearInterval(that.secondsTimerId);
          clearTimeout(that.timerId);
          window.location.href = jqXHR.responseText;
        } else
          $('body').html("<h1>" + textStatus + ": " + jqXHR.status + ", " + errorThrown + "</h1>");
      }
    });
  };

  this.getAnswer = function() {
    var option = $('input[name="answer"][type="radio"]:checked').val();
    var answer = $('input[name="answer"][type="text"]').val();
    if (option)
      return option
    else
      return answer
  };

}