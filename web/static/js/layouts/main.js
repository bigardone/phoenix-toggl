import React from 'react';
import { Link } from 'react-router';

export default class MainLayout extends React.Component {
  constructor() {
    super();
  }

  render() {
    return (
      <div id="main_layout">
        {this.props.children}
      </div>
    );
  }
}
