import Constants from '../constants';

export function fetchData(channel, numberOfWeeks) {
  return dispatch => {
    dispatch({
      type: Constants.REPORTS_DATA_FECTH_START,
    });

    channel.push('reports:generate', { number_of_weeks: numberOfWeeks })
    .receive('ok', (data) => {
      dispatch({
        type: Constants.REPORTS_DATA_FECTH_SUCCESS,
        data: data,
        numberOfWeeks: numberOfWeeks,
      });
    });;
  };
}

export function showRangeSelector(show) {
  return dispatch => {
    dispatch({
      type: Constants.REPORTS_SHOW_RANGE_SELECTOR,
      show: show,
    });
  };
}
