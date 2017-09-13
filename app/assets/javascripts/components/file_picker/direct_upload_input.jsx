var DirectUploadInput = React.createClass({
  propTypes: {
    name: React.PropTypes.string,
    id: React.PropTypes.string,
    onUploadSuccess: React.PropTypes.func
  },

  getInitialState: function() {
    return {
      s3Url: [location.protocol, "//", window.greencommons.S3.bucket, ".s3.amazonaws.com/"].join(''),
      errorMesssage: null,
      uploadMesssage: null
    };
  },

  buildFormData: function(signature, file){
    var formData = new FormData();
    formData.append('acl', signature.acl);
    formData.append('AWSAccessKeyId', window.greencommons.S3.accessKeyId);
    formData.append('success_action_status', 200);
    formData.append('key', signature.key);
    formData.append('policy', signature.policy);
    formData.append('signature', signature.signature);
    formData.append('Content-Type', signature.mime_type);
    formData.append('file', file);
    return formData;
  },

  requestSignature: function(file, filename){
    var url = new URL("/s3_signature", location.origin);
    var _this = this;
    url.searchParams.append('filename', filename);
    return fetch(url).then(function(response){
       if (response.ok) {
         return response.json();
       } else {
         _this.setState({
           errorMesssage: 'The file was not uploaded correctly. Please try again',
           uploadMesssage: null
         });
         throw new Error(response.statusText);
       }
    });
  },

  uploadToS3: function(signature, file){
    var formData = this.buildFormData(signature, file);
    var _this = this;
    var headers = new Headers();
    headers.append('Access-Control-Allow-Origin', '*');
    return fetch(
      this.state.s3Url,
      {method: 'POST', body:  formData, mode: 'cors', headers: headers}
    ).then(function(response){
       if (response.ok) {
         return response;
       } else {
         _this.setState({
           errorMesssage: 'The file was not uploaded correctly. Please try again',
           uploadMesssage: null
         });
         throw new Error(response.statusText);
       }
    }).then(function(response){
      _this.props.onUploadSuccess(file, _this.state.s3Url + signature.key);
    });
  },

  handleChange: function(event) {
    var _this = this;
    var file = event.target.files[0];
    this.setState({errorMesssage: null, uploadMesssage: 'Uploading...'});
    _this.requestSignature(file, file.name)
    .then(function(json){
      return _this.uploadToS3(json.s3_signature, file);
    }).then(function(){ _this.setState({uploadMesssage: null}) });
  },

  displayErrorMessage: function(){
    if (this.state.errorMesssage){
      return (<div className="alert-warning">{this.state.errorMesssage}</div>)
    }
  },

  displayUploadingMessage: function(){
    if (this.state.uploadMesssage){
      return (<div className="alert-notice">{this.state.uploadMesssage}</div>)
    }
  },

  render: function() {
    return (
      <div>
        <FileInput
          id={this.props.id}
          name={this.props.name}
          accept={this.props.accept}
          placeholder={this.props.placeholder}
          onChange={this.handleChange}
          className="form-control"
          />
        <div>
          {this.displayUploadingMessage()}
          {this.displayErrorMessage()}
        </div>
      </div>
   );
  }

});
