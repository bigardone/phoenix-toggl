import Constants  from '../constants';

const initialState = {
  items: [],
};

export default function reducer(state = initialState, action = {}) {
  switch (action.type) {
    case Constants.TIME_ENTRIES_FETCH_SUCCESS:
      return { ...state, items: action.items };

    case Constants.TIME_ENTRIES_APPEND_ITEM:
      const items = [action.item].concat(state.items);

      return { ...state, items: items };
    default:
      return state;
  }
}
