<?php

/**
 * autor: Jhonatan Sandoval
 * fecha: 08 Ago 2014
 * descripcion: Webservice para aceptar solicitud de servicio
 */
 
// cabecera json
header('Content-Type: application/json');
 
// seteando objeto de conductor
require_once '../dao/conductorDAO.php';
$conductorDAO = new ConductorDAO();
 
// seteo de parametros recibidos via POST
$idConductor = $_REQUEST['idConductor'];
$latitud = $_REQUEST['latitud'];
$longitud = $_REQUEST['longitud'];
$tiempoLlegada = $_REQUEST['tiempoLlegada'];

// validacion si algun campo es nulo o vacio
if ($idConductor!=='' && $latitud!=='' && $longitud!=='' && $tiempoLlegada!=='' &&
	        isset($_REQUEST['idConductor']) && isset($_REQUEST['latitud']) && 
					isset($_REQUEST['longitud']) && isset($_REQUEST['tiempoLlegada']) ) {
			
	// obtener conductor de BD
    $conductor = $conductorDAO->datosDeConductor_conductorDAO($idConductor);
	
	if (count($conductor)>0){
		
		// seteo de datos en array
		$Datos['idConductor'] = $idConductor;
		$Datos['latitud'] = $latitud;
		$Datos['longitud'] = $longitud;
		$Datos['tiempoLlegada'] = $tiempoLlegada;
		
		// registro en BD el mov. del taxis
		$rs = $conductorDAO->registroAceptarSolicitud_conductorDAO($Datos);
		
		if($rs==="ok") {
			// mensaje de respuesta OK
        	$json = array("success" => true ,
                "mensaje" => "Solicitud de servicio aceptada.");	
		}
		
		
	} else {
		// conductor no existe en BD
		$json = array("success" => false,
        		"mensaje" => "No existe un conductor con ese ID.");
		
	}
			
} else {
    // campos vacios
    $json = array("success" => false,
        "mensaje" => "Los campos no deben estar vacíos.");

}

echo json_encode($json);
