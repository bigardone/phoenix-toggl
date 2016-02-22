import React, {PropTypes} from 'react';

export default class RangeSelector extends React.Component {
  render() {
    return (
      <div className="range-selector">
        <h2>This week</h2> <i className="fa fa-caret-down"/>
      </div>
    );
  }
}

RangeSelector.propTypes = {
};
