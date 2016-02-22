import React, {PropTypes}   from 'react';
import { connect }          from 'react-redux';
import { fetchData }        from '../../actions/reports';
import { setDocumentTitle } from '../../utils';
import ReportContainer      from '../../components/reports/container';
import RangeSelector        from '../../components/reports/range_selector';

class ReportsIndeView extends React.Component {
  componentDidMount() {
    const { dispatch, channel, filter } = this.props;

    setDocumentTitle('Reports');

    if (channel == null) return false;

    dispatch(fetchData(channel, filter.numberOfWeeks));
  }

  componentWillReceiveProps(nextProps) {
    const { dispatch, channel } = this.props;
    const nextChannel = nextProps.channel;
    const nextFilter = nextProps.filter;

    if (channel == null && nextChannel != null) dispatch(fetchData(nextChannel, nextFilter.numberOfWeeks));
  }

  render() {
    const { fetching, data, filter, dispatch, channel } = this.props;

    return (
      <div id="reports_index" className="view-container">
        <div className="container">
          <header className="view-header">
            <h1>Summary report</h1>
            <RangeSelector
              channel={channel}
              dispatch={dispatch}
              {...filter}/>
          </header>
          <ReportContainer
            data={data}
            hideLabels={filter.numberOfWeeks > 2} />
        </div>
      </div>
    );
  }
}

const mapStateToProps = (state) => (
  { ...state.reports, channel: state.session.channel }
);

export default connect(mapStateToProps)(ReportsIndeView);
