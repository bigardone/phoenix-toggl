import Constants  from '../constants';

const initialState = {
  items: [],
  displayDropdownFor: 0,
  selectedITems: [],
};

export default function reducer(state = initialState, action = {}) {
  let newSelectedITems = [];
  let index = 0;

  switch (action.type) {
    case Constants.TIME_ENTRIES_FETCH_SUCCESS:
      return { ...state, items: action.items };

    case Constants.TIME_ENTRIES_APPEND_ITEM:
      const items = [action.item].concat(state.items);

      return { ...state, items: items };

    case Constants.TIME_ENTRIES_REMOVE_ITEM:
      const newItems = [...state.items];
      index = newItems.findIndex((item) => item.id === action.item.id);

      newItems.splice(index, 1);

      return { ...state, items: newItems, displayDropdownFor: 0 };

    case Constants.TIME_ENTRIES_DISPLAY_DROPDOWN_FOR:
      return { ...state, displayDropdownFor: action.id };

    case Constants.TIME_ENTRIES_SELECT_ITEM:
      newSelectedITems = [...state.selectedITems, action.id];
      return { ...state, selectedITems: newSelectedITems };

    case Constants.TIME_ENTRIES_DESELECT_ITEM:
      newSelectedITems = [...state.selectedITems];
      index = newSelectedITems.indexOf(action.index);

      newSelectedITems.splice(index, 1);

      return { ...state, selectedITems: newSelectedITems };

    case Constants.USER_SIGNED_OUT:
      return initialState;

    default:
      return state;
  }
}
