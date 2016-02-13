import React            from 'react';
import { connect }      from 'react-redux';
import { Link }         from 'react-router';
import PageClick        from 'react-page-click';
import { routeActions } from 'react-router-redux';

import SessionActions   from '../actions/sessions';
import HeaderActions    from '../actions/header';

class Header extends React.Component {
  _renderCurrentUser() {
    const { currentUser } = this.props;

    if (!currentUser) {
      return false;
    }

    const fullName = [currentUser.first_name, currentUser.last_name].join(' ');

    return (
      <a className="current-user">
        {fullName}
      </a>
    );
  }

  _renderSignOutLink() {
    if (!this.props.currentUser) {
      return false;
    }

    return (
      <a href="#" onClick={::this._handleSignOutClick}><i className="fa fa-sign-out"/> Sign out</a>
    );
  }

  _handleSignOutClick(e) {
    e.preventDefault();

    const { dispatch, socket, channel } = this.props;

    dispatch(SessionActions.signOut(socket, channel));
  }

  render() {
    return (
      <header id="main_header">
        <div className="container">
          <nav>
            <Link className="logo-link" to='/'>
              <span className="logo"/> phoenix toggl
            </Link>
            <ul>
              <li>
                <Link to="/" activeClassName="active">Timer</Link>
              </li>
            </ul>
          </nav>
          <nav className="right">
            <ul>
              <li>
                {this._renderCurrentUser()}
              </li>
              <li>
                {this._renderSignOutLink()}
              </li>
            </ul>
          </nav>
        </div>
      </header>
    );
  }
}

const mapStateToProps = (state) => (
  state.session
);

export default connect(mapStateToProps)(Header);
