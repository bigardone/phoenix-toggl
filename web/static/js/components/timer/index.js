import React, {PropTypes}         from 'react';
import Tock                       from 'tocktimer';
import moment                     from 'moment';
import { connect }                from 'react-redux';
import classnames                 from 'classnames';
import Actions                    from '../../actions/timer';
import { appendTimeEntry }        from '../../actions/time_entries';
import {
  timexDateTimeToString,
  setDocumentTitle,
  formatDuration }                from '../../utils';

export default class Timer extends React.Component {
  componentDidMount() {
    const { timeEntry } = this.props;

    if (timeEntry != null) this._startTimer(timeEntry);
  }

  componentDidUpdate() {
    const { timeEntry, started } = this.props;

    if (timeEntry != null && !started) this._startTimer(timeEntry);
  }

  componentWillUnmount() {
    if (!this.timer) return false;

    this.timer.stop();
    this.timer = null;
  }

  _handleButtonClick() {
    this.props.started ? this.stop() : this._start();
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
      this._startTimer(data);
    });
  }

  stop() {
    const stoppedAt = moment().toISOString();
    const { timeEntry, channel, dispatch } = this.props;

    timeEntry.stopped_at = stoppedAt;

    channel.push('time_entry:stop', timeEntry)
    .receive('ok', (data) => {
      dispatch(appendTimeEntry(data));

      this._resetTimer();
    });

  }

  _handleDiscardClick(e) {
    e.preventDefault();

    const { timeEntry, channel } = this.props;

    channel.push('time_entry:discard', timeEntry)
    .receive('ok', (data) => {
      this._resetTimer();
    });
  }

  _resetTimer() {
    const { time, description } = this.refs;
    const { dispatch } = this.props;

    this.timer.stop();
    this.timer = null;
    time.value = '0 sec';
    description.value = '';

    setDocumentTitle('Home');
    dispatch(Actions.stop());
  }

  _startTimer(timeEntry) {
    const { dispatch, started } = this.props;
    const { time, description, duration } = this.refs;

    description.value = timeEntry.description;

    const timer = new Tock({
      start: '00:00:00',
      callback: () => {
        const currentTime = moment.duration(timer.lap());
        const timeText = formatDuration(currentTime);
        time.value = timeText;

        setDocumentTitle(`${timeText} - ${description.value.trim()}`);
      },
    });

    if (timeEntry.restarted_at != null) {
      const timeEntryStart = moment.utc(timexDateTimeToString(timeEntry.restarted_at), 'YYYY-M-D H:m:s');
      const initialTime = moment.utc().diff(moment(timeEntryStart), 'milliseconds');

      timer.start((timeEntry.duration * 1000) + initialTime);
    } else {
      const timeEntryStart = moment.utc(timexDateTimeToString(timeEntry.started_at), 'YYYY-M-D H:m:s');
      const initialTime = moment.utc().diff(moment(timeEntryStart), 'milliseconds');

      timer.start(initialTime);
    }

    this.timer = timer;

    dispatch(Actions.start(timeEntry));
  }

  _timeValue(value) {
    if (value < 10) return '0' + value;

    return value;
  }

  _buttonText() {
    const { started } = this.props;

    return started ? 'Stop' : 'Start';
  }

  _updateTimeEntryDescription() {
    const { timeEntry, channel } = this.props;
    const { description } = this.refs;

    if (timeEntry == null) return false;
    if (timeEntry != null && timeEntry.description === description.value) return false;

    channel.push('time_entry:update', { description: description.value.trim() });
  }

  _handleDescriptionKeyUp(e) {
    if (e.which != 13) return false;

    this._updateTimeEntryDescription();
  }

  _renderDiscardLink() {
    const { started } = this.props;

    if (!started) return false;

    return (
      <a href="#" onClick={::this._handleDiscardClick}>Discard</a>
    );
  }

  render() {
    const { started } = this.props;

    const buttonClasses = classnames({
      'btn-start': true,
      started: !started,
    });

    return (
      <div className="timer-container">
        <div className="timer-actions">
          {::this._renderDiscardLink()}
        </div>
        <div className="timer-wrapper">
          <div className="description-container">
            <input
              type="text"
              ref="description"
              placeholder="What are you working on?"
              tabIndex="1"
              onBlur={::this._updateTimeEntryDescription}
              onKeyUp={::this._handleDescriptionKeyUp}/>
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
      </div>
    );
  }
}
