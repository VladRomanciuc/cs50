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
    }).then((response) => response.json()).then((json) => console.log(json));

    const content = await rawResponse.json();
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
  const jsonFormData = buildJsonFormData(form);
  console.log(jsonFormData);
  const headers = buildHeaders();
  console.log(headers);
  const response = await performPostHttpRequest(`https://jsonplaceholder.typicode.com/posts`, headers, jsonFormData);
  console.log(response);
  if (response) {
    alert('Job done');
  } else {
    alert('Error');
  };
}

function buildHeaders(authorization=null) {
  const headers = {
    'Content-Type': 'application/json, charset=UTF-8',
    'Authorization/': (authorization) ? authorization : 'Bearer TOKEN_MISSING',
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

const contactForm = document.querySelector('#contactForm');
if (contactForm) {
  contactForm.addEventListener('submit', function(e) {
    submitForm(e, this);
  });
}

document.addEventListener('DOMContentLoaded', function() {
  const form = document.querySelector('needs-validation');
  if (form) {
    form.addEventListener('submit', function(event) {
      if (form.checkValidity() === false) {
        event.preventDefault();
        event.stopPropagation();
      }
      form.classList.add('was-validated');
    }, false);
  };
});


