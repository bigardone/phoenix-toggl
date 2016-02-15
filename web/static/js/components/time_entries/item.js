import React, {PropTypes} from 'react';
import moment             from 'moment';

export default class TimeEntryItem extends React.Component {
  _renderDuration(duration) {
    const momentDuration = moment.duration(duration * 1000);

    if (momentDuration.hours() > 0) {
      return `${momentDuration.hours()}:${momentDuration.minutes()}:${momentDuration.seconds()}`;
    } else if (momentDuration.minutes() > 0) {
      return `${momentDuration.minutes()}:${momentDuration.seconds()} min`;
    } else {
      return `${momentDuration.seconds()} secs`;
    }
  }

  _handleContinueClick(e) {
    e.preventDefault();

    this.props.continueClick(this.props);
  }

  render() {
    const { id, description, duration } = this.props;

    return (
      <li>
        <div className="checkbox-container">
        <input id={id} type="checkbox"/>
        <label htmlFor={id}></label>
        </div>
        <div className="description-container">
          {description != '' && description != null ? description : '(no description)'}
        </div>
        <div className="continue-container">
          <a href="#" onClick={::this._handleContinueClick}><i className="fa fa-play"/></a>
        </div>
        <div className="duration-container">
          {::this._renderDuration(duration)}
        </div>
      </li>
    );
  }
}
