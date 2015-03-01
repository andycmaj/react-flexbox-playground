React = require 'react'
require '../stylesheets/init.less'

# Assign React to Window so the Chrome React Dev Tools will work.
window.React = React

App = require './app'

React.render <App />, document.body
