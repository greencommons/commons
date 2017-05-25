var AutocompleteSelect = React.createClass({
  propTypes: {
    name: React.PropTypes.string,
    id: React.PropTypes.string,
    autocompletePath: React.PropTypes.string,
    handler: React.PropTypes.func,
    options: React.PropTypes.array
  },

  componentDidMount: function() {
    var _this = this;
    $('body').addClass('no-scroll');

    if (this.props.autocompletePath) {
      $('#' + this.props.id).select2({
        theme: 'bootstrap',
        data: _this.props.options,
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
        templateResult: function(item) { return item.name; },
        templateSelection: function(item) { return item.name }
      })
    } else {
      $('#' + this.props.id).select2({
        theme: 'bootstrap',
        data: _this.props.options
      })
    }

    $('#' + this.props.id).on('change', function(e) {
      if (_this.props.handler) {
        _this.props.handler(e.target.value);
      }
    });
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
