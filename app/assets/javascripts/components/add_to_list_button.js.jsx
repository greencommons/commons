var AddToListButton = React.createClass({
  propTypes: {
    id: React.PropTypes.number,
    name: React.PropTypes.string,
    list_count: React.PropTypes.number,
    action: React.PropTypes.string,
    autocomplete_path: React.PropTypes.string,
    authenticity_token: React.PropTypes.string
  },

  getInitialState: function() {
    return {
      loading: false,
      showModal: true
    }
  },

  toggleModal: function(e) {
    e.preventDefault();
    this.setState({ showModal: !this.state.showModal })
  },

  render: function() {
    var modal = null;
    if (this.state.showModal) {
      modal = (
        <AddToListModal id={this.props.id}
                        name={this.props.name}
                        action={this.props.action}
                        autocomplete_path={this.props.autocomplete_path}
                        authenticity_token={this.props.authenticity_token}
                        toggleModal={this.toggleModal} />
      )
    }

    return (
      <div>
        <a className="btn btn-groups btn--large" onClick={this.toggleModal}>
          Add to a list ({this.props.list_count})
        </a>
        {modal}
      </div>
    );
  }
});
