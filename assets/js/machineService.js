const machineService = {
  list: ()=> fetch(API_BASE + "/machines").then(r=>r.json()),
  get: (id)=> fetch(API_BASE + "/machines/"+id).then(r=>r.json()),
  create: (data)=> fetch(API_BASE + "/machines", {method:"POST", headers:{"Content-Type":"application/json"}, body: JSON.stringify(data)}).then(r=>r.json()),
  update: (id,data)=> fetch(API_BASE + "/machines/"+id, {method:"PUT", headers:{"Content-Type":"application/json"}, body: JSON.stringify(data)}).then(r=>r.json()),
  delete: (id)=> fetch(API_BASE + "/machines/"+id, {method:"DELETE"}).then(r=>r.json()),
  movements: (id)=> fetch(API_BASE + "/machine-movements?machineId="+id).then(r=>r.json()),
  meterReadings: (id)=> fetch(API_BASE + "/meter-readings?machineId="+id).then(r=>r.json())
};