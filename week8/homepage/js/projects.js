/* eslint-disable linebreak-style */
/* eslint-disable require-jsdoc */
/* --Functions-- */

// Array to store the data from server
items = [];

// trigger to get the data on DOM loaded
document.addEventListener('DOMContentLoaded', () => {
  getData();
});

// a http get request function
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
    // Return the response from server
    const content = await rawResponse.json();
    return content;
    // Error catcher
  } catch (err) {
    console.error(`Error at fetch POST: ${err}`);
    throw err;
  }
}
// Function to get the data from server endpoint
async function getData() {
  // Variable to build the html markup + data from server
  let content = '';
  // Build headers for http request
  const headers = buildHeaders();
  // Make the api call
  const response = await performGetHttpRequest(`https://jsonplaceholder.typicode.com/albums/1/photos`, headers);
  // // if the response is ok build html with the new data
  if (response) {
    response.forEach((v) => {
      content += `
      <div class="card card-marg">
        <img class="card-img-top" src='${v.thumbnailUrl}' alt="Card image cap">
          <div class="card-body">
            <h5 class="card-title">${v.title}</h5>
            <p class="card-text">These are nested resources from fake API </p>
          </div>
          <div class="card-footer text-center">
          <a href="#modalDetails" type="button" class="btn btn-sm" 
          data-bs-toggle="modal">Details</a>
          </div>
      </div>

      <div id="modalDetails" class="modal fade" tabindex="-1" 
      role="dialog" aria-hidden="true">
      <div class="modal-dialog modal-lg modal-dialog-centered">
        <div class="modal-content">
          <div class="modal-header justify-content-end">
            <button type="button" class="close" 
            data-bs-dismiss="modal" aria-label="Close">
              <span aria-hidden="true">&times;</span>
            </button>
          </div>

          <div class="modal-body">
            <div class="row d-block d-sm-block d-md-inline-flex">
              <div class="text-center">
              <img class="card-marg" src="${v.url}">
              </div>
              <div class="">
                <h5 class="text-center">${v.title}</h5>
                <p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. 
                Donec eget fermentum massa. 
                Morbi lacinia auctor ex vitae fringilla.</p>
                <p>Donec condimentum ante arcu, eu porttitor velit commodo nec. 
                Donec id congue lacus. 
                Proin finibus commodo arcu ac rhoncus.</p>
                <p>Etiam tempor orci sem. Sed eros eros, 
                tristique et mauris et, sodales faucibus ex. 
                Vestibulum nec posuere lectus, eu vehicula augue.</p>
              </div>
              </div>
            </div>
         

        </div>
      </div>
    </div>

      `;
    });
    // Add into div with projects id
    document.querySelector('#projects').innerHTML = content;
  }
}
// Function to build the http headers
function buildHeaders(authorization=null) {
  const headers = {
    'Content-Type': 'application/json, charset=UTF-8',
    'Authorization': (authorization) ? authorization : 'Bearer TOKEN_MISSING',
  };
  return headers;
}
