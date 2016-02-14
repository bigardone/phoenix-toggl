import Constants    from '../constants';
import { httpGet }  from '../utils';

export function fetchTimeEntries() {
  return dispatch => {
    dispatch({ type: Constants.TIME_ENTRIES_FETCH_START });

    httpGet('/api/v1/time_entries')
    .then((payload) => {
      dispatch({
        type: Constants.TIME_ENTRIES_FETCH_SUCCESS,
        items: payload.time_entries,
      });
    });
  };
}

export function appendTimeEntry(item) {
  return dispatch => {
    dispatch({
      type: Constants.TIME_ENTRIES_APPEND_ITEM,
      item: item,
    });
  };
}
