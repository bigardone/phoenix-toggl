import Constants from '../constants';

export default {
  start: (timeEntry) => {
    return dispatch => {
      dispatch({
        type: Constants.TIMER_START,
        timeEntry: timeEntry,
      });
    };
  },

  stop: () => {
    return dispatch => {
      dispatch({
        type: Constants.TIMER_STOP,
      });
    };
  },
};
