var AutocompleteSelect = React.createClass({
  propTypes: {
    name: React.PropTypes.string,
    id: React.PropTypes.string,
    autocompletePath: React.PropTypes.string,
    handler: React.PropTypes.func,
    options: React.PropTypes.array,
    selected: React.PropTypes.string
  },

  componentDidMount: function() {
    var _this = this;
    var select = null;
    $('body').addClass('no-scroll');

    if (this.props.autocompletePath) {
      select = $('#' + this.props.id).selectize({
        valueField: 'id',
        labelField: 'name',
        searchField: 'name',
        options: _this.props.options,
        create: false,
        onChange: function(value) {
          if (_this.props.handler) {
            _this.props.handler(value);
          }
        },
        load: function(query, callback) {
          if (query.length < 2) return callback();

          $.ajax({
            url: _this.props.autocompletePath,
            dataType: 'json',
            data: {
              q: query
            },
            error: function() {
              callback();
            },
            success: function(res) {
              callback(res.items);
            }
          });
        }
      });
    } else {
      select = $('#' + this.props.id).selectize({
        valueField: 'id',
        labelField: 'name',
        searchField: 'name',
        options: _this.props.options,
        create: false
      });
    }

    if (this.props.selected) {
      select[0].selectize.setValue(this.props.selected, false);
    }
  },

  componentWillUnmount: function() {
    $('body').removeClass('no-scroll');
  },

  render: function() {
    return (
      <select name={this.props.name} id={this.props.id} aria-hidden="true">
      </select>
    );
  }
});
