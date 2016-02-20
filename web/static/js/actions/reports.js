import Constants from '../constants';

export function fetchData(channel) {
  return dispatch => {
    dispatch({
      type: Constants.REPORTS_DATA_FECTH_START,
    });

    channel.push('reports:generate')
    .receive('ok', (data) => {
      dispatch({
        type: Constants.REPORTS_DATA_FECTH_SUCCESS,
        data: data,
      });
    });;
  };
}
