module.exports =
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