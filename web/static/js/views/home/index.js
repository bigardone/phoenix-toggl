import React                      from 'react';
import { connect }                from 'react-redux';
import classnames                 from 'classnames';
import moment                     from 'moment';
import { setDocumentTitle }       from '../../utils';
import Timer                      from '../../components/timer';
import {fetchTimeEntries}         from '../../actions/time_entries';
import TimeEntryItem              from '../../components/time_entries/item';
import { timexDateToString }  from '../../utils';

class HomeIndexView extends React.Component {
  componentDidMount() {
    const { dispatch } = this.props;

    setDocumentTitle('Home');
    dispatch(fetchTimeEntries());
  }

  _renderItems() {
    const { items } = this.props;

    const groups = this._buildItemGroups(items);

    return Object.keys(groups).map((date) => {
      const items = groups[date];

      return (
        <section key={date} className="time-entries">
          <header>
            <div className="checkbox-container">
              <input id={date} type="checkbox"/>
              <label htmlFor={date}></label>
            </div>
            <div className="description-container">
              <span className="title">{::this._headerText(date)}</span>
              <small>{::this._renderTotalTime(items)}</small>
            </div>
          </header>
          <ul>
            {::this._groupItemNodes(items)}
          </ul>
        </section>
      );
    });
  }

  _headerText(dateKey) {
    const date = moment(new Date(dateKey));

    switch (moment().diff(date, 'days')) {
      case 0:
        return 'Today';
      case 1:
        return 'Yesterday';
      default:
        return date.format('ddd, DD MMM');
    }
  }

  _groupItemNodes(items) {
    return items.map((item) => {
      return (
        <TimeEntryItem key={item.id} {...item} />
      );
    });
  }

  _buildItemGroups(items) {
    const groups = {};

    items.forEach((item) => {
      const key = timexDateToString(item.updated_at);

      groups[key] = groups[key] || [];
      groups[key].push(item);
    });

    return groups;
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
