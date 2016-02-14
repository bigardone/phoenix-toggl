import { combineReducers }  from 'redux';
import { routeReducer }     from 'react-router-redux';
import session              from './session';
import registration         from './registration';
import header               from './header';
import timeEntry            from './time_entry';
import timeEntries          from './time_entries';

export default combineReducers({
  routing: routeReducer,
  session: session,
  registration: registration,
  header: header,
  timeEntry: timeEntry,
  timeEntries: timeEntries,
});
