$(document).ready(function() {
    $.get("/obtenerNiveles", function(data, status) {
      console.log(status);
      console.log(data);
  
      data = JSON.parse(data);
      data.forEach(materia => {
        $("#niveles").append( 
          htmlDeNivel(materia.nombre, materia.nivel) 
        );
      });
    });
      
  });
  
  function htmlDeNivel(nombre, nivel) {
    return `<li class="list-group-item">${nombre}: ${nivel}</li>`;  
  }
  
  