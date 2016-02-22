import React, {PropTypes}  from 'react';
import moment              from 'moment';
import PageClick           from 'react-page-click';
import { formatDuration }  from '../../utils';
import {
  displayDropdown,
  removeTimeEntry }        from '../../actions/time_entries';

export default class TimeEntryItem extends React.Component {
  _renderDuration(duration) {
    return formatDuration(moment.duration(duration * 1000));
  }

  _handleContinueClick(e) {
    e.preventDefault();

    const data = {
      id: this.props.id,
      description: this.props.description,
      duration: this.props.duration,
      restarted_at: this.props.restarted_at,
      started_at: this.props.started_at,
      stopped_at: this.props.stopped_at,
      updated_at: this.props.updated_at,
    };

    this.props.continueClick(data);
  }

  _handleCheckboxClick(e) {
    const { id, dispatch } = this.props;

    dispatch(displayDropdown(id));
  }

  _handlePageClick() {
    const { dispatch } = this.props;

    dispatch(displayDropdown(0));
  }

  _renderDropdown() {
    const { dispatch, displayDropdown, id, channel } = this.props;

    if (!displayDropdown) return false;

    const onDeleteClick = (e) => {
      e.preventDefault();

      if (confirm('Are you sure you want to delete this entry?')) {
        channel.push('time_entry:delete', { id: id })
        .receive('ok', (data) => {
          dispatch(removeTimeEntry(data));
        });

      }
    };

    return (
      <PageClick onClick={::this._handlePageClick}>
        <div className="dropdown">
          <ul>
            <li>
              <a href="#" onClick={onDeleteClick}>Delete</a>
            </li>
          </ul>
        </div>
      </PageClick>
    );
  }

  render() {
    const { id, description, duration } = this.props;

    return (
      <li>
        <div className="checkbox-container">
          <input id={id} type="checkbox"/>
          <label htmlFor={id}></label>
          <i className="fa fa-caret-down" onClick={::this._handleCheckboxClick}/>
          {::this._renderDropdown()}
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
