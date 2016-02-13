import { routeActions }                   from 'react-router-redux';
import Constants                          from '../constants';
import { Socket }                         from 'phoenix';
import { httpGet, httpPost, httpDelete }  from '../utils';

export function setCurrentUser(dispatch, user) {
  dispatch({
    type: Constants.CURRENT_USER,
    currentUser: user,
  });

  const socket = new Socket('/socket', {
    params: { token: localStorage.getItem('phoenixAuthToken') },
    logger: (kind, msg, data) => { console.log(`${kind}: ${msg}`, data); },
  });

  socket.connect();

  const channel = socket.channel(`users:${user.id}`);

  if (channel.state != 'joined') {
    channel.join().receive('ok', (payload) => {
      dispatch({
        type: Constants.SOCKET_CONNECTED,
        socket: socket,
        channel: channel,
      });

      dispatch({
        type: Constants.TIMER_SET_TIME_ENTRY,
        timeEntry: payload.time_entry,
      });
    });
  }
};

const Actions = {
  signIn: (email, password) => {
    return dispatch => {
      const data = {
        session: {
          email: email,
          password: password,
        },
      };

      httpPost('/api/v1/sessions', data)
      .then((data) => {
        localStorage.setItem('phoenixAuthToken', data.jwt);
        setCurrentUser(dispatch, data.user);
        dispatch(routeActions.push('/'));
      })
      .catch((error) => {
        console.log(error);

        error.response.json()
        .then((errorJSON) => {
          dispatch({
            type: Constants.SESSIONS_ERROR,
            error: errorJSON.error,
          });
        });
      });
    };
  },

  currentUser: () => {
    return dispatch => {
      const authToken = localStorage.getItem('phoenixAuthToken');

      httpGet('/api/v1/current_user')
      .then(function (data) {
        setCurrentUser(dispatch, data);
      })
      .catch(function (error) {
        console.log(error);
        dispatch(routeActions.push('/sign_in'));
      });
    };
  },

  signOut: (socket, channel) => {
    return dispatch => {
      httpDelete('/api/v1/sessions')
      .then((data) => {
        localStorage.removeItem('phoenixAuthToken');

        channel.leave();
        socket.disconnect();

        dispatch({ type: Constants.USER_SIGNED_OUT, });

        dispatch(routeActions.push('/sign_in'));
      })
      .catch(function (error) {
        console.log(error);
      });
    };
  },
};

export default Actions;
