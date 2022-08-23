/* eslint-disable linebreak-style */
/* eslint-disable require-jsdoc */
/* --Functions-- */

async function performPostHttpRequest(fetchLink, headers, body) {
  if (!fetchLink || !headers || !body) {
    throw new Error('One or more POST request parameters was not passed.');
  };
  try {
    const rawResponse = await fetch(fetchLink, {
      method: 'POST',
      headers: headers,
      body: JSON.stringify(body),
    });
    const content = await rawResponse.json();
    console.log(content);
    return content;
  } catch (err) {
    console.error(`Error at fetch POST: ${err}`);
    throw err;
  }
}

async function submitForm(e, form) {
  e.preventDefault();
  const btnSubmit = document.getElementById('btnSubmit');
  setTimeout(() => btnSubmit.disabled = false, 2000);
  if (isValid) {
    const jsonFormData = buildJsonFormData(form);
    console.log(jsonFormData);
    const headers = buildHeaders();
    console.log(headers);
    const response = await performPostHttpRequest(`https://jsonplaceholder.typicode.com/posts`, headers, jsonFormData);
    console.log(response);
    if (response) {
      alert('Job done');
      form.reset();
    } else {
      alert('Error');
    };
  } else {
    return;
  };
}

function buildHeaders(authorization=null) {
  const headers = {
    'Content-Type': 'application/json, charset=UTF-8',
    'Authorization': (authorization) ? authorization : 'Bearer TOKEN_MISSING',
  };
  return headers;
}

function buildJsonFormData(form) {
  const jsonFormData = {};
  for (const keyValue of new FormData(form)) {
    jsonFormData[keyValue[0]] = keyValue[1];
  }
  return jsonFormData;
}


(function() {
  'use strict';
  window.addEventListener('load', function() {
    const forms = document.getElementsByClassName('needs-validation');
    const a=[];
    a.filter.call(forms, function(form) {
      form.addEventListener('submit', function(event) {
        if (form.checkValidity() === false) {
          event.preventDefault();
          event.stopPropagation();
        }
        form.classList.add('was-validated');
        submitForm(event, form);
      }, false);
    });
  }, false);
})();

function isValid() {

}
