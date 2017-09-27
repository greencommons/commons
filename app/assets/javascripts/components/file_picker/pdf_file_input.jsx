var PdfFileInput = React.createClass({
  propTypes: {
    name: React.PropTypes.string,
    id: React.PropTypes.string,
    onUploadSuccess: React.PropTypes.oneOfType([
      React.PropTypes.string,
      React.PropTypes.func,
    ])
  },

  getInitialState: function() {
    return {};
  },

  _wrapOnUploadSuccess: function(file, fileUrl){
    if(typeof this.props.onUploadSuccess === 'string'){
      window[this.props.onUploadSuccess](file, fileUrl)
    }else{
      this.props.onUploadSuccess(file, fileUrl)
    }
  },


  handleOnUploadSuccess: function(file, fileUrl) {
    this._wrapOnUploadSuccess(file, fileUrl);
  },


  render: function() {
    return (
      <DirectUploadInput
        id={this.props.id}
        name={this.props.name}
        accept=".pdf"
        placeholder="Select a PDF file."
        onUploadSuccess={this.handleOnUploadSuccess}
      />
   );
  }

});
