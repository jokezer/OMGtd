class Gtd.Models.Todo extends Backbone.Model
  url: '/todos'
  paramRoot: 'todo'
  defaults: {
    title: '',
    content: ''
  }