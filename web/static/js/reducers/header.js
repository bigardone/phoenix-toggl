import Constants  from '../constants';

const initialState = {
  showMenu: false,
};

export default function reducer(state = initialState, action = {}) {
  switch (action.type) {
    case Constants.HEADER_SHOW_DROPDOWN:
      return { ...state, showMenu: action.show };

    case Constants.USER_SIGNED_OUT:
      return initialState;

    default:
      return state;
  }
}
