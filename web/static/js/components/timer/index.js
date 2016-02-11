import React, {PropTypes} from 'react';
import Tock               from 'tocktimer';
import moment             from 'moment';
import { connect }        from 'react-redux';
import classnames         from 'classnames';
import Actions            from '../../actions/timer';

class Timer extends React.Component {
  componentDidMount() {
    const { dispatch, channel } = this.props;
  }

  _handleButtonClick() {
    this.props.started ? this._stop() : this._start();
  }

  _start() {
    const startedAt = moment();
    const { time, description } = this.refs;
    const { start, dispatch, duration, channel } = this.props;

    const timeEntry = {
      started_at: startedAt.toISOString(),
      description: description.value.trim(),
      workspace_id: null,
    };

    channel.push('time_entry:start', timeEntry)
    .receive('ok', (data) => {
      const timer = new Tock({
        start: '00:00:00',
        callback: () => {
          const currentTime = moment.duration(timer.lap());
          time.value = `${this._timeValue(currentTime.hours())}:${this._timeValue(currentTime.minutes())}:${this._timeValue(currentTime.seconds())}`;
        },
      });

      timer.start(duration);

      console.log(data);

      dispatch(Actions.start(timer, data));
    });
  }

  _stop() {
    const stoppedAt = moment().toISOString();
    const { timer, dispatch, timeEntry, channel } = this.props;

    timeEntry.stopped_at = stoppedAt;

    channel.push('time_entry:stop', timeEntry)
    .receive('ok', (data) => {
      timer.stop();

      dispatch(Actions.stop(timer));
    });

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
