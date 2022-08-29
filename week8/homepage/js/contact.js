/* eslint-disable linebreak-style */
/* eslint-disable require-jsdoc */
/* --Functions-- */

// Function to perform a post request
async function performPostHttpRequest(fetchLink, headers, body) {
  // Error checker
  if (!fetchLink || !headers || !body) {
    throw new Error('One or more POST request parameters was not passed.');
  };
  // make a Post request
  try {
    const rawResponse = await fetch(fetchLink, {
      method: 'POST',
      headers: headers,
      body: JSON.stringify(body),
    });
    // save the server answer as json to return it
    const content = await rawResponse.json();
    return content;
    // Error catcher
  } catch (err) {
    console.error(`Error at fetch POST: ${err}`);
    throw err;
  }
}
// Function to submit the form
async function submitForm(e, form) {
  e.preventDefault();
  // Listen the submit button
  const btnSubmit = document.getElementById('btnSubmit');
  setTimeout(() => btnSubmit.disabled = false, 2000);
  // If all check passed
  if (isValid()) {
    // Build the json from form values
    const jsonFormData = buildJsonFormData(form);
    // Build header for the http rewuest
    const headers = buildHeaders();
    // Make the call to the endpoint
    const response = await performPostHttpRequest(`https://jsonplaceholder.typicode.com/posts`, headers, jsonFormData);
    // Trigger alerts for the response
    if (response) {
      alertInfo('Job done! Registered as ' + response.id, 'alert-success');
      form.reset();
    } else {
      alertInfo('Enter a valid infor please...', 'alert-danger');
    };
  } else {
    return alertInfo('The form cannot be empty.', 'alert-danger');
  };
}
// Function to build http headers
function buildHeaders(authorization=null) {
  const headers = {
    'Content-Type': 'application/json, charset=UTF-8',
    'Authorization': (authorization) ? authorization : 'Bearer TOKEN_MISSING',
  };
  return headers;
}
// function to build the form json
function buildJsonFormData(form) {
  const jsonFormData = {};
  for (const keyValue of new FormData(form)) {
    jsonFormData[keyValue[0]] = keyValue[1];
  }
  return jsonFormData;
}

// Standart validate function from Bootstrap
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
// const to store the form data
const fields = {};
// Listen for the entries in form
document.addEventListener('DOMContentLoaded', function() {
  fields.email = document.getElementById('email');
  fields.address = document.getElementById('address');
  fields.flat = document.getElementById('flat');
  fields.city = document.getElementById('city');
  fields.message = document.getElementById('message');
});
// Validation function to prevent sending the from empty
function isValid() {
  let valid = true;
  function isNotEmpty(v) {
    if (v == null || typeof v == 'undefined') return false;
    return (v.length > 0);
  }
  function fieldVal(field, valFunction) {
    if (field == null) return false;
    const isField = valFunction(field.value);
    if (!isField) return false;
    return isField;
  }
  valid &= fieldVal(fields.email, isNotEmpty);
  valid &= fieldVal(fields.address, isNotEmpty);
  valid &= fieldVal(fields.flat, isNotEmpty);
  valid &= fieldVal(fields.city, isNotEmpty);
  valid &= fieldVal(fields.message, isNotEmpty);
  return valid;
}
// Function to display alerts
function alertInfo(message, param) {
  const alertInfo = document.getElementById('alertInfo');
  if (!alertInfo.classList.contains('show')) {
    alertInfo.classList.add(param);
    alertInfo.classList.add('show');
    alertInfo.innerHTML = message;
    setTimeout(()=>{
      alertInfo.classList.remove('show');
      alertInfo.classList.remove(param);
      alertInfo.innerHTML = '';
    }, 1500);
  } else {
    alertInfo.classList.remove('show');
    alertInfo.classList.remove(param);
    alertInfo.innerHTML = '';
  }
}
