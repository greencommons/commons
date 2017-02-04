var Tags = React.createClass({
  propTypes: {
    authenticity_token: React.PropTypes.string,
    submit_url: React.PropTypes.string,
    tags: React.PropTypes.array,
    can_create: React.PropTypes.bool
  },

  getInitialState: function() {
    return {
      tag: '',
      tags: this.props.tags
    }
  },

  change: function(e) {
    this.setState({ tag: e.target.value });
  },

  submit: function(e) {
    e.preventDefault();

    if (this.state.tag.length > 0) {
      var form = new FormData(document.querySelector('#' + e.target.id));

      fetch(this.props.submit_url, {
        method: 'POST',
        credentials: "same-origin",
        headers: { 'X-CSRF-Token': this.props.authenticity_token },
        body: form
      }).then(function(response) {
          return response.json();
      }).then( json => {
        this.setState({ tags: json, tag: '' })
      })
    }
  },

  renderForm: function() {
    if (!this.props.can_create) { return null };

    return (
      <div className="col-xs-12 col-sm-6 col-md-3">
        <div className="row">
          <form id="add_tag_form" className="form-horizontal" onSubmit={this.submit} acceptCharset="UTF-8" method="post">
            <input type="hidden" name="authenticity_token" value={this.props.authenticity_token} />
            <div className="col-xs-8 col-md-8">
              <input type="text"
                     name="tag[name]"
                     id="tag"
                     onChange={this.change}
                     value={this.state.tag}
                     placeholder="Add tag"
                     className="form-control page-details__tag-input" />
            </div>
            <div className="col-xs-4 col-md-4">
              <button id="add_tag_button" name="button" type="submit" className="form-control btn btn-primary">
                <span aria-hidden="true" className="glyphicon glyphicon-plus"></span>
              </button>
            </div>
          </form>
        </div>
      </div>
    )
  },

  render: function() {
    var _this = this;

    return (
      <div className="row">
        {this.renderForm()}
        <div className="col-xs-12 col-sm-6 col-md-9">
          <p className="page-details__tag-list">
            <span className="glyphicon glyphicon-tag glyphicon--right"></span>
            {this.state.tags.map(function(tag, i) {
              return (
                <span key={tag}>
                  <a href={'/search?query=' + tag}>{tag}</a>
                  {i == _this.state.tags.length - 1 ? '' : ', '}
                </span>
              )
            })}
          </p>
        </div>
      </div>
    );
  },
});
