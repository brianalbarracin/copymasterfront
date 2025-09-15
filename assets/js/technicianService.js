const technicianService = {
  list: ()=> fetch(API_BASE + "/technicians").then(r=>r.json()),
  create: (data)=> fetch(API_BASE + "/technicians", {method:"POST", headers:{"Content-Type":"application/json"}, body: JSON.stringify(data)}).then(r=>r.json())
};