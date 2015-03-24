{ResizableBox}    = require 'react-resizable'
{FlexboxSettingsChild, FlexboxSettingsParent}         = require './components/flexbox-settings'
{FlexboxPresentationChild, FlexboxPresentationParent} = require './components/flexbox-presentation'

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

          <FlexboxPresentationParent />
        </ResizableBox>
      </div>

      <FlexboxSettingsParent />
    </div>
