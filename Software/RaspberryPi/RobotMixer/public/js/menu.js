$(document).ready(function() {
  $.get("/menu", function(data, status) {
    console.log(status);
    console.log(data);

    data = JSON.parse(data);
    data.forEach(bebida => {
      $("#menu").append( 
        htmlDeBebida(bebida.bebida_id, bebida.nombre, bebida.descripcion, bebida.tiene_alcohol) 
      );
    });
  });

  $.get("/fila", function(data, status) {
    console.log(status);
    console.log(data);

    data = JSON.parse(data);
    if(data.length > 0) {
      $("#fila-container").attr('class', 'd-block');
      data.forEach(bebida => {
        $("#fila").append( 
          htmlDeFila(bebida.nombre)
        );
      });
    }
    
  });

  setInterval(function () {
    $.get("/fila", function(data, status) {
      console.log(status);
      console.log(data);
  
      data = JSON.parse(data);
      if(data.length > 0) {
        $("#fila-container").attr('class', 'd-block');
        $("#fila").html("");
        data.forEach(bebida => {
          $("#fila").append( 
            htmlDeFila(bebida.nombre)
          );
        });
      }
      
    });
  }, 5000);
  
});


  





function htmlDeBebida(id, nombre, descripcion, tiene_alcohol) {
  return `        
      <div class="col mb-4">
        <div class="card bg-light mb-3">        
        <a href="/detalle?id=${id}">
          <img src="static/img/${id}.png" class="card-img-top" alt="...">
          <div class="card-body">
            <h5 class="card-title">${nombre}</h5>
            <h6>${(tiene_alcohol)?"Bebida alcohólica":""}</h6>
            <p class="card-text">${descripcion}</p>
            <a class="btn btn-sm btn-primary" href="/detalle?id=${id}">Ordenar</a>
          </div>
        </div>
        </a>
      </div>
    `;  
}

function htmlDeFila(nombre) {
  return `<li class="list-group-item">${nombre}</li>`;  
}

