var OwnerPicker = React.createClass({
  propTypes: {
    autocompletePath: React.PropTypes.string,
    options: React.PropTypes.array
  },

  render: function() {
    return (
      <div className='form-group'>
        <label className="control-label" htmlFor="list_owner">Owner</label>
        <AutocompleteSelect name='list[owner]'
                            id='list_owner'
                            autocompletePath={this.props.autocompletePath}
                            options={this.props.options} />
      </div>
    );
  }
});
