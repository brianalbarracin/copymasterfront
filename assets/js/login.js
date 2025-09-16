document.addEventListener("DOMContentLoaded", ()=>{
  const form = document.getElementById("login-form");

  form.addEventListener("submit", async (e)=>{
    e.preventDefault();
    const username = form.username.value.trim();
    const password = form.password.value;

    if(!username || !password){
      document.getElementById("login-error").innerText = "Usuario y contraseña requeridos";
      return;
    }

    try {
      const res = await fetch(API_BASE + "/auth/login", {
        method:"POST",
        headers:{"Content-Type":"application/json"},
        body: JSON.stringify({ username, password })
      });

      if(!res.ok) {
        const errTxt = await res.text().catch(()=>"Credenciales inválidas");
        throw new Error(errTxt || "Credenciales inválidas");
      }

      const data = await res.json();

      // Guardar la info del usuario
      localStorage.setItem("user", JSON.stringify(data));

      // 🔑 Guardar credenciales para Authorization: Basic
      localStorage.setItem("auth", JSON.stringify({ username, password }));

      // Redirigir a la app
      window.location = "index.html";
    } catch(err) {
      document.getElementById("login-error").innerText = err.message || "Error en autenticar";
    }
  });
});