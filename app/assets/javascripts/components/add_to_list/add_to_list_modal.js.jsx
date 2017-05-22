var AddToListModal = React.createClass({
  propTypes: {
    id: React.PropTypes.number,
    type: React.PropTypes.string,
    name: React.PropTypes.string,
    loaderImage: React.PropTypes.string,
    action: React.PropTypes.string,
    autocompletePath: React.PropTypes.string,
    authenticityToken: React.PropTypes.string,
    toggleModal: React.PropTypes.func,
    updateListCount: React.PropTypes.func,
    loggedIn: React.PropTypes.bool,
  },

  getInitialState: function() {
    return {
      step: this.props.loggedIn ? 'form' : 'unauthorized',
      submitted: false,
      json: {}
    }
  },

  load: function() {
    this.setState({ step: 'loading' })
  },

  confirm: function(json) {
    this.props.updateListCount(json.list_count)
    this.setState({ step: 'confirm', json: json })
  },

  render: function() {
    var content = "";

    switch(this.state.step) {
      case 'unauthorized':
        content = (
          <AddToListUnauthorized name={this.props.name}
                                 toggleModal={this.props.toggleModal} />
        )
        break;
      case 'form':
        content = (
          <AddToListForm id={this.props.id}
                         type={this.props.type}
                         name={this.props.name}
                         action={this.props.action}
                         autocompletePath={this.props.autocompletePath}
                         authenticityToken={this.props.authenticityToken}
                         toggleModal={this.props.toggleModal}
                         load={this.load}
                         confirm={this.confirm} />
        )
        break;
      case 'loading':
        content = (
          <AddToListLoading name={this.props.name}
                            loaderImage={this.props.loaderImage}
                            toggleModal={this.props.toggleModal} />
        )
        break;
      case 'confirm':
        content = (
          <AddToListConfirmation json={this.state.json}
                                 toggleModal={this.props.toggleModal} />
        )
        break;
    }

    return (
      <div className='overlay'>
        <div className='overlay__content'>
          <div className='container'>
            <div className='row'>
              <div className='col-xs-12 col-sm-8 col-sm-offset-2 col-md-4 col-md-offset-4'>
                <div className="form-box form-box--modal">
                  {content}
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    );
  }
});
