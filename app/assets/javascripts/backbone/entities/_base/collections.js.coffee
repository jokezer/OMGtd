@OMGtd.module "Entities", (Entities, App, Backbone, Marionette, $, _) ->
	
	class Entities.Collection extends Backbone.PageableCollection
    mode: 'client'