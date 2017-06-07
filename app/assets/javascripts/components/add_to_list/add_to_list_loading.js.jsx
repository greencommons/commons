var AddToListLoading = React.createClass({
  propTypes: {
    name: React.PropTypes.string,
    loaderImage: React.PropTypes.string,
    toggleModal: React.PropTypes.func
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
            <div className="col-xs-4 col-xs-offset-4">
              <div className='text-center'>
                <img src={this.props.loaderImage}></img>
              </div>
            </div>
          </div>
        </div>
      </div>
    );
  }
});
