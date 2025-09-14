document.addEventListener("DOMContentLoaded", ()=>{
  // Ensure user logged in
  const user = localStorage.getItem("user");
  if(!user){ window.location = "login.html"; return; }
  const userObj = JSON.parse(user);
  document.getElementById("current-user").innerText = userObj.username || userObj.fullName || "";

  // helper to load snippet into content-main
  window.appLoad = async function(path){
    try{
      const res = await fetch(path);
      if(!res.ok) throw new Error("No se pudo cargar " + path);
      const html = await res.text();
      document.getElementById("content-main").innerHTML = html;
      // execute scripts inside snippet
      const tmp = document.createElement('div'); tmp.innerHTML = html;
      tmp.querySelectorAll('script').forEach(s=>{
        const script = document.createElement('script');
        if(s.src) script.src = s.src;
        else script.textContent = s.textContent;
        document.body.appendChild(script);
      });
    }catch(e){ console.error(e); document.getElementById("content-main").innerHTML = `<div class="alert alert-danger">Error: ${e.message}</div>`; }
  }

  // wire menu links
  document.querySelectorAll('a[data-page]').forEach(a=> a.addEventListener('click', (e)=> { e.preventDefault(); appLoad(a.dataset.page); }));
  document.getElementById("logout").addEventListener("click", ()=>{ localStorage.removeItem("user"); window.location="login.html"; });

  // initial load
  appLoad('home.html');
});