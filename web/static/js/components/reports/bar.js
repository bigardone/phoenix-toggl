import React, {PropTypes}       from 'react';
import moment                   from 'moment';
import classnames               from 'classnames';
import { formatReportDuration } from '../../utils';

export default class ChartBar extends React.Component {
  render() {
    const { id, date, duration } = this.props;

    const height = duration === 0 ? 2 : (duration * 100) / 36000;
    const durationText = formatReportDuration(moment.duration(duration * 1000));
    const labelText = moment(date, 'YYYY-MM-DD').format('ddd<br/>Do MMM');

    const barClasses = classnames({
      bar: true,
      'zero-col': duration === 0,
    });

    return (
      <li>
        <div className={barClasses} style={{ height: `${height}%` }}>
          <span className="label" dangerouslySetInnerHTML={{ __html: labelText }} />
          <span className="value">{durationText}</span>
        </div>
      </li>
    );
  }
}

ChartBar.propTypes = {
};
