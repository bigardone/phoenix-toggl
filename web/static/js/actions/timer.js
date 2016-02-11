import Constants from '../constants';

export default {
  start: (timer, timeEntry) => {
    return dispatch => {
      dispatch({
        type: Constants.TIMER_START,
        timer: timer,
        timeEntry: timeEntry,
      });
    };
  },

  stop: (timer) => {
    return dispatch => {
      dispatch({
        type: Constants.TIMER_STOP,
        timer: timer,
      });
    };
  },
};
