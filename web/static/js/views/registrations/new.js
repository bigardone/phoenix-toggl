import React, {PropTypes}   from 'react';
import { connect }          from 'react-redux';
import { Link }             from 'react-router';

import {
  setDocumentTitle,
  renderErrorsFor,
  creditsText }             from '../../utils';
import Actions              from '../../actions/registrations';

class RegistrationsNewView extends React.Component {
  componentDidMount() {
    setDocumentTitle('Sign up');
  }

  _handleSubmit(e) {
    e.preventDefault();

    const { dispatch } = this.props;

    const data = {
      first_name: this.refs.firstName.value,
      email: this.refs.email.value,
      password: this.refs.password.value,
    };

    dispatch(Actions.signUp(data));
  }

  render() {
    const { errors } = this.props;

    return (
      <div id="registrations_new_view" className="view-container">
        <div className="form-wrapper">
          <div className="inner">
            <header>
              <div className="logo" />
              {creditsText()}
            </header>
            <form id="sign_up_form" onSubmit={::this._handleSubmit}>
              <div className="field">
                <input ref="firstName" id="user_first_name" type="text" placeholder="First name" required={true} />
                {renderErrorsFor(errors, 'first_name')}
              </div>
              <div className="field">
                <input ref="email" id="user_email" type="email" placeholder="Email" required={true} />
                {renderErrorsFor(errors, 'email')}
              </div>
              <div className="field">
                <input ref="password" id="user_password" type="password" placeholder="Password" required={true} />
                {renderErrorsFor(errors, 'password')}
              </div>
              <button type="submit">Sign up</button>
            </form>
          </div>
          <Link to="/sign_in">Sign in</Link>
        </div>
      </div>
    );
  }
}

const mapStateToProps = (state) => ({
  errors: state.registration.errors,
});

export default connect(mapStateToProps)(RegistrationsNewView);
