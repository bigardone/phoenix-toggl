import React, {PropTypes} from 'react';
import moment             from 'moment';
import classnames         from 'classnames';
import { formatDuration}  from '../../utils';
import ChartGrid          from './grid';
import ChartBar           from './bar';

export default class ReportContainer extends React.Component {
  _renderTotalTime(data) {
    const { total_duration } = data;

    return formatDuration(moment.duration(total_duration * 1000));
  }

  _renderBars(data, hideLabels) {
    const { days } = data;

    const barItems = days.map((item) => {
      return (
        <ChartBar
          key={item.id}
          hideLabels={hideLabels}
          {...item} />
      );
    });

    return (
      <ul className="barchart-cols current-period">
        {barItems}
      </ul>
    );
  }

  render() {
    const { data, hideLabels } = this.props;

    if (data == null) return false;

    const chartClasses = classnames({
      'barchart-chart': true,
      'hide-labels': hideLabels,
    });

    return (
      <section className="chart-container">
        <header>
          Total <span className="total">{::this._renderTotalTime(data)}</span>
        </header>
        <div className="js-chart-container">
          <div className="barchart-container">
            <div className={chartClasses}>
              <ChartGrid />
              {::this._renderBars(data, hideLabels)}
            </div>
          </div>
        </div>
      </section>
    );
  }
}

ReportContainer.propTypes = {
};
