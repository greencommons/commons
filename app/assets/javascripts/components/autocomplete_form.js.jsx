var AutocompleteForm = React.createClass({
  propTypes: {
    name: React.PropTypes.string,
    action: React.PropTypes.string,
    autocomplete_url: React.PropTypes.string,
    field: React.PropTypes.string,
    placeholder: React.PropTypes.string,
    authenticity_token: React.PropTypes.string
  },

  getInitialState: function() {
    return {
      query: "",
      loading: false
    }
  },

  loadingHandler: function(loading) {
    this.setState({ loading: loading });
  },

  resultHandler: function(value) {
    this.setState({ query: value });
  },

  handleChange: function(event) {
    var value = event.target.value;

    if(value.length > 1) {
      this.setState({ query: value, loading: true }, function() {
        this._suggestions.load();
      })
    } else {
      this.setState({ query: value });
      this._suggestions.reset();
    }
  },

  render: function() {
    return (
      <div className="row autocomplete-form">
        <form id='add-member-form' className="form-horizontal" action={this.props.action} acceptCharset="UTF-8" method="post">
          <input name="utf8" type="hidden" value="✓" />
          <input type="hidden" name="authenticity_token" value={this.props.authenticity_token} />
          <div className="col-xs-12 col-md-10">
            {this.renderInput()}
            <AutocompleteSuggestions url={this.props.autocomplete_url}
                                     query={this.state.query}
                                     loadingHandler={this.loadingHandler}
                                     resultHandler={this.resultHandler}
                                     ref={(suggestions) => { this._suggestions = suggestions; }}/>
          </div>
          <div className="col-xs-12 col-md-2">
            {this.renderSubmit()}
          </div>
      </form>
    </div>
    );
  },

  renderInput: function() {
    return (
      <input type="text"
             name={this.props.field}
             id={this.props.name + "-" + this.props.field}
             value={this.state.query}
             className={this.state.loading ? "form-control autocomplete-form__input--loading" : "form-control"}
             placeholder={this.props.placeholder}
             onChange={this.handleChange}
             autoComplete="off" />
    )
  },

  renderSubmit: function() {
    return (
      <button id='add-member-button' name="button" type="submit" className="form-control btn btn-primary">
        <span aria-hidden="true" className="glyphicon glyphicon-plus"></span>
      </button>
    )
  }
});
