clone             = require 'lodash/lang/clone'
Reflux            = require 'reflux'
flexBoxStyles     = require './flexbox-styles'
{Parent, Child}   = require './actions'

module.exports =
  flexParentStore: Reflux.createStore
    listenables: Parent
    getInitialState: -> @state
    init: ->
      @state = {}
      availableStyles = flexBoxStyles['parent']
      item =
        availableStyles: availableStyles
        activeStyles: Object.keys(availableStyles).reduce((memo, key) =>
          options = availableStyles[key]
          value = if options.type is 'Number' then options.value else options.selected
          memo[key] = value
          return memo
        , {})
      @state = item
    onItemChanged: (attribute, value) ->
      @state.activeStyles[attribute] = value
      @update()

    update: (state = @state) ->
      @trigger state

  flexChildStore: Reflux.createStore
    listenables: Child
    getInitialState: -> @state
    init: ->
      @state = {}
      @onItemAdded()

    onAllItemsChanged: (attribute, value) ->
      for id in Object.keys(@state)
        @state[id].activeStyles[attribute] = value
      @update()

    onItemChanged: (id, attribute, value) ->
      @state[id].activeStyles[attribute] = value
      @update()

    onItemRemoved: (id) ->
      ids = Object.keys(@state)
      id ?= ids[ids.length - 1]

      delete @state[id]
      @update()

    onItemAdded: ->
      ids = Object.keys(@state)
      if !!ids.length
        item = clone @state[ids[ids.length - 1]], true
      else
        availableStyles = flexBoxStyles['child']
        item = do ->
          availableStyles: availableStyles
          activeStyles: Object.keys(availableStyles).reduce((memo, key) =>
            options = availableStyles[key]
            value = if options.type is 'Number' then options.value else options.selected
            memo[key] = value
            return memo
          , {})

      @state["id_#{Date.now()}"] = item
      @update()
    update: (state = @state) ->
      @trigger state