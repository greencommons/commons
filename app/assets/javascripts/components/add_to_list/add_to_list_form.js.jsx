var AddToListForm = React.createClass({
  propTypes: {
    id: React.PropTypes.number,
    type: React.PropTypes.string,
    name: React.PropTypes.string,
    action: React.PropTypes.string,
    autocompletePath: React.PropTypes.string,
    authenticityToken: React.PropTypes.string,
    toggleModal: React.PropTypes.func,
    load: React.PropTypes.func,
    confirm: React.PropTypes.func
  },

  getInitialState: function() {
    return {
      listId: null,
      note: ''
    }
  },

  componentDidMount: function() {
    var _this = this;
    $('body').addClass('no-scroll');

    $('#list_id').select2({
      theme: 'bootstrap',
      ajax: {
        url: _this.props.autocompletePath,
        dataType: 'json',
        delay: 250,
        data: function (params) {
          return {
            q: params.term
          };
        },
        processResults: function (data, params) {
          return {
            results: data.items
          };
        },
        cache: true
      },
      minimumInputLength: 2,
      templateResult: function(list) { return list.name; },
      templateSelection: function(list) { return list.name }
    })

    $('#list_id').on('change', function(e) {
      _this.setState({ listId: e.target.value });
    });
  },

  handleSelect: function(value) {
    _this.setState({ listId: value });
  },

  componentWillUnmount: function() {
    $('body').removeClass('no-scroll');
  },

  handleNote: function(e) {
    this.setState({ note: e.target.value });
  },

  handleSubmit: function(e) {
    this.props.load();

    e.preventDefault();
    var _this = this

    var form = new FormData()
    form.append('list_item[list_id]', this.state.listId)
    form.append('list_item[item_id]', this.props.id)
    form.append('list_item[item_type]', this.props.type)
    form.append('list_item[note]', this.state.note)

    fetch(this.props.action, {
      method: 'POST',
      credentials: "same-origin",
      headers: { 'X-CSRF-Token': this.props.authenticityToken },
      body: form
    }).then(function (response) {
      return response.json();
    }).then(function (json) {
      _this.props.confirm(json);
    });
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
              <form onSubmit={this.handleSubmit} className="new_resource" id="new_resource" acceptCharset="UTF-8" method="post">
                <input name="utf8" type="hidden" value="✓" />
                <input type="hidden" name="authenticityToken" value={this.props.authenticityToken} />
                <fieldset>
                  <div className="form-group">
                    <label className="control-label" htmlFor="resource_title">List</label>
                    <AutocompleteSelect name='list_item[list_id]'
                                        id='list_id'
                                        autocompletePath={this.props.autocompletePath}
                                        handler={this.handleSelect}
                                        remote={true} />
                  </div>
                  <div className="form-group">
                    <label className="control-label" htmlFor="resource_url">Note</label>
                    <textarea className="form-control" name="list_item[note]" id="list_item_note" onChange={this.handleNote}></textarea>
                  </div>
                  <div className="form-group">
                    <div className="pull-right">
                      <input type="submit" name="commit" value="Submit" className="form-control btn btn-gc" data-disable-with="Create" />
                    </div>
                  </div>
                </fieldset>
              </form>
            </div>
          </div>
        </div>
      </div>
    );
  }
});
