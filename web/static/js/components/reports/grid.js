import React, {PropTypes} from 'react';

export default class ChartGrid extends React.Component {
  render() {
    return (
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
    );
  }
}

ChartGrid.propTypes = {
};
