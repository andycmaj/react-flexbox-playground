Reflux = require 'reflux'
{flexParentStore, flexChildStore} = require '../stores'

FlexboxPresentationChild = React.createClass
  displayName: 'FlexboxPresentationChild'
  render: ->
    <div className='flexbox-child' style={@props.activeStyles}></div>

FlexboxPresentationParent = React.createClass
  displayName: 'FlexboxPresentationParent'
  mixins: [Reflux.connect(flexChildStore, "items"), Reflux.connect(flexParentStore, "self")]
  createItems: ->
    for key, value of @state.items
      <FlexboxPresentationChild key={key} id={key} {...value} />
  render: ->
    <div className='flexbox-parent' style={@state.self.activeStyles}>
      {@createItems()}
    </div>

module.exports = {FlexboxPresentationChild, FlexboxPresentationParent}