import React, {PropTypes} from 'react';
import moment             from 'moment';
import { formatDuration}  from '../../utils';
import ChartGrid          from './grid';
import ChartBar           from './bar';

export default class ReportContainer extends React.Component {
  _renderTotalTime(data) {
    const { total_duration } = data;

    return formatDuration(moment.duration(total_duration * 1000));
  }

  _renderBars(data) {
    const { days } = data;

    const barItems = days.map((item) => {
      return (
        <ChartBar key={item.id} {...item} />
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
              <ChartGrid />
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
