const machineService = {
  list: ()=> fetch(API_BASE + "/api/machines").then(r=>r.json()),
  get: (id)=> fetch(API_BASE + "/api/machines/"+id).then(r=>r.json()),
  create: (data)=> fetch(API_BASE + "/api/machines", {method:"POST", headers:{"Content-Type":"application/json"}, body: JSON.stringify(data)}).then(r=>r.json()),
  update: (id,data)=> fetch(API_BASE + "/api/machines/"+id, {method:"PUT", headers:{"Content-Type":"application/json"}, body: JSON.stringify(data)}).then(r=>r.json()),
  delete: (id)=> fetch(API_BASE + "/api/machines/"+id, {method:"DELETE"}).then(r=>r.json()),
  movements: (id)=> fetch(API_BASE + "/api/machine-movements?machineId="+id).then(r=>r.json()),
  meterReadings: (id)=> fetch(API_BASE + "/api/meter-readings?machineId="+id).then(r=>r.json())
};