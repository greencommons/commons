var FileInput = React.createClass({
  propTypes: {
    name: React.PropTypes.string,
    id: React.PropTypes.string
  },

  randomString: function(){
     return Math.random().toString(36);
  },

  getInitialState: function() {
    return {
      value: '',
      styles: {
        parent: {
          position: 'relative'
        },
        file: {
          position: 'absolute',
          top: 0,
          left: 0,
          opacity: 0,
          width: '100%',
          zIndex: 1
        },
        text: {
          zIndex: -1
        }
      }
    };
  },

  handleChange: function(e) {
    this.setState({
      value: e.target.value.split(/(\\|\/)/g).pop()
    });
    if (this.props.onChange) this.props.onChange(e);
  },

  reset: function(){
    this.setState({value: '', fileInputKey: this.randomString()})
  },

  render: function() {
    return React.DOM.div({
        style: this.state.styles.parent
      },

      // Actual file input
      React.DOM.input({
        type: 'file',
        id: this.props.id,
        name: this.props.name,
        className: this.props.className,
        onChange: this.handleChange,
        disabled: this.props.disabled,
        accept: this.props.accept,
        style: this.state.styles.file,
        key: (this.state.theInputKey || '')
      }),

      // Emulated file input
      React.DOM.input({
        type: 'text',
        tabIndex: -1,
        name: '_filename',
        value: this.state.value,
        className: this.props.className,
        onChange: function() {},
        placeholder: this.props.placeholder,
        disabled: this.props.disabled,
        style: this.state.styles.text
      }));
  }
});
