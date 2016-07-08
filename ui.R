#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
source("helpers.R")

shinyUI(fluidPage(
  title = 'Attrition Benchmark Choices',
  sidebarLayout(
    sidebarPanel(
      selectInput(
        'transitionPeriod', 'Select Transition Period', choices = transitions,
        selectize = FALSE
      ),
      selectInput(
        'interType', 'Select Interaction Type',
        choices = overall,
        selectize = FALSE
      ),
      selectizeInput(
        'e2', '2. Multi-select', choices = state.name, multiple = TRUE
      ),
      selectizeInput(
        'e3', '3. Item creation', choices = state.name,
        options = list(create = TRUE)
      ),
      selectizeInput(
        'e4', '4. Max number of options to show', choices = state.name,
        options = list(maxOptions = 5)
      ),
      selectizeInput(
        'e5', '5. Max number of items to select', choices = state.name,
        multiple = TRUE, options = list(maxItems = 2)
      ),
      # I() indicates it is raw JavaScript code that should be evaluated, instead
      # of a normal character string
      selectizeInput(
        'e6', '6. Placeholder', choices = state.name,
        options = list(
          placeholder = 'Please select an option below',
          onInitialize = I('function() { this.setValue(""); }')
        )
      ),
      selectInput(
        'e7', '7. selectInput() does not respond to empty strings',
        choices = state.name
      )
    ),
    mainPanel(
      helpText('Output of the examples in the left:'),
      verbatimTextOutput('ex_out'),
      # use Github instead
      selectizeInput('github', 'Select a Github repo', choices = '', options = list(
        valueField = 'url',
        labelField = 'name',
        searchField = 'name',
        options = list(),
        create = FALSE,
        render = I("{
                   option: function(item, escape) {
                   return '<div>' +
                   '<strong><img src=\"http://brianreavis.github.io/selectize.js/images/repo-' + (item.fork ? 'forked' : 'source') + '.png\" width=20 />' + escape(item.name) + '</strong>:' +
                   ' <em>' + escape(item.description) + '</em>' +
                   ' (by ' + escape(item.username) + ')' +
                   '<ul>' +
                   (item.language ? '<li>' + escape(item.language) + '</li>' : '') +
                   '<li><span>' + escape(item.watchers) + '</span> watchers</li>' +
                   '<li><span>' + escape(item.forks) + '</span> forks</li>' +
                   '</ul>' +
                   '</div>';
                   }
                   }"),
        score = I("function(search) {
                  var score = this.getScoreFunction(search);
                  return function(item) {
                  return score(item) * (1 + Math.min(item.watchers / 100, 1));
                  };
        }"),
        load = I("function(query, callback) {
                 if (!query.length) return callback();
                 $.ajax({
                 url: 'https://api.github.com/legacy/repos/search/' + encodeURIComponent(query),
                 type: 'GET',
                 error: function() {
                 callback();
                 },
                 success: function(res) {
                 callback(res.repositories.slice(0, 10));
                 }
                 });
        }")
      )),
      helpText('If the above searching fails, it is probably the Github API limit
               has been reached (5 per minute). You can try later.'),
      verbatimTextOutput('github')
      )
      )
      ))