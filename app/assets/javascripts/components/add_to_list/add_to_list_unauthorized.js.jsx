var AddToListUnauthorized = React.createClass({
  propTypes: {
    name: React.PropTypes.string,
    toggleModal: React.PropTypes.func,
  },

  render: function() {
    return (
      <div>
        <div className="form-box__title">
          <div className="row">
            <div className="col-xs-10">
              <h1>Add "{this.props.name}" to list</h1>
            </div>
            <div className='col-xs-2'>
              <a href onClick={this.props.toggleModal}>
                <i className='fa fa-times pull-right glyphicon--giant'></i>
              </a>
            </div>
          </div>
        </div>
        <div className="form-box__body">
          <div className="row">
            <div className="col-xs-12">
              <p>You have to be <a href='/users/sign_in'>logged in</a> to do that.</p>
            </div>
          </div>
        </div>
      </div>
    );
  }
});
