import React, {PropTypes}     from 'react';
import PageClick              from 'react-page-click';
import {
  fetchData,
  showRangeSelector }         from '../../actions/reports';

export default class RangeSelector extends React.Component {
  _renderDropdown(show) {
    if (!show) return false;

    return (
      <PageClick onClick={::this._hideDropdown}>
        <ul className="dropdown">
          <li>
            <a href="#" onClick={::this._fetchOneWeek}>This week</a>
          </li>
          <li>
            <a href="#" onClick={::this._fetchTwoWeeks}>Last two weeks</a>
          </li>
          <li>
            <a href="#" onClick={::this._fetchFourWeeks}>This month</a>
          </li>
        </ul>
      </PageClick>
    );
  }

  _fetchOneWeek(e) {
    e.preventDefault();
    this._fetch(1);
  }

  _fetchTwoWeeks(e) {
    e.preventDefault();
    this._fetch(2);
  }

  _fetchFourWeeks(e) {
    e.preventDefault();
    this._fetch(4);
  }

  _fetch(numberOfWeeks) {
    const { dispatch, channel } = this.props;

    dispatch(fetchData(channel, numberOfWeeks));
  }

  _hideDropdown() {
    const { dispatch } = this.props;

    dispatch(showRangeSelector(false));
  }

  _handleShowClick(e) {
    const { dispatch, show } = this.props;

    if (show) return false;

    dispatch(showRangeSelector(true));
  }

  render() {
    const { dispatch, show, text } = this.props;

    return (
      <div className="range-selector">
        <ul>
          <li>
            <h2 onClick={::this._handleShowClick}>{text}</h2>
            {::this._renderDropdown(show)}
          </li>
        </ul>
      </div>
    );
  }
}

RangeSelector.propTypes = {
};
