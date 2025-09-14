const serviceVisitService = {
  list: ()=> fetch(API_BASE + "/api/service-visits").then(r=>r.json()),
  create: (data)=> fetch(API_BASE + "/api/service-visits", {method:"POST", headers:{"Content-Type":"application/json"}, body: JSON.stringify(data)}).then(r=>r.json())
};