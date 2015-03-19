{ResizableBox}    = require 'react-resizable'
FormsMixin        = require './mixins/form'
Reflux            = require 'reflux'
clone             = require 'lodash/lang/clone'

classSet = (set) -> (key for key, value of set when value is true).join(" ")

ChildActions = Reflux.createActions [
  'itemAdded'
  'allItemsChanged'
  'itemChanged'
  'itemRemoved'
]

ParentActions = Reflux.createActions [
  'itemChanged'
]

flexBoxStyles =
  parent:
    display: type: "Select", selected: 'flex', options: ['flex', 'inline-flex']
    flexDirection: type: "Select", selected: 'row', options: ['row', 'row-reverse', 'column', 'column-reverse']
    justifyContent: type: "Select", selected: 'flex-start', options: ['flex-start', 'center', 'flex-end', 'space-between', 'space-around']
    flexWrap: type: "Select", selected: 'nowrap', options: ['nowrap', 'wrap', 'wrap-reverse']
    alignItems: type: "Select", selected: 'stretch', options: ['stretch', 'flex-start', 'center', 'flex-end', 'baseline']
    alignContent: type: "Select", selected: 'stretch', options: ['stretch', 'flex-start', 'center', 'flex-end', 'space-between', 'space-around']

  child:
    width: type: "String", value: null
    height: type: "String", value: null
    flexBasis: type: "String", value: null
    flexGrow: type: "Number", value: 1
    flexShrink: type: "Number", value: null
    order: type: "Number", value: null
    alignSelf: type: "Select", selected: null, options: ['flex-start', 'center', 'flex-end', 'baseline', 'stretch']

flexParentStore = Reflux.createStore
  listenables: ParentActions
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

flexChildStore = Reflux.createStore
  listenables: ChildActions
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

FlexboxSettingsChild = React.createClass
  displayName: 'FlexboxSettingsChild'
  mixins: [FormsMixin]
  onRemoveClick: ->
    ChildActions.itemRemoved @props.id
  onClick: ->
    @setState open: !@state.open
  getInitialState: ->
    open: if @props.open? then @props.open else false
  className: -> classSet
    header: true
    open: @state.open

  styles: ->
    display: if @state.open then 'block' else 'none'

  onChange: (e) ->
    if @props.id is 'all'
      ChildActions.allItemsChanged(e.target.name, e.target.value)
    else
      ChildActions.itemChanged(@props.id, e.target.name, e.target.value)

  render: ->
    <li className={@props.className || 'flex-child-setting'}>
      <div className={@className()} onClick={@onClick}>
        {@props.label}
        <i className="icon-remove" onClick={@onRemoveClick}></i>
      </div>
      <div className="form" style={@styles()}>{@createForm(@props)}</div>
    </li>

FlexboxSettingsParent = React.createClass
  displayName: 'FlexboxSettingsParent'
  mixins: [
    Reflux.connect(flexChildStore, "children")
    Reflux.connect(flexParentStore, "self")
    FormsMixin
  ]
  onChange: (e) ->
    ParentActions.itemChanged(e.target.name, e.target.value)

  createChildren: ->
    for key, value of @state.children
      <FlexboxSettingsChild key={key} id={key} {...value} label='Flex Child' />
  render: ->
    <ul className="flexbox-settings">
      <li className='flex-actions'>
        <button className='icon-plus' onClick={ChildActions.itemAdded}></button>
        <button className='icon-minus' onClick={-> ChildActions.itemRemoved()}></button>
      </li>
      <li className='flex-parent-setting'>
        <div className='header'>Flex Parent</div>
        <div className="form">{@createForm(@state.self)}</div>
      </li>

      <FlexboxSettingsChild open={true} label='Flex Children' className='flex-children-setting' key={'all'} id={'all'} {...@state.children[Object.keys(@state.children)[0]]} />
      {@createChildren()}
    </ul>

FlexboxChild = React.createClass
  displayName: 'FlexboxChild'
  render: ->
    <div className='flexbox-child' style={@props.activeStyles}></div>

FlexboxParent = React.createClass
  displayName: 'FlexboxParent'
  mixins: [Reflux.connect(flexChildStore, "items"), Reflux.connect(flexParentStore, "self")]
  createItems: ->
    for key, value of @state.items
      <FlexboxChild key={key} id={key} {...value} />
  render: ->
    <div className='flexbox-parent' style={@state.self.activeStyles}>
      {@createItems()}
    </div>

module.exports = React.createClass
  displayName: 'App'
  render: ->
    <div className='app'>
      <div className="flexbox-playground">
        <ResizableBox
          className="react-resizable"
          width={0.8 * (window.innerWidth - 200)}
          height={0.8 * window.innerHeight}
          minConstraints={[100, 100]} maxConstraints={[0.95 * (window.innerWidth - 200), 0.95 * window.innerHeight]}>

          <FlexboxParent />
        </ResizableBox>
      </div>

      <FlexboxSettingsParent />
    </div>
