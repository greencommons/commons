var AddToListConfirmation = React.createClass({
  propTypes: {
    json: React.PropTypes.object,
    toggleModal: React.PropTypes.func
  },

  errors: function() {
    var _this = this;
    var errors = [];

    Object.keys(this.props.json.errors).forEach(function(error, i) {
      _this.props.json.errors[error].forEach(function(message, j) {
        errors.push(<li key={i + '-' + j}>{error} {message}</li>)
      })
    })

    return errors;
  },

  render: function() {
    var icon = '';
    var content = '';

    if (this.props.json.status === 'ok') {
      icon = (
        <svg width="40px" height="49px" viewBox="0 0 40 49" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlnsXlink="http://www.w3.org/1999/xlink">
            <defs></defs>
            <g id="Webdesign" stroke="none" strokeWidth="1" fill="none" fillRule="evenodd">
                <g id="Added-to-list-confirmation" transform="translate(-701.000000, -356.000000)" fill="#F3D175">
                    <g id="popup" transform="translate(540.000000, 298.000000)">
                        <g id="icon" transform="translate(161.838465, 58.548082)">
                            <path d="M17.0242865,3.6849105 L35.080348,3.6849105 C36.7017086,3.6849105 38.3230692,4.64298723 38.3230692,6.26434785 L38.3230692,44.587417 C38.3230692,46.2087777 36.7017086,47.9038365 35.080348,47.9038365 L7.81201026,47.9038365 C6.19064964,47.9038365 5.1588747,46.2087777 5.1588747,44.587417 L5.1588747,18.1297597 L17.0242865,3.6849105 L17.0242865,3.6849105 Z" id="Shape" opacity="0.196727808"></path>
                            <path d="M31.3954375,46.4298723 L4.12709976,46.4298723 C1.84245525,46.4298723 -1.36424205e-12,44.587417 -1.36424205e-12,42.3764707 L-1.36424205e-12,15.9188134 C-1.36424205e-12,15.6977187 0.07369821,15.4029259 0.22109463,15.2555295 L12.0865064,0.44218926 C12.3076011,0.14739642 12.6023939,0 12.970885,0 L31.3954375,0 C33.6063838,0 35.3751408,1.84245525 35.3751408,4.05340155 L35.3751408,42.3764707 C35.3751408,44.587417 33.6063838,46.4298723 31.3954375,46.4298723 L31.3954375,46.4298723 Z M2.2109463,16.2873044 L2.2109463,42.3764707 C2.2109463,43.4082457 3.09532482,44.218926 4.12709976,44.218926 L31.3954375,44.218926 C32.4272124,44.218926 33.1641945,43.4082457 33.1641945,42.3764707 L33.1641945,4.05340155 C33.1641945,3.02162661 32.3535142,2.2109463 31.3954375,2.2109463 L13.4867724,2.2109463 L2.2109463,16.2873044 L2.2109463,16.2873044 Z" id="Shape"></path>
                            <path d="M9.01430137,16.1226926 L1.1285929,16.1226926 C0.686403645,16.1226926 0.317912595,15.901598 0.0968179648,15.4594087 C-0.0505784552,15.0909177 -0.0505784552,14.6487284 0.244214385,14.2802373 L11.3726441,0.424973861 C11.6674369,0.0564828115 12.1833244,-0.0909136085 12.6255137,0.0564828115 C13.0677029,0.203879231 13.3624958,0.646068491 13.3624958,1.08825775 L13.3624958,11.7008 C13.3624958,13.9854445 11.2252477,16.1226926 9.01430137,16.1226926 L9.01430137,16.1226926 Z M3.41323741,13.9117463 L9.01430137,13.9117463 C9.9723781,13.9117463 11.1515495,12.7325749 11.1515495,11.7008 L11.1515495,4.33097899 L3.41323741,13.9117463 L3.41323741,13.9117463 Z" id="Shape"></path>
                            <path d="M16.407693,31.948174 L16.407693,31.948174 C16.0392019,31.948174 15.7444091,31.948174 15.5970127,31.7270794 L12.7964807,28.5580564 C12.4279896,28.1158671 12.4279896,27.4525832 12.8701789,27.010394 C13.3123682,26.6419029 14.0493503,26.6419029 14.4178413,27.1577904 L16.4813912,29.5161331 L21.345473,24.6520512 C21.7876623,24.209862 22.4509462,24.209862 22.8931355,24.6520512 C23.3353247,25.0942405 23.3353247,25.7575244 22.8931355,26.1997137 L17.1446751,31.8007776 C16.9972787,31.948174 16.7024858,31.948174 16.407693,31.948174 L16.407693,31.948174 Z" id="Shape"></path>
                        </g>
                    </g>
                </g>
            </g>
        </svg>
      )
      content = (
        <h5>Added resource "{this.props.json.resource_name}" to "{this.props.json.list_name}" list</h5>
      )
    } else {
      icon = (
        <i className='fa fa-times'></i>
      )
      content = (
        <div>
          <h5>"{this.props.json.resource_name}" could not be added to "{this.props.json.list_name}" for the following reasons:</h5>
          <ul>{this.errors()}</ul>
        </div>
      )
    }

    return (
      <div>
        <div className="form-box__body form-box__body--confirmation">
          <div className="row">
            <div className="col-xs-12 text-center">
              {icon}
            </div>
          </div>
          <div className="row">
            <div className="col-xs-12">
              {content}
            </div>
          </div>
          <div className="row">
            <div className="col-xs-12 text-center">
              <a href onClick={this.props.toggleModal} className='btn btn-gc'>OK</a>
            </div>
          </div>
        </div>
      </div>
    );
  }
});
