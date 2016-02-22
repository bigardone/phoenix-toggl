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

export function continueTimeEntry(item) {
  return dispatch => {
    dispatch({
      type: Constants.TIME_ENTRIES_REMOVE_ITEM,
      item: item,
    });

    dispatch({
      type: Constants.TIMER_SET_TIME_ENTRY,
      timeEntry: item,
    });
  };
}

export function startTimer(item) {
  return dispatch => {
    dispatch({
      type: Constants.TIMER_SET_TIME_ENTRY,
      timeEntry: item,
    });
  };
}

export function displayDropdown(id) {
  return dispatch => {
    dispatch({
      type: Constants.TIME_ENTRIES_DISPLAY_DROPDOWN_FOR,
      id: id,
    });
  };
}

export function removeTimeEntry(item) {
  return dispatch => {
    dispatch({
      type: Constants.TIME_ENTRIES_REMOVE_ITEM,
      item: item,
    });
  };
}

export function selectTimeEntry(id) {
  return dispatch => {
    dispatch({
      type: Constants.TIME_ENTRIES_SELECT_ITEM,
      id: id,
    });
  };
}

export function deselectTimeEntry(id) {
  return dispatch => {
    dispatch({
      type: Constants.TIME_ENTRIES_DESELECT_ITEM,
      id: id,
    });
  };
}
