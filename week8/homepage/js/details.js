/* eslint-disable linebreak-style */
/* eslint-disable require-jsdoc */
/* --Functions-- */

// Declare an array to store the data from http request
details = [];

// Trigger the get detail function on DOM loaded
document.addEventListener('DOMContentLoaded', () => {
  getDetails();
});

// Function to perform the http get request
async function performGetHttpRequest(fetchLink, headers) {
  // Error checker
  if (!fetchLink || !headers) {
    throw new Error('One or more GET request parameters was not passed.');
  };
  // Make the api call
  try {
    const rawResponse = await fetch(fetchLink, {
      method: 'GET',
      headers: headers,
    });
    // return the answer back
    const content = await rawResponse.json();
    return content;
    // Error catcher
  } catch (err) {
    console.error(`Error at fetch POST: ${err}`);
    throw err;
  }
}
// the main furnction
async function getDetails() {
  // variable to build the html + data from server
  let content = '';
  // build the header for the http request
  const headers = buildHeaders();
  // Make the http call
  const response = await performGetHttpRequest(`https://jsonplaceholder.typicode.com/users/1/posts`, headers);
  // if the response is ok build html with the new data
  if (response) {
    content += `
      <div class="col mb-5 h-100">
      <div class="feature-details bg-primary bg-gradient 
      text-white rounded-3 mb-3"><i class="bi bi-collection"></i></div>
      <h2 class="h5">${response[0].title}</h2>
      <p class="mb-0">${response[0].body}</p>
    </div>
    <div class="col mb-5 h-100">
      <div class="feature-details bg-primary bg-gradient
      text-white rounded-3 mb-3"><i class="bi bi-building"></i></div>
      <h2 class="h5">${response[1].title}</h2>
      <p class="mb-0">${response[1].body}</p>
    </div>
    <div class="col mb-5 mb-md-0 h-100">
      <div class="feature-details bg-primary bg-gradient 
      text-white rounded-3 mb-3"><i class="bi bi-toggles2"></i></div>
      <h2 class="h5">${response[2].title}</h2>
      <p class="mb-0">${response[2].body}</p>
    </div>
    <div class="col h-100">
      <div class="feature-details bg-primary bg-gradient
      text-white rounded-3 mb-3"><i class="bi bi-toggles2"></i></div>
      <h2 class="h5">${response[3].title}</h2>
      <p class="mb-0">${response[3].body}</p>
    </div>
      `;
    // Add into div with addDetails id
    document.querySelector('#addDetails').innerHTML = content;
  }
}
// function to build headers for http request
function buildHeaders(authorization=null) {
  const headers = {
    'Content-Type': 'application/json, charset=UTF-8',
    'Authorization': (authorization) ? authorization : 'Bearer TOKEN_MISSING',
  };
  return headers;
}
