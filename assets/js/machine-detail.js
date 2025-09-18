// Variable global para almacenar datos de la máquina
window.machineData = null;

async function loadDetail(){
  console.log("🔍 INICIANDO loadDetail()");
  const params = new URLSearchParams(location.search);
  const id = params.get("id");
  
  console.log("📋 ID obtenido de URL:", id);
  
  if(!id) {
    showAlert("ID de máquina no especificado", "danger");
    return;
  }
  
  // Guardar ID en variable global para reutilizar
  window.__MID = id;

  try {
    // Mostrar loading
    document.getElementById("m-title").innerText = "Cargando...";
    document.getElementById("m-sub").innerText = "Por favor espere";
    document.getElementById("btn-move").disabled = true;

    // Obtener datos de la máquina usando el servicio corregido
    console.log("🖥️ Obteniendo máquina con ID:", id);
    window.machineData = await machineService.get(id);
    console.log("✅ Datos de la máquina obtenidos:", window.machineData);

    if (!window.machineData) {
      throw new Error("No se encontraron datos de la máquina");
    }

    // Cargar ubicaciones si no están en cache
    if (!window.locationsCache || window.locationsCache.length === 0) {
      try {
        console.log("📍 Cargando ubicaciones...");
        window.locationsCache = await locationService.list();
        console.log("✅ Ubicaciones cargadas:", window.locationsCache);
      } catch (err) {
        console.warn("⚠️ Error cargando ubicaciones:", err);
        window.locationsCache = [];
      }
    }

    // Actualizar información principal
    document.getElementById("m-title").innerText = 
      window.machineData.companySerial || `Máquina ${window.machineData.id}`;
    document.getElementById("m-sub").innerText = 
      `${window.machineData.brand || 'Sin marca'} ${window.machineData.model || 'Sin modelo'}`;

    // Información básica
    document.getElementById("m-info").innerHTML = `
      <tr><th>ID</th><td>${window.machineData.id || 'N/A'}</td></tr>
      <tr><th>Serial</th><td>${window.machineData.companySerial || 'N/A'}</td></tr>
      <tr><th>Número</th><td>${window.machineData.companyNumber || 'N/A'}</td></tr>
      <tr><th>Modelo</th><td>${window.machineData.model || 'N/A'}</td></tr>
      <tr><th>Marca</th><td>${window.machineData.brand || 'N/A'}</td></tr>
      <tr><th>Año</th><td>${window.machineData.year || 'N/A'}</td></tr>
      <tr><th>Estado</th><td>${window.machineData.status || 'N/A'}</td></tr>
      <tr><th>Notas</th><td>${window.machineData.notes || 'Sin notas'}</td></tr>
    `;

    // Información de ubicación
    let locationName = 'No asignada';
    if (window.locationsCache && window.locationsCache.length > 0) {
        const location = window.locationsCache.find(l => l.id === window.machineData.currentLocationId);
        locationName = location ? location.name : 'Ubicación no encontrada';
    }
    
    document.getElementById("m-location").innerHTML = `
      <tr><th>Ubicación Actual</th><td>${locationName}</td></tr>
      <tr><th>ID Ubicación</th><td>${window.machineData.currentLocationId || 'N/A'}</td></tr>
      <tr><th>Cliente Actual</th><td>${window.machineData.currentCustomerId || 'N/A'}</td></tr>
    `;

    // Habilitar botón de movimiento
    document.getElementById("btn-move").disabled = false;

    // Cargar movimientos
    await loadMovements(id);
    
    // Cargar lecturas
    await loadMeterReadings(id);

    console.log("🎉 Carga completada exitosamente");

  } catch(err) {
    console.error("❌ Error cargando detalle:", err);
    showAlert("Error cargando detalles de la máquina: " + err.message, "danger");
    document.getElementById("m-title").innerText = "Error";
    document.getElementById("m-sub").innerText = "No se pudo cargar la información";
    document.getElementById("m-info").innerHTML = '<tr><td colspan="2" class="text-center text-danger">Error cargando información</td></tr>';
    document.getElementById("m-location").innerHTML = '<tr><td colspan="2" class="text-center text-danger">Error cargando ubicación</td></tr>';
  }
}

async function loadMovements(machineId) {
  try {
    console.log("🔄 Cargando movimientos para máquina:", machineId);
    const moves = await machineService.movements(machineId);
    console.log("📦 Movimientos obtenidos:", moves);
    
    const movesData = moves || [];
    
    const tbody = document.querySelector("#m-movements tbody");
    if (movesData.length === 0) {
      tbody.innerHTML = '<tr><td colspan="5" class="text-center text-muted">No hay movimientos registrados</td></tr>';
      return;
    }

    tbody.innerHTML = movesData.map(move => {
      const fromLoc = window.locationsCache.find(l => l.id === move.fromLocationId)?.name || 'Desconocida';
      const toLoc = window.locationsCache.find(l => l.id === move.toLocationId)?.name || 'Desconocida';
      const date = move.effectiveDate ? new Date(move.effectiveDate).toLocaleDateString() : 'N/A';
      
      return `
        <tr>
          <td>${date}</td>
          <td>${fromLoc}</td>
          <td>${toLoc}</td>
          <td>${move.movementType || 'N/A'}</td>
          <td>${move.reason || 'Sin razón especificada'}</td>
        </tr>
      `;
    }).join('');
  } catch (err) {
    console.error("❌ Error cargando movimientos:", err);
    document.querySelector("#m-movements tbody").innerHTML = 
      '<tr><td colspan="5" class="text-center text-warning">No se pudieron cargar los movimientos</td></tr>';
  }
}

async function loadMeterReadings(machineId) {
  try {
    console.log("📊 Cargando lecturas para máquina:", machineId);
    const meters = await machineService.meterReadings(machineId);
    console.log("📦 Lecturas obtenidas:", meters);
    
    const metersData = meters || [];
    
    const tbody = document.querySelector("#m-meter tbody");
    if (metersData.length === 0) {
      tbody.innerHTML = '<tr><td colspan="3" class="text-center text-muted">No hay lecturas registradas</td></tr>';
      return;
    }

    tbody.innerHTML = metersData.map(meter => {
      const date = meter.readingDate ? new Date(meter.readingDate).toLocaleDateString() : 'N/A';
      
      return `
        <tr>
          <td>${date}</td>
          <td>${meter.reading || '0'}</td>
          <td>${meter.notes || 'Sin notas'}</td>
        </tr>
      `;
    }).join('');
  } catch (err) {
    console.error("❌ Error cargando lecturas:", err);
    document.querySelector("#m-meter tbody").innerHTML = 
      '<tr><td colspan="3" class="text-center text-warning">No se pudieron cargar las lecturas</td></tr>';
  }
}

function showMoveForm() {
  // Verificar que los datos de la máquina estén cargados
  if (!window.machineData || !window.machineData.currentLocationId) {
    showAlert("Primero debe cargarse la información de la máquina", "warning");
    return;
  }

  const select = document.getElementById("new-location");
  
  // Limpiar y llenar el select con ubicaciones
  select.innerHTML = '<option value="">Seleccione ubicación destino</option>';
  
  if (window.locationsCache && window.locationsCache.length > 0) {
    window.locationsCache.forEach(loc => {
      if (loc.id !== window.machineData.currentLocationId) {
        const option = document.createElement("option");
        option.value = loc.id;
        option.textContent = `${loc.name}${loc.address ? ' - ' + loc.address : ''}`;
        select.appendChild(option);
      }
    });
  } else {
    showAlert("No hay ubicaciones disponibles", "warning");
  }
  
  document.getElementById("move-form").style.display = "block";
  document.getElementById("move-reason").value = "";
}

function hideMoveForm() {
  document.getElementById("move-form").style.display = "none";
}

async function saveMovement() {
  // Verificar que los datos estén cargados
  if (!window.machineData) {
    showAlert("Los datos de la máquina no están cargados", "danger");
    return;
  }

  const toId = parseInt(document.getElementById("new-location").value);
  const reason = document.getElementById("move-reason").value.trim();
  
  if (!toId) {
    showAlert("Seleccione una ubicación destino válida", "warning");
    return;
  }
  
  if (!reason) {
    showAlert("Ingrese la razón del movimiento", "warning");
    return;
  }

  try {
    // Crear movimiento
    await fetch(API_BASE + "/machine-movements", {
      method: "POST",
      headers: {"Content-Type": "application/json"},
      body: JSON.stringify({
        machineId: window.__MID,
        fromLocationId: window.machineData.currentLocationId,
        toLocationId: toId,
        movementType: "REUBICACION",
        reason: reason,
        effectiveDate: new Date().toISOString()
      })
    });

    // Actualizar ubicación actual de la máquina
    const updateData = {
      ...window.machineData,
      currentLocationId: toId
    };
    
    await machineService.update(window.__MID, updateData);

    showAlert("Movimiento registrado correctamente", "success");
    hideMoveForm();
    
    // Recargar datos
    await loadDetail();
    
  } catch(err) {
    console.error("❌ Error guardando movimiento:", err);
    showAlert("Error al guardar el movimiento: " + err.message, "danger");
  }
}

// Cargar detalles cuando el documento esté listo
document.addEventListener("DOMContentLoaded", loadDetail);
