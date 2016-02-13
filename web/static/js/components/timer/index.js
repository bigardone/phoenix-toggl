import React, {PropTypes} from 'react';
import Tock               from 'tocktimer';
import moment             from 'moment';
import { connect }        from 'react-redux';
import classnames         from 'classnames';
import Actions            from '../../actions/timer';

class Timer extends React.Component {
  componentDidMount() {
    const { timeEntry } = this.props;

    if (timeEntry != null) this._startTimer(timeEntry);
  }

  componentDidUpdate() {
    const { timeEntry, started } = this.props;

    if (timeEntry != null && !started) this._startTimer(timeEntry);
  }

  _handleButtonClick() {
    this.props.started ? this._stop() : this._start();
  }

  _start() {
    const startedAt = moment.utc().toISOString();
    const { time, description } = this.refs;
    const { start, dispatch, duration, channel } = this.props;

    const timeEntry = {
      started_at: startedAt,
      description: description.value.trim(),
      workspace_id: null,
    };

    channel.push('time_entry:start', timeEntry)
    .receive('ok', (data) => {
      this._startTimer(data, 0);
    });
  }

  _stop() {
    const stoppedAt = moment().toISOString();
    const { timer, dispatch, timeEntry, channel } = this.props;
    const { time, description } = this.refs;

    timeEntry.stopped_at = stoppedAt;

    channel.push('time_entry:stop', timeEntry)
    .receive('ok', (data) => {
      timer.stop();

      dispatch(Actions.stop(timer));
      time.value = '0 sec';
      description.value = '';
    });

  }

  _startTimer(timeEntry) {
    const { dispatch, started } = this.props;
    const { time, description, duration } = this.refs;

    description.value = timeEntry.description;

    const { year, month, day, hour, minute, second } = timeEntry.started_at;
    const timeEntryStart = moment.utc(`${year}-${month}-${day} ${hour}:${minute}:${second}`, 'YYYY-M-D H:m:s');
    const initialTime = moment.utc().diff(moment(timeEntryStart), 'milliseconds');

    const timer = new Tock({
      start: '00:00:00',
      callback: () => {
        const currentTime = moment.duration(timer.lap());
        time.value = `${this._timeValue(currentTime.hours())}:${this._timeValue(currentTime.minutes())}:${this._timeValue(currentTime.seconds())}`;
      },
    });

    timer.start(initialTime);

    dispatch(Actions.start(timer, timeEntry));
  }

  _timeValue(value) {
    if (value < 10) return '0' + value;

    return value;
  }

  _buttonText() {
    const { started } = this.props;

    return started ? 'Stop' : 'Start';
  }

  render() {
    const { started } = this.props;

    const buttonClasses = classnames({
      'btn-start': true,
      started: !started,
    });

    return (
      <div className="timer-wrapper">
        <div className="description-container">
          <input
            type="text"
            ref="description"
            placeholder="What are you working on?"
            tabIndex="1" />
        </div>
        <div className="date-time-container">
          <input
            ref="time"
            placeholder="0 sec"
            type="text"
            maxLength="10"
            tabIndex="2"
            readOnly={true}/>
        </div>
        <div className="button-container">
          <button
            tabIndex="3"
            className={buttonClasses}
            onClick={::this._handleButtonClick}>{::this._buttonText()}</button>
        </div>
      </div>
    );
  }
}

const mapStateToProps = (state) => (
  { ...state.timeEntry, channel: state.session.channel }
);

export default connect(mapStateToProps)(Timer);
