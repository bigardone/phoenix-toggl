import Constants from '../constants';

export function showDropdown(show) {
  return dispatch => {
    dispatch({
      type: Constants.HEADER_SHOW_DROPDOWN,
      show: show,
    });
  };
}
