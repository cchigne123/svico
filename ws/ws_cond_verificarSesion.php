<?php

header('Content-Type: application/json');

require_once '../dao/conductorDAO.php';
$conductorDAO = new ConductorDAO();

$idSesion = $_REQUEST['idSesion'];
$idConductor = $_REQUEST['idConductor'];
$token = $_REQUEST['token'];

if ($idSesion !== '' && $idConductor !== '' && $token !== '' &&
        isset($_REQUEST['idSesion']) && isset($_REQUEST['idConductor']) && isset($_REQUEST['idConductor'])) {

    $existe = $conductorDAO->existeSesion_conductorDAO($idSesion, $idConductor, $token);

    if (count($existe)>0) {
        $success = true;
        $mensaje = "Existe una sesion en base de datos";
    } else {
        $success = false;
        $mensaje = "No existe sesion con tales parametros.";
    }

} else {
    $success = false;
    $mensaje = "Los campos no deben estar vacios";
}

$json = array ("success" => $success, "mensaje" => $mensaje);

echo json_encode($json);