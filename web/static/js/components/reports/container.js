import React, {PropTypes} from 'react';
import moment             from 'moment';
import classnames         from 'classnames';
import {
  formatDuration,
  formatReportDuration }  from '../../utils';

export default class ReportContainer extends React.Component {
  _renderTotalTime(data) {
    const { total_duration } = data;

    return formatDuration(moment.duration(total_duration * 1000));
  }

  _renderBars(data) {
    const { days } = data;

    const barItems = days.map((item) => {
      const { id, date, duration } = item;

      const height = duration === 0 ? 2 : (duration * 100) / 36000;
      const durationText = formatReportDuration(moment.duration(duration * 1000));
      const labelText = moment(date, 'YYYY-MM-DD').format('ddd<br/>Do MMM');

      const barClasses = classnames({
        bar: true,
        'zero-col': duration === 0,
      });

      return (
        <li key={id}>
          <div className={barClasses} style={{ height: `${height}%` }}>
            <span className="label" dangerouslySetInnerHTML={{ __html: labelText }} />
            <span className="value">{durationText}</span>
          </div>
        </li>
      );
    });

    return (
      <ul className="barchart-cols current-period">
        {barItems}
      </ul>
    );
  }

  render() {
    const { data } = this.props;

    if (data == null) return false;

    return (
      <section className="chart-container">
        <header>
          Total <span className="total">{::this._renderTotalTime(data)}</span>
        </header>
        <div className="js-chart-container">
          <div className="barchart-container">
            <div className="barchart-chart">
              <ul className="barchart-grid">
                <li>
                  <span>10 h</span>
                </li>
                <li>
                  <span>8 h</span>
                </li>
                <li>
                  <span>6 h</span>
                </li>
                <li>
                  <span>4 h</span>
                </li>
                <li>
                  <span>2 h</span>
                </li>
              </ul>
              {::this._renderBars(data)}
            </div>
          </div>
        </div>
      </section>
    );
  }
}

ReportContainer.propTypes = {
};
