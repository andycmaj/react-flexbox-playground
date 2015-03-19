
module.exports =
  inputString: (flexItem, attribute, options) ->
    <input value={flexItem.activeStyles[attribute]} onChange={@onChange} name={attribute} />

  inputNumber: (flexItem, attribute, options) ->
    <input value={flexItem.activeStyles[attribute]} type='number' onChange={@onChange} name={attribute} />

  inputSelect: (flexItem, attribute, options) ->
    <select value={flexItem.activeStyles[attribute]} onChange={@onChange} name={attribute}>
      <option value=''>initial</option>
      {<option value={value} key={value}>{value}</option> for value, index in options.options}
    </select>

  sluggify: (string) ->
    string.replace /([a-z])([A-Z])/, (_, a, b) -> "#{a}-#{b.toLowerCase()}"

  createForm: (flexItem) ->
    for attribute, options of flexItem.availableStyles
      inputBuilder = @["input#{options.type}"]
      <label>
        {@sluggify(attribute)}
        {inputBuilder(flexItem, attribute, options)}
      </label>
