var AddToListConfirmation = React.createClass({
  propTypes: {
    json: React.PropTypes.object,
    toggleModal: React.PropTypes.func
  },

  errors: function() {
    var _this = this;
    var errors = [];

    Object.keys(this.props.json.errors).forEach(function(error, i) {
      _this.props.json.errors[error].forEach(function(message, j) {
        errors.push(<li key={i + '-' + j}>{error} {message}</li>)
      })
    })

    return errors;
  },

  render: function() {
    var icon = '';
    var content = '';

    if (this.props.json.status === 'ok') {
      icon = (
        <i className='fa fa-check'></i>
      )
      content = (
        <h5>Added resource "{this.props.json.resource_name}" to "{this.props.json.list_name}" list</h5>
      )
    } else {
      icon = (
        <i className='fa fa-times'></i>
      )
      content = (
        <div>
          <h5>"{this.props.json.resource_name}" could not be added to "{this.props.json.list_name}" for the following reasons:</h5>
          <ul>{this.errors()}</ul>
        </div>
      )
    }

    return (
      <div>
        <div className="form-box__body form-box__body--confirmation">
          <div className="row">
            <div className="col-xs-12 text-center">
              {icon}
            </div>
          </div>
          <div className="row">
            <div className="col-xs-12">
              {content}
            </div>
          </div>
          <div className="row">
            <div className="col-xs-12 text-center">
              <a href onClick={this.props.toggleModal} className='btn btn-gc'>OK</a>
            </div>
          </div>
        </div>
      </div>
    );
  }
});
