<?php

header('Content-Type: application/json');

require_once '../util/funciones.php';

require_once '../dao/conductorDAO.php';
$conductorDAO = new ConductorDAO();

$email = $_REQUEST['usuario'];
$clave = $_REQUEST['password'];

if (($email !== '' && $clave !== '') &&
    (isset($_REQUEST['usuario']) && isset($_REQUEST['password'])) ) {

    $conductor = $conductorDAO->validarLogin_conductorDAO($email);

    if (count($conductor) > 0) {
        if ($conductor[0]['cond_clave'] === $clave) {

            $idConductor = $conductor[0]['cond_idconductor'];
            $token = generarStringAleatorio(20);

            $idSesion = $conductorDAO->registrarToken_conductorDAO($idConductor, $token);

            $json = array(
                "success" => true,
                "mensaje" => "Logueado correctamente.",
                "idSesion" => $idSesion,
                "idConductor" => $idConductor,
                "token" => $token,
                "nombres" => $conductor[0]['cond_nombres'],
                "apellidos" => $conductor[0]['cond_apellidos']
            );

        } else {
            $json = array("success" => false,
                "mensaje" => "La clave ingresada no es la correcta.");

        }

    } else {
        $json = array("success" => false,
            "mensaje" => "No existe tal email en la base de datos.");

    }

} else {
    $json = array("success" => false,
        "mensaje" => "Los campos no deben estar vacios.");

}

echo json_encode($json);