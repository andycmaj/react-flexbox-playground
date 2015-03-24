FormsMixin        = require '../mixins/form'
Reflux            = require 'reflux'
{flexParentStore, flexChildStore} = require '../stores'
{Parent, Child} = require '../actions'

classSet = (set) -> (key for key, value of set when value is true).join(" ")

FlexboxSettingsChild = React.createClass
  displayName: 'FlexboxSettingsChild'
  mixins: [FormsMixin]
  onRemoveClick: ->
    Child.itemRemoved @props.id
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
      Child.allItemsChanged(e.target.name, e.target.value)
    else
      Child.itemChanged(@props.id, e.target.name, e.target.value)

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
    Parent.itemChanged(e.target.name, e.target.value)

  createChildren: ->
    for key, value of @state.children
      <FlexboxSettingsChild key={key} id={key} {...value} label='Flex Child' />
  render: ->
    <ul className="flexbox-settings">
      <li className='flex-actions'>
        <button className='icon-plus' onClick={Child.itemAdded}></button>
        <button className='icon-minus' onClick={-> Child.itemRemoved()}></button>
      </li>
      <li className='flex-parent-setting'>
        <div className='header'>Flex Parent</div>
        <div className="form">{@createForm(@state.self)}</div>
      </li>

      <FlexboxSettingsChild open={true} label='Flex Children' className='flex-children-setting' key={'all'} id={'all'} {...@state.children[Object.keys(@state.children)[0]]} />
      {@createChildren()}
    </ul>

module.exports = {FlexboxSettingsChild, FlexboxSettingsParent}
