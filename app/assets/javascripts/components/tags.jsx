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
      <div className="page-details__tag-form">
        <form id="add_tag_form" className="form-horizontal" onSubmit={this.submit} acceptCharset="UTF-8" method="post">
          <input type="hidden" name="authenticity_token" value={this.props.authenticity_token} />
          <input type="text"
                 name="tag[name]"
                 id="tag"
                 onChange={this.change}
                 value={this.state.tag}
                 placeholder="Add tag"
                 className="form-control page-details__tag-input input--tag-like" />
          <button id="add_tag_button" name="button" type="submit" className="form-control btn btn-sm btn--tag-like btn-dark-blue">
            Add tag
            <span aria-hidden="true" className="glyphicon glyphicon-plus glyphicon--left"></span>
          </button>
        </form>
      </div>
    )
  },

  render: function() {
    var _this = this;

    return (
      <div>
        <div className="row">
          <div className="col-xs-12">
            <div className="tags-list">
              {this.state.tags.map(function(tag, i) {
                return (
                  <a key={tag} href={'/search?query=' + tag} className='tags-list__tag'>#{tag}</a>
                )
              })}
              {this.renderForm()}
            </div>
          </div>
        </div>

      </div>
    );
  },
});
