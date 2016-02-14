import React                from 'react';
import { connect }          from 'react-redux';
import classnames           from 'classnames';
import moment               from 'moment';

import { setDocumentTitle } from '../../utils';
import Timer                from '../../components/timer';
import {fetchTimeEntries}   from '../../actions/time_entries';
import TimeEntryItem        from '../../components/time_entries/item';

class HomeIndexView extends React.Component {
  componentDidMount() {
    const { dispatch } = this.props;

    setDocumentTitle('Home');
    dispatch(fetchTimeEntries());
  }

  _renderItems() {
    const { items } = this.props;

    const itemsNodes = items.map((item) => {
      return (
        <TimeEntryItem key={item.id} {...item} />
      );
    });

    return (
      <section className="time-entries">
        <header>
          <span className="title">Time entries</span>
          <small>{::this._renderTotalTime(items)}</small>
        </header>
        <ul>
          {itemsNodes}
        </ul>
      </section>
    );
  }

  _renderTotalTime(items) {
    const { duration } = items.reduce((prev, curr) => {return { duration: prev.duration + curr.duration };}, { duration: 0 });
    const momentDuration = moment.duration(duration * 1000);

    return `${momentDuration.hours()} h ${momentDuration.minutes()} min`;
  }

  render() {
    return (
      <div id="home_index" className="view-container">
        <div className="container">
          <Timer />
          {::this._renderItems()}
        </div>
      </div>
    );
  }
}

const mapStateToProps = (state) => (
  { ...state.timeEntries }
);

export default connect(mapStateToProps)(HomeIndexView);
