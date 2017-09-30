var AutocompleteSuggestions = React.createClass({
  propTypes: {
    url: React.PropTypes.string,
    query: React.PropTypes.string,
    loadingHandler: React.PropTypes.func,
    resultHandler: React.PropTypes.func
  },

  getInitialState: function() {
    return {
      suggestions: []
    }
  },

  reset: function() {
    this.setState({ suggestions: [] })
  },

  load: function() {
    fetch(this.buildAutocompleteURL(), { credentials: "same-origin" })
      .then(function(response) {
        return response.json();
      }).then( json => {
        this.setState({ suggestions: json }, function() {
          this.props.loadingHandler(false);
        })
      })
  },

  buildAutocompleteURL: function() {
    if (this.props.url.indexOf("?") >= 0) {
      return this.props.url + "&q=" + this.props.query;
    } else {
      return this.props.url + "?q=" + this.props.query;
    }
  },

  handleClick: function(value) {
    this.setState({ suggestions: [] });
    this.props.resultHandler(value);
  },

  render: function() {
    return (
      <ul className="autocomplete-form__suggestions">
        {this.state.suggestions.map(function(suggestion, i) {
          return <li key={i} className="autocomplete-form__suggestion" onClick={this.handleClick.bind(this, suggestion.email)}>{suggestion.email}</li>
        }, this)}
      </ul>
    );
  },
});
