<?php

/**
 * autor: Jhonatan Sandoval
 * creación: 04 Ago 2014
 * descripcion: Webservice para cerrar sesion (borrar token) de conductor
 */

// cabecera json
header('Content-Type: application/json');

// creando objecto de ConductorDAO
require_once '../dao/conductorDAO.php';
$conductorDAO = new ConductorDAO();

// seteo de variables
$idSesion = $_REQUEST['idSesion'];
$idConductor = $_REQUEST['idConductor'];
$token = $_REQUEST['token'];

// varlidacion si algun campo es nulo o vacio
if ($idSesion !== '' && $idConductor !== '' && $token !== '' &&
    isset($_REQUEST['idSesion']) && isset($_REQUEST['idConductor']) && isset($_REQUEST['idConductor'])) {

    $existe = $conductorDAO->cerrarSesion_conductorDAO($idSesion, $idConductor, $token);

    if ($existe==='ok') {
        $success = true;
        $mensaje = "Sesion cerrada correctamente.";

        // poner conductor a inactivo
        $conductorDAO->regLoginUltMovTaxi_conductorDAO($idConductor);

    } else if($existe==='no_existe') {
        $success = false;
        $mensaje = "No existe sesion con tales parametros.";

    }

} else {
    $success = false;
    $mensaje = "Los campos no deben estar vacios.";

}

$json = array ("success" => $success, "mensaje" => $mensaje);

echo json_encode($json);
