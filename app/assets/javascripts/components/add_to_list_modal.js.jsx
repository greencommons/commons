var AddToListModal = React.createClass({
  propTypes: {
    id: React.PropTypes.number,
    name: React.PropTypes.string,
    action: React.PropTypes.string,
    autocomplete_path: React.PropTypes.string,
    authenticity_token: React.PropTypes.string,
    toggleModal: React.PropTypes.func
  },

  getInitialState: function() {
    return {
      list: null,
      loading: false
    }
  },

  componentDidMount: function() {
    var _this = this;
    $('body').addClass('no-scroll');

    $('#list_id').select2({
      theme: 'bootstrap',
      ajax: {
        url: _this.props.autocomplete_path,
        dataType: 'json',
        delay: 250,
        data: function (params) {
          return {
            q: params.term,
            page: params.page
          };
        },
        processResults: function (data, params) {
          console.log(data)
          params.page = params.page || 1;

          return {
            results: data.items,
            pagination: {
              more: (params.page * 30) < data.total_count
            }
          };
        },
        cache: true
      },
      minimumInputLength: 2,
      templateResult: function(list) { return list.name; },
      templateSelection: function(list) { return list.name }
    })
  },

  componentWillUnmount: function() {
    $('body').removeClass('no-scroll');
  },

  render: function() {
    return (
      <div className='overlay'>
        <div className='overlay__content'>
          <div className='container'>
            <div className='row'>
              <div className='col-xs-12 col-sm-8 col-sm-offset-2 col-md-4 col-md-offset-4'>
                <div className="form-box form-box--modal">
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
                        <form className="new_resource" id="new_resource" action={this.props.action} acceptCharset="UTF-8" method="post">
                          <input name="utf8" type="hidden" value="✓" />
                          <input type="hidden" name="authenticity_token" value={this.props.authenticity_token} />
                          <fieldset>
                            <div className="form-group">
                              <label className="control-label" htmlFor="resource_title">List</label>
                              <select name="list_item[list_id]" id="list_id" aria-hidden="true">
                              </select>
                            </div>

                            <div className="form-group">
                              <label className="control-label" htmlFor="resource_url">Note</label>
                              <textarea className="form-control" name="list_item[note]" id="list_item_note"></textarea>
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
              </div>
            </div>
          </div>
        </div>
      </div>
    );
  }
});
