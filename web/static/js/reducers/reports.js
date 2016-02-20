import Constants  from '../constants';

const initialState = {
  data: null,
  fetching: true,
};

export default function reducer(state = initialState, action = {}) {
  switch (action.type) {
    case Constants.REPORTS_DATA_FECTH_START:
      return { ...state, fetching: true };

    case Constants.REPORTS_DATA_FECTH_SUCCESS:
      return { ...state, data: action.data, fetching: false };

    default:
      return state;
  }
}
