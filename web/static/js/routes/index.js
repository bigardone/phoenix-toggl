import { IndexRoute, Route }        from 'react-router';
import React                        from 'react';
import MainLayout                   from '../layouts/main';
import AuthenticatedContainer       from '../containers/authenticated';
import HomeIndexView                from '../views/home';
import RegistrationsNewView         from '../views/registrations/new';
import SessionsNewView              from '../views/sessions/new';
import ReportsIndexView              from '../views/reports/index';

export default (
  <Route component={MainLayout}>
    <Route path="/sign_up" component={RegistrationsNewView} />
    <Route path="/sign_in" component={SessionsNewView} />

    <Route path="/" component={AuthenticatedContainer}>
      <IndexRoute component={HomeIndexView} />
      <Route path="/reports" component={ReportsIndexView} />
    </Route>
  </Route>
);
