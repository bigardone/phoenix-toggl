import Constants  from '../constants';

const initialState = {
  items: [],
  displayDropdownFor: null,
  selectedItems: {},
  editItem: null,
};

export default function reducer(state = initialState, action = {}) {
  let newItems = [];
  let newSelectedItems = [];
  let index = 0;

  switch (action.type) {
    case Constants.TIME_ENTRIES_FETCH_SUCCESS:
      return { ...state, items: action.items };

    case Constants.TIME_ENTRIES_APPEND_ITEM:
      const items = [action.item].concat(state.items);

      return { ...state, items: items };

    case Constants.TIME_ENTRIES_REMOVE_ITEM:
      newItems = [...state.items];
      index = newItems.findIndex((item) => item.id === action.item.id);

      newItems.splice(index, 1);

      newSelectedItems = { ...state.selectedItems };
      delete newSelectedItems[action.section];

      return { ...state, items: newItems, displayDropdownFor: null, selectedItems: newSelectedItems };

    case Constants.TIME_ENTRIES_REMOVE_ITEMS:
      newItems = [...state.items].filter((item) => action.ids.indexOf(item.id) === -1);

      newSelectedItems = { ...state.selectedItems };
      delete newSelectedItems[action.section];

      return { ...state, items: newItems, displayDropdownFor: null, selectedItems: newSelectedItems };

    case Constants.TIME_ENTRIES_DISPLAY_DROPDOWN_FOR:
      return { ...state, displayDropdownFor: action.id };

    case Constants.TIME_ENTRIES_SELECT_ITEM:
      newSelectedItems = { ...state.selectedItems };
      const section = newSelectedItems[action.section];

      if (section === undefined) {
        newSelectedItems[action.section] = [action.id];
      } else {
        const sectionItems = [...section, action.id];

        newSelectedItems[action.section] = sectionItems;
      }

      return { ...state, selectedItems: newSelectedItems };

    case Constants.TIME_ENTRIES_DESELECT_ITEM:
      newSelectedItems = { ...state.selectedItems };
      index = newSelectedItems[action.section].indexOf(action.index);

      newSelectedItems[action.section].splice(index, 1);

      return { ...state, selectedItems: newSelectedItems };

    case Constants.TIME_ENTRIES_SELECT_SECTION:
      newSelectedItems = { ...state.selectedItems };
      newSelectedItems[action.section] = action.ids;

      return { ...state, selectedItems: newSelectedItems };

    case Constants.TIME_ENTRIES_DESELECT_SECTION:
      newSelectedItems = { ...state.selectedItems };
      delete newSelectedItems[action.section];

      return { ...state, selectedItems: newSelectedItems };

    case Constants.TIME_ENTRIES_EDIT_ITEM:
      return { ...state, editItem: action.id };

    case Constants.TIME_ENTRIES_REPLACE_ITEM:
      newItems = [...state.items];
      index = newItems.findIndex((item) => item.id === action.item.id);
      newItems.splice(index, 1, action.item);

      return { ...state, items: newItems, editItem: action.id };
    case Constants.USER_SIGNED_OUT:
      return initialState;

    default:
      return state;
  }
}
