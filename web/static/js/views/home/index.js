import React                from 'react';
import { connect }          from 'react-redux';
import classnames           from 'classnames';

import { setDocumentTitle } from '../../utils';

class HomeIndexView extends React.Component {
  componentDidMount() {
    setDocumentTitle('Home');
  }

  render() {
    return (
      <div className="view-container home index">
        Hello, world!
      </div>
    );
  }
}

const mapStateToProps = (state) => (
  state
);

export default connect(mapStateToProps)(HomeIndexView);
