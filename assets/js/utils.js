function showAlert(msg, type='info'){
  const div = document.createElement('div');
  div.className = 'alert alert-'+type;
  div.innerText = msg;
  document.getElementById('content-main').prepend(div);
  setTimeout(()=>div.remove(),4000);
}

function formatDate(dt){
  return dt ? new Date(dt).toLocaleString() : '';
}

// 🔑 Helper para fetch con autenticación Basic
function authFetch(url, options = {}) {
  const auth = JSON.parse(localStorage.getItem("auth") || "{}");
  if (auth.username && auth.password) {
    const token = btoa(auth.username + ":" + auth.password);
    options.headers = {
      ...(options.headers || {}),
      "Authorization": "Basic " + token
    };
  }
  return fetch(url, options);
}