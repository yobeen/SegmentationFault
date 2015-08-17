# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  $('.edit-answer-link').click (e) ->
    e.preventDefault();
    $(this).hide();
    answer_id = $(this).data('answerId')
    $('form#edit-answer-' + answer_id).show()

  # discard results, hide editing form
  $('.btn-discard-answer').click (e) ->
    $(this).show();
    answer_id = $(this).data('answerId')
    $('form#edit-answer-' + answer_id).hide()

  # vote
  $('.answer-voting').bind 'ajax:success', '.vote-up, .vote-down', (e, data, status, xhr) ->
    response = $.parseJSON(xhr.responseText);
    answer = $("#answer_#{response.id}");
    answer.find('.rating').text(response.rating);
    answer.find('.vote-up, .vote-down').addClass('hide');
    answer.find('.vote-recall').removeClass('hide');

  # unvote
  $('.answer-voting').bind 'ajax:success', '.vote-recall', (e, data, status, xhr) ->
    response = $.parseJSON(xhr.responseText);
    answer = $("#answer_#{response.id}");
    answer.find('.rating').text(response.rating);
    answer.find('.vote-up, .vote-down').removeClass('hide');
    answer.find('.vote-recall').addClass('hide');