import React            from 'react';
import { connect }      from 'react-redux';
import Actions          from '../actions/sessions';
import { routeActions } from 'react-router-redux';
import Favicon          from 'react-favicon';

import Header           from '../layouts/header';
import {
  faviconData,
  creditsText }         from '../utils';

class AuthenticatedContainer extends React.Component {
  componentDidMount() {
    const { dispatch, currentUser } = this.props;

    if (!currentUser && localStorage.getItem('phoenixAuthToken')) {
      dispatch(Actions.currentUser());
    } else if (!localStorage.getItem('phoenixAuthToken')) {
      dispatch(routeActions.push('/sign_in'));
    }
  }

  _renderFavicon() {
    const { timeEntry } = this.props;

    const url = timeEntry.started ? faviconData.on : faviconData.off;

    return (
      <Favicon url={url} />
    );
  }

  render() {
    const { currentUser, dispatch, socket } = this.props;

    if (!currentUser) return false;

    return (
      <div id="authentication_container" className="application-container">
        {::this._renderFavicon()}
        <Header/>

        <div className='main-container'>
          {this.props.children}
        </div>
        <footer id="main_footer">
          <div className="container">
            {creditsText()}
          </div>
        </footer>
      </div>
    );
  }
}

const mapStateToProps = (state) => ({
  currentUser: state.session.currentUser,
  socket: state.session.socket,
  channel: state.session.channel,
  timeEntry: state.timeEntry,
});

export default connect(mapStateToProps)(AuthenticatedContainer);
