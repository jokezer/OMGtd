describe "Main layout", ->
#  addTodo()
#  restaurants_data = [
#    {},
#    {},
#    {},
#    {},
#    {},
#    {}
#  ]
#  invisible_table = document.createElement 'table'
#
#  beforeEach ->
#    @restaurants_collection = new Gourmet.Collections.RestaurantsCollection restaurants_data
#    @restaurants_view = new Gourmet.Views.RestaurantsView
#      collection: @restaurants_collection
#      el: invisible_table
#
#  it "should be defined", ->
#    expect(Gourmet.Views.RestaurantsView).toBeDefined()
#
#  it "should have the right element", ->
#    expect(@restaurants_view.el).toEqual invisible_table
#
#  it "should have the right collection", ->
#    expect(@restaurants_view.collection).toEqual @restaurants_collection