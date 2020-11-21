function getUrlVars() {
    var vars = {};
    var parts = window.location.href.replace(/[?&]+([^=&]+)=([^&]*)/gi, function(m,key,value) {
        vars[key] = value;
    });
    return vars;
}

function getUrlParam(parameter, defaultvalue){
    var urlparameter = defaultvalue;
    if(window.location.href.indexOf(parameter) > -1){
        urlparameter = getUrlVars()[parameter];
        }    
    return urlparameter;
}

$(document).ready(function() {    
    $.ajax({url: "/detalleDeBebida", type:"get", data: { id: getUrlParam("id", 0)}, 
        success: function(data, status) {            
            console.log(status);
            console.log(data);  
            data = JSON.parse(data);          
            $("#bebida").append(htmlDeBebida(data.bebida_id, data.nombre, data.descripcion, data.tiene_alcohol));
        }     
    });
});  
  
function htmlDeBebida(id, nombre, descripcion, tiene_alcohol) {
    return `    
    <div class="jumbotron">
        <h1 class="display-4">${nombre}</h1>
        <p class="lead">${descripcion}</p>
        <hr class="my-4">
        <p>${(tiene_alcohol)?"Esta bebida contiene alcohol":""}</p>
        <button onclick="OrdenarBebida(${id})" class="btn btn-success btn-lg" role="button">Ordenar</button>
    </div>`;  
}

function OrdenarBebida(id) {
    $.ajax({url: "/ordenarBebida", type:"get", data: { id: id }, 
        success: function(data, status) {            
            console.log(status);
            console.log(data);    
            if (data === "La bebida se agregó correctamente a la fila") {
                $("#bebida").append(`<div class="alert alert-success" role="alert">
                                        ${data} 
                                     </div>`);
                window.location = "/";
            } else {
                $("#bebida").append(`<div class="alert alert-danger" role="alert">
                                        ${data} 
                                     </div>`);
            }            
        }     
    });
}
  
  