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

export function removeTimeEntry(section, item) {
  return dispatch => {
    dispatch({
      type: Constants.TIME_ENTRIES_REMOVE_ITEM,
      section: section,
      item: item,
    });
  };
}

export function removeTimeEntries(section, ids) {
  return dispatch => {
    dispatch({
      type: Constants.TIME_ENTRIES_REMOVE_ITEMS,
      section: section,
      ids: ids,
    });
  };
}

export function selectTimeEntry(section, id) {
  return dispatch => {
    dispatch({
      type: Constants.TIME_ENTRIES_SELECT_ITEM,
      section: section,
      id: id,
    });
  };
}

export function deselectTimeEntry(section, id) {
  return dispatch => {
    dispatch({
      type: Constants.TIME_ENTRIES_DESELECT_ITEM,
      section: section,
      id: id,
    });
  };
}

export function selectSection(section, ids) {
  return dispatch => {
    dispatch({
      type: Constants.TIME_ENTRIES_SELECT_SECTION,
      section: section,
      ids: ids,
    });
  };
}

export function deselectSection(section, ids) {
  return dispatch => {
    dispatch({
      type: Constants.TIME_ENTRIES_DESELECT_SECTION,
      section: section,
      ids: ids,
    });
  };
}

export function editItem(id) {
  return dispatch => {
    dispatch({
      type: Constants.TIME_ENTRIES_EDIT_ITEM,
      id: id,
    });
  };
}

export function replaceTimeEntry(item) {
  return dispatch => {
    dispatch({
      type: Constants.TIME_ENTRIES_REPLACE_ITEM,
      item: item,
    });
  };
}
