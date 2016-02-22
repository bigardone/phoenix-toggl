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

    case Constants.TIME_ENTRIES_CONTINUE_ITEM:
      const newItems = [...state.items];
      const index = newItems.findIndex((item) => item.id == action.item.id);

      newItems.splice(index, 1);

      return { ...state, items: newItems };

    case Constants.USER_SIGNED_OUT:
      return initialState;

    default:
      return state;
  }
}
