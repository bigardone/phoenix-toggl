import Constants  from '../constants';

const initialState = {
  data: null,
  fetching: true,
  filter: {
    text: 'This week',
    numberOfWeeks: 1,
    show: false,
  },
};

function filterText(numberOfWeeks) {
  switch (numberOfWeeks) {
    case 1:
      return 'This week';
    case 2:
      return 'Last two weeks';
    case 4:
      return 'This month';
  }
}

export default function reducer(state = initialState, action = {}) {
  switch (action.type) {
    case Constants.REPORTS_DATA_FECTH_START:
      return { ...state, fetching: true };

    case Constants.REPORTS_DATA_FECTH_SUCCESS:
      const text = filterText(action.numberOfWeeks);
      return { ...state, data: action.data, fetching: false, filter: { ...state.filter, numberOfWeeks: action.numberOfWeeks, show: false, text: text } };

    case Constants.REPORTS_SHOW_RANGE_SELECTOR:
      return { ...state, filter: { ...state.filter, show: action.show } };

    case Constants.USER_SIGNED_OUT:
      return initialState;

    default:
      return state;
  }
}
