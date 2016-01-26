# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ready = ->
  # show editing form
  $('.edit-question-link').click (e) ->
    e.preventDefault()
    $('.edit-question-form').show();

  # discard results, hide editing form
  $('.btn-discard-question').click (e) ->
    $('.edit-question-form').hide();

  # vote
  $('.question-voting .vote-up, .vote-down').bind 'ajax:success', (e, data, status, xhr) ->
    response = $.parseJSON(xhr.responseText);
    question = $(".question");
    question.find('.rating').text(response.rating);
    question.find('.vote-up, .vote-down').addClass('hide');
    question.find('.vote-recall').removeClass('hide');

  # unvote
  $('.question-voting .vote-recall').bind 'ajax:success', (e, data, status, xhr) ->
    response = $.parseJSON(xhr.responseText);
    question = $(".question");
    question.find('.rating').text(response.rating);
    question.find('.vote-up, .vote-down').removeClass('hide');
    question.find('.vote-recall').addClass('hide');

$(document).ready(ready) # "вешаем" функцию ready на событие document.ready
$(document).on('page:load', ready)  # "вешаем" функцию ready на событие page:load
$(document).on('page:update', ready) # "вешаем" функцию ready на событие page:update