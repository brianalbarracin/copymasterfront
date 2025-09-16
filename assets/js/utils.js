function showAlert(msg, type='info'){ 
  const div = document.createElement('div'); 
  div.className = `alert alert-${type} alert-dismissible fade show`; 
  div.innerHTML = `
    ${msg}
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
  `;
  document.getElementById('content-main').prepend(div); 
  setTimeout(()=>{ if(div.parentNode){ div.remove(); } }, 4000); 
}

function formatDate(dt){ 
  return dt ? new Date(dt).toLocaleString() : ''; 
}

function formatDateOnly(dt){ 
  return dt ? new Date(dt).toLocaleDateString() : ''; 
}

// 🔑 Helper para fetch con Basic Auth
function authFetch(url, options = {}) {
  const auth = JSON.parse(localStorage.getItem("auth") || "{}");
  if (auth.username && auth.password) {
    const token = btoa(auth.username + ":" + auth.password);
    options.headers = {
      ...(options.headers || {}),
      "Authorization": "Basic " + token,
      "Content-Type": options.headers?.["Content-Type"] || "application/json"
    };
  } else {
    console.warn("⚠️ No hay credenciales guardadas en localStorage.auth");
  }
  return fetch(url, options);
}