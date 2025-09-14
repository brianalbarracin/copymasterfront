document.addEventListener("DOMContentLoaded", ()=>{
  const form = document.getElementById("login-form");
  form.addEventListener("submit", async (e)=>{
    e.preventDefault();
    const username = form.username.value.trim();
    const password = form.password.value;
    if(!username || !password){ document.getElementById("login-error").innerText = "Usuario y contraseña requeridos"; return; }
    try{
      const res = await fetch(API_BASE + "/api/auth/login", { method:"POST", headers:{"Content-Type":"application/json"}, body: JSON.stringify({ username, password }) });
      if(!res.ok) {
        const errTxt = await res.text().catch(()=>"Credenciales inválidas");
        throw new Error(errTxt || "Credenciales inválidas");
      }
      const data = await res.json();
      // store user info only (no JWT handling requested). Backend response may include user object
      localStorage.setItem("user", JSON.stringify(data));
      window.location = "index.html";
    }catch(err){
      document.getElementById("login-error").innerText = err.message || "Error en autenticar";
    }
  });
});