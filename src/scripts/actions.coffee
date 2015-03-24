Reflux = require 'reflux'

module.exports =
  Child: Reflux.createActions [
    'itemAdded'
    'allItemsChanged'
    'itemChanged'
    'itemRemoved'
  ]

  Parent: Reflux.createActions [
    'itemChanged'
  ]
