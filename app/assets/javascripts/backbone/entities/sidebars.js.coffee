@OMGtd.module "SidebarsApp", (Left, App, Backbone, Marionette, $, _) ->
  @leftElements = [
    {state: 'inbox'},
    {state: 'active',     group: 'calendar',  label: 'today'},
    {state: 'active',     group: 'kind',      label: 'next'},
    {state: 'active',     group: 'calendar',  label: 'tomorrow'},
    {state: 'active',     group: 'kind',      label: 'scheduled'},
    {state: 'active',     group: 'kind',      label: 'cycled'},
    {state: 'active',     group: 'kind',      label: 'waiting'},
    {state: 'active',     group: 'kind',      label: 'someday'},
    {state: 'trash'},
    {state: 'completed'}
  ]