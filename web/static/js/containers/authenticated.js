import React            from 'react';
import { connect }      from 'react-redux';
import Actions          from '../actions/sessions';
import { routeActions } from 'react-router-redux';

import Header           from '../layouts/header';

class AuthenticatedContainer extends React.Component {
  componentDidMount() {
    const { dispatch, currentUser } = this.props;

    if (!currentUser && localStorage.getItem('phoenixAuthToken')) {
      dispatch(Actions.currentUser());
    } else if (!localStorage.getItem('phoenixAuthToken')) {
      dispatch(routeActions.push('/sign_in'));
    }
  }

  render() {
    const { currentUser, dispatch, socket } = this.props;

    if (!currentUser) return false;

    return (
      <div id="authentication_container" className="application-container">
        <Header/>

        <div className='main-container'>
          {this.props.children}
        </div>
      </div>
    );
  }
}

const mapStateToProps = (state) => ({
  currentUser: state.session.currentUser,
  socket: state.session.socket,
  channel: state.session.channel,
});

export default connect(mapStateToProps)(AuthenticatedContainer);
