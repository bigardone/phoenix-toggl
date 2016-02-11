import React                from 'react';
import { connect }          from 'react-redux';
import classnames           from 'classnames';

import { setDocumentTitle } from '../../utils';

import Timer                from '../../components/timer';

class HomeIndexView extends React.Component {
  componentDidMount() {
    setDocumentTitle('Home');
  }

  render() {
    return (
      <div id="home_index" className="view-container">
        <div className="container">
          <Timer />
        </div>
      </div>
    );
  }
}

const mapStateToProps = (state) => (
  state
);

export default connect(mapStateToProps)(HomeIndexView);
