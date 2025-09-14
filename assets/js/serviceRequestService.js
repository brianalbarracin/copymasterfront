const serviceRequestService = {
  list: ()=> fetch(API_BASE + "/api/service-requests").then(r=>r.json()),
  get: (id)=> fetch(API_BASE + "/api/service-requests/"+id).then(r=>r.json()),
  create: (data)=> fetch(API_BASE + "/api/service-requests", {method:"POST", headers:{"Content-Type":"application/json"}, body: JSON.stringify(data)}).then(r=>r.json())
};