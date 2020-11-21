$(document).ready(function() {
    $.get("/obtenerEstadisticas", function(data, status) {
      console.log(status);
      console.log(data);
  
      data = JSON.parse(data);
      data.forEach(bebida => {
        $("#estadisticas").append( 
          htmlDeBebida(bebida.bebida_id, bebida.nombre, bebida.descripcion, bebida.tiene_alcohol) 
        );
      });
    });
    
  });
  
  function htmlDeBebida(id, nombre, descripcion, tiene_alcohol) {
    return `        
        <div class="col mb-4">
          <div class="card bg-light mb-3">        
          <a href="/detalle?id=${id}">
            <img src="static/img/${id}.png" class="card-img-top" alt="...">
            <div class="card-body">
              <h5 class="card-title">${nombre}</h5>              
            </div>
          </div>
          </a>
        </div>
      `;  
  }
  
  