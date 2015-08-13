# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  # show editing form
  $(".edit-question-link").click (e) ->
    e.preventDefault()
    $(".edit-question-form").show();

$ ->
  # discard results, hide editing form
  $(".btn-discard-question").click (e) ->
    $(".edit-question-form").hide();
#    $("#question_title").val($('.page-header').text());
#    $("#question_body").val($('.question-body').text())
