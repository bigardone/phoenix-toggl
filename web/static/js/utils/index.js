import React        from 'react';
import fetch        from 'isomorphic-fetch';
import { polyfill } from 'es6-promise';
import moment       from 'moment';

const defaultHeaders = {
  Accept: 'application/json',
  'Content-Type': 'application/json',
};

function buildHeaders() {
  const authToken = localStorage.getItem('phoenixAuthToken');

  return { ...defaultHeaders, Authorization: authToken };
}

export function checkStatus(response) {
  if (response.status >= 200 && response.status < 300) {
    return response;
  } else {
    var error = new Error(response.statusText);
    error.response = response;
    throw error;
  }
}

export function parseJSON(response) {
  return response.json();
}

export function httpGet(url) {
  return fetch(url, {
    headers: buildHeaders(),
  })
  .then(checkStatus)
  .then(parseJSON);
}

export function httpPost(url, data) {
  const body = JSON.stringify(data);

  return fetch(url, {
    method: 'post',
    headers: buildHeaders(),
    body: body,
  })
  .then(checkStatus)
  .then(parseJSON);
}

export function httpDelete(url) {
  const authToken = localStorage.getItem('phoenixAuthToken');

  return fetch(url, {
    method: 'delete',
    headers: buildHeaders(),
  })
  .then(checkStatus)
  .then(parseJSON);
}

export function setDocumentTitle(title) {
  document.title = `${title} | Phoenix Toggl`;
}

export function renderErrorsFor(errors, ref) {
  if (!errors) return false;

  return errors.map((error, i) => {
    if (error[ref]) {
      return (
        <div key={i} className="error">
          {error[ref]}
        </div>
      );
    }
  });
}

export function timexDateTimeToString(date) {
  const { year, month, day, hour, minute, second } = date;

  return `${year}-${month}-${day} ${hour}:${minute}:${second}`;
}

export function timexDateToString(date) {
  const { year, month, day } = date;

  return `${year}-${month}-${day}`;
}

export function formatDuration(duration) {
  if (duration.hours() > 0) {
    return `${numberToString(duration.hours())}:${numberToString(duration.minutes())}:${numberToString(duration.seconds())}`;
  } else if (duration.minutes() > 0) {
    return `${numberToString(duration.minutes())}:${numberToString(duration.seconds())} min`;
  } else {
    return `${duration.seconds()} sec`;
  }
}

function numberToString(number) {
  return number > 9 ? number : `0${number}`;
}
