import React, {PropTypes}  from 'react';
import moment              from 'moment';
import PageClick           from 'react-page-click';
import classnames          from 'classnames';
import { formatDuration }  from '../../utils';
import {
  displayDropdown,
  removeTimeEntry,
  selectTimeEntry,
  deselectTimeEntry,
  editItem,
  replaceTimeEntry}         from '../../actions/time_entries';

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

  _handleToggleDropdownClick(e) {
    const { id, dispatch } = this.props;

    dispatch(displayDropdown(id));
  }

  _handlePageClick() {
    const { dispatch } = this.props;

    dispatch(displayDropdown(0));
  }

  _renderDropdown() {
    const { dispatch, displayDropdown, id, channel, section } = this.props;

    if (!displayDropdown) return false;

    const onDeleteClick = (e) => {
      e.preventDefault();

      if (confirm('Are you sure you want to delete this entry?')) {
        channel.push('time_entry:delete', { id: id })
        .receive('ok', (data) => {
          dispatch(removeTimeEntry(section, data));
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

  _handleCheckboxChange() {
    const { checkbox } = this.refs;
    const { section, id, dispatch } = this.props;

    checkbox.checked ? dispatch(selectTimeEntry(section, id)) : dispatch(deselectTimeEntry(section, id));
  }

  _renderDescription() {
    const { inEditMode, description } = this.props;
    const descriptionText = description != '' && description != null ? description : '(no description)';

    if (inEditMode) {
      return (
        <PageClick onClick={::this._removeEditMode}>
          <input type="text" ref="description" defaultValue={descriptionText} onKeyUp={::this._handleDescriptionKeyUp}/>
        </PageClick>
      );
    } else {
      return descriptionText;
    }
  }

  _handleEditClick() {
    const { id, dispatch } = this.props;

    dispatch(editItem(id));
  }

  _removeEditMode() {
    const { dispatch } = this.props;

    dispatch(editItem(null));
  }

  _handleDescriptionKeyUp(e) {
    if (e.which != 13) return false;

    const { id, dispatch, channel } = this.props;

    channel.push('time_entry:update', { id: id, description: e.target.value.trim() })
    .receive('ok', (data) => {
      dispatch(replaceTimeEntry(data));
    });
  }

  render() {
    const { id, duration, displayDropdown, selected } = this.props;

    const checkboxClasses = classnames({
      'checkbox-container': true,
      active: displayDropdown,
    });

    return (
      <li>
        <div className={checkboxClasses}>
          <input checked={selected} ref="checkbox" id={id} type="checkbox" onChange={::this._handleCheckboxChange}/>
          <label htmlFor={id}></label>
          <i className="fa fa-caret-down" onClick={::this._handleToggleDropdownClick}/>
          {::this._renderDropdown()}
        </div>
        <div className="description-container" onClick={::this._handleEditClick}>
          {::this._renderDescription()}
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
