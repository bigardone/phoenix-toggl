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
  document.title = `${title} • Phoenix Toggl`;
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

export const faviconData = {
  off: 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAADoAAAA6CAYAAADhu0ooAAAAAXNSR0IArs4c6QAABF1JREFUaAXlm0trE1EUx5sJBpwmC1cKduEmRtwkRYrtohtx58aCabsxTQJ+BLHFVRfSgp+gLvpACKUVKvgRirQi0myUFjcuUqgrlaTjA5r6/09mwsxkMq+m7czthZu5M/cx5zfn3MfMPYn1nULI5/OJ/v7+u7FYbATNZ3DMHB8fX0c6pUXetc6IvH3k7SG9h+PW4eHhh/X19X8s0MsQ61VjgEsC7hEEn0QcRbtywLYVAG8irgL6DaAbAdsxVTsxaLFYTANsmoAngDMJZTgh9Cri/PLy8lfDdd/JwKAAvCFJ0hzuOI4o+b6zvwpNFF9rNpszAP7mr2qrtG9Q9r9kMvkU1Z9Di5eD3DRoHWj2N+q+aDQaL/32Y1+g0OI1wG0gDgcVthf1ALyNOAbtHnhtzzPo1NTUnXg8/hYND3ht/JTL1Y6Ojh6urKx88nIfT32rXC6Poz9uhgiSbAOUibJ5AY27FYK5PoOpLiBecit71vmaTPlsNvunWq2+d7q/o+mWSqUJNLbq1ECI8iYWFxfXusnTFZR9kqYB0DMdWbsJ6nadIzKmn9FufdYWlKMrID+i8bAMPG6cen4NsEN2o3HHYMR5ElrciCAkYQcoOxl0cv3YAcrFAAqf6zypCxfkSNm1BY2pusl0uaxDwS+IkeiXJhLDCfsr4m3jctGkUfTLuahDkpcMZDGw97U1Cm2mkbmLTBO8sXDE0hiXmregVfWtpw2FpzAtECR1ImlMqn5UjfKlOZVKfceVoC/LamMh/FHq9fpVvryrGuWXAQEh+dxlja3VH6HiyRBqoyci6WwxTq4w2x+k70nL4WuE5ntFkmWZiwNRIfnYgSgPY0aRCCp0ICMHo4zQlC24DOca4UHJKGFNyC/oQgcy0nS5TSB6SF0oUNG1qfJRo9zVEj3ULw4oht590dVJRk4v3IQVOpCRpis8KBklfG7YFlqdgINGtyRFUQiqCAyr0C9C4oYqiLlTJmQgGxnZR6naqGwk+VaGzqaC0vsDLYhovjRbsrW+GfErmU7u+5GFuAKZyNYGZQIX53Gg94cooakxqTyq6TKlfdHuupEaQfo1/Ss9ZW+D8gRz6gyeAl1cIh3IQBYjhMmHAX4APwcHB7lJc89YKILpWWjznVFuk0aZQWclPJHIrpYoOxmMkEx3gGoLiDHk1ayFI3BeA+gYGayydoCyANR+QGcl2rq1QljPKStlpux2MtqCsiC9O9BXi3aVwniNsnbzSKG8psHICrCzs/OZzkpo5L41L0znGGGnl5aWXjnJ5AjKivTIyuVyu0g+AHCovMe0rvUY5rrgBMm89ta+W8EL4fTIh0D7h4kM4Sme+9RDGSiLU5+0Ks7VdI0VYMaNdDr9OpFI/MX1kbM2Zc1UZzFPPqlUKr+MsrmlPZuutSH6JGE7ji4uYrqaW4ELhcJNOCzT1ZXuAb3eUD7/Pw9YgenZIvTfQazAPKdfhLadzt10z3/wwQCzzY91dks4u/v4ufYfAVTmzzcg69gAAAAASUVORK5CYII=',
  on: 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAADoAAAA6CAYAAADhu0ooAAAAAXNSR0IArs4c6QAABDtJREFUaAXlm99PE0EQx2evKIVChIRDE4X4ohh9NEZ8QP4FTAzwqH+EAaOvRhP/CF+BmOi/QHgQY3zUSHwxoIm2JiA/K/YY57vtHu3Sa4+Kpbds0tzu/dibT+dmbndnTtF/KB+ITg+k/ZuUUreIeIgUDRGr87LtVkzduCUr2iCWn+Jvsl0iUksU8JuVfO7tNaLdoxZLHVWHWfK70hm6Kx1OitAjAtXZUN9M2/I3LDDRTH6LXvZTbrOhfqyL/hn0V7t/SbXRtCI12TCcJVTYFGgmnuECPTvzO/c53N9ApWHQ1XTPxbbUqadyz3FSymvg3vEvYd6Tk+cKwZ+Hvfm1L/Ev3D/z0KCwv8FO/4HAPRINdux31YQa0w4xP1nezj0/rB0fCjSb8c+llXolFw03ASvyFmK/i3nmO/1bue+RJ1kHYoOudfZdTyn1WjR5werjeJrMXwPmsZ7tn+/jCBDLtta6/PGU8hZaBhJk8odDJsh2JKDrGX8qRWq26fYYR3rxEZANMtY7veajK//WhHQ0U6+TVjgeEE/0bObmomSJBC3aJB7XJnvWKEnr7RePHPDeSJTNVgWFd5X3xruWssl6oDguDmqH6EY1b3zAGeE9iVdI4iABKg4KsoMBzfJyABSDAVHzsb4nywU8bB2y6wGNdWHFo1sc1p3+mBi7tGDCpthrIdi9Wj5crNCoHrsmxfmEVFUqwlAah4cHQ41iFuK10Sd5zivgwzOTVpGJwF6BrphZTwiFqZYzkFCKKEwzlRSkNYpJc0dG/RDbbGyy3KralvnszhafxeRdaxQrA85Baq1Sp2aTugYVtcryh5vFsHnFl6us8Thb1AgY1Ubav01tat5ZToAVeNTjlErsKCiucsAoNirrrs4XHvLE27oPKoyeXkF3XaMSJYBGdYjAaVZh9EwsxGVQMIZjXZdBwebpqJbjlGAUZyShO9eLMIozkvik60UYoVEJwjpehFGckUSanS9qyVMBLzrPKSkDClOYwUz/qpMTb2hQVhmWt7K9XjGgygvuapUXwKgHDEiMcBXUsJ2sxTGskiH7wzWtgsmk74RjXaS4SDQK2R9uFGHRTCWaELS0oh0ZSE0g/ZxZpYfs2kYNxIkJMunok+TxGPDEboWhPJIGjgqNYgcGEANd/fNyIJGrg8hBWtnMjtoJVwdAAXsiQvsARQ4AkpVk+CQpAQkpOlmDx6rlL4Ag9Lo2DrI7AsX37P2t2oasURkpkDkSFAeRt8PM06i3coGMtXKMIHtVG7WhdGIVqxdydnOzOW1B7DYeV8X3BXLWPmS3Y4HiohOR9AhQPP9IVoL7Rvs4C2SALLVs0pavpo3aJ8Oj4R1Fe/z4WDwy3gJyb8gQ5V1tmU079qNrLjBb51PNDajZrrf3XZZA8pSzHw8YULN1/nMQA1q+1QtuaX+4GE2P/4EPViSX87lFe5xa3nej9b9Uzbh0HJ7RFAAAAABJRU5ErkJggg==',
};

function numberToString(number) {
  return number > 9 ? number : `0${number}`;
}
