import React            from 'react';
import { connect }      from 'react-redux';
import { Link }         from 'react-router';
import PageClick        from 'react-page-click';
import { routeActions } from 'react-router-redux';
import classnames       from 'classnames';

import SessionActions   from '../actions/sessions';
import {showDropdown}   from '../actions/header';

class Header extends React.Component {
  _renderCurrentUser() {
    const { currentUser, showMenu } = this.props;

    if (!currentUser) {
      return false;
    }

    const fullName = [currentUser.first_name, currentUser.last_name].join(' ');
    const classes = classnames({
      'current-user': true,
      visible: showMenu,
    });

    return (
      <a href="#" onClick={::this._handleShowDropdownClick} className={classes}>
        {fullName}
      </a>
    );
  }

  _handleShowDropdownClick(e) {
    e.preventDefault();

    if (showMenu) return false;

    const { dispatch, showMenu } = this.props;

    dispatch(showDropdown(!showMenu));
  }

  _renderDropdown(show) {
    if (!show) return false;

    return (
      <PageClick onClick={::this._handlePageClick}>
        <ul className="dropdown">
          <li>
            {this._renderSignOutLink()}
          </li>
        </ul>
      </PageClick>
    );
  }

  _handlePageClick() {
    const { dispatch } = this.props;

    dispatch(showDropdown(false));
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
    const { showMenu } = this.props;

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
              <li className="menu-wrapper">
                {this._renderCurrentUser()}
                {this._renderDropdown(showMenu)}
              </li>
            </ul>
          </nav>
        </div>
      </header>
    );
  }
}

const mapStateToProps = (state) => (
  { ...state.header, ...state.session }
);

export default connect(mapStateToProps)(Header);
