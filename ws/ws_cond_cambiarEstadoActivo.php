<?php

/**
 * autor: Jhonatan Sandoval
 * fecha: 05 Ago 2014
 * descripcion: Webservice para activar al taxista (visible para los clientes)
 */

// cabecera json
header('Content-Type: application/json');

// creando el objecto conductorDAO
require_once '../dao/conductorDAO.php';
$conductorDAO = new ConductorDAO();

// seteo de parametros recibidos via POST
$idConductor = $_REQUEST['idConductor'];
$latitud = $_REQUEST['latitud'];
$longitud = $_REQUEST['longitud'];

// validacion si algun campo es nulo o vacio
if ($idConductor!=='' && $latitud!=='' && $longitud!=='' &&
        isset($_REQUEST['idConductor']) && isset($_REQUEST['latitud']) && isset($_REQUEST['longitud'])) {

    // obtener conductor de BD
    $conductor = $conductorDAO->datosDeConductor_conductorDAO($idConductor);

    // verificar si existe el conductor
    if (count($conductor)>0) {

        // actualizar registro del taxi
        $conductorDAO->activarConductor_conductorDAO($idConductor, $latitud, $longitud);

        // mensaje de respuesta OK
        $json = array("success" => true ,
                "mensaje" => "Conductor activado.");

    } else {
        // idConductor no existe en BD
        $json = array("success" => false,
            "mensaje" => "No existe tal conductor en el sistema.");

    }

} else {
    // campos vacios
    $json = array("success" => false,
        "mensaje" => "Los campos no deben estar vacíos.");

}

echo json_encode($json);
