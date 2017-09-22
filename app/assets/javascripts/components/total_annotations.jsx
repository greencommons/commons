class TotalAnnotations extends React.Component {

  constructor(props) {
    super(props);
    this.state = {
      total: undefined
    };
  }

  componentDidMount() {
    this.getTotalAnnotations();
  }

  getTotalAnnotations() {
    const { url } = this.props;
    const apiUrl = `${window.greencommons.hypothesis.apiUrl}/search?limit=1&url=${url}`;
    const headers = new Headers();
    headers.append('Authorization', `Bearer ${window.greencommons.hypothesis.key}`);
    fetch(
      apiUrl,
      {
        mode: 'cors',
        method: 'GET',
        headers: headers
      }
    ).then((response) => {
      return response.json();
    }).then((json) => {
      this.setState({
        total: json.total
      });
    });
  }

  isPlural() {
    const { total } = this.state;
    if (total != 1) return 's';
  }

  renderTotalAnnotations() {
    const { total } = this.state;

    if (total !== undefined) {
      return ( <span>{total} Annotation{this.isPlural()} </span> );
    } else {
      return ( <span>Loading...</span> );
    }
  }

  render() {
    return (
      <span>
        <i className="fa fa-pencil glyphicon--right"></i>
        { this.renderTotalAnnotations() }
      </span>
    )
  }
}

TotalAnnotations.propTypes = {
  url: React.PropTypes.string
};
