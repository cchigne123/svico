<?php

require_once '../util/funciones.php';

require_once '../dao/conductorDAO.php';
$dao = new ConductorDAO();

$email = $_REQUEST['usuario'];
$clave = $_REQUEST['password'];

if ($email !== '' && $clave !== '') {

    $conductor = $dao->validarLogin_conductorDAO($email);

    if (count($conductor) > 0) {
        if ($conductor[0]['cond_clave'] === $clave) {

            $idConductor = $conductor[0]['cond_idconductor'];
            $token = generarStringAleatorio(20);

            $idSesion = $dao->registrarToken($idConductor, $token);

            $json = array(
                "success" => "1",
                "mensaje" => "Logueado correctamente.",
                "idSesion" => $idSesion,
                "idConductor" => $idConductor,
                "token" => $token,
                "nombres" => $conductor[0]['cond_nombres'],
                "apellidos" => $conductor[0]['cond_apellidos']
            );

        } else {
            $json = array("success" => "0",
                "mensaje" => "La clave ingresada no es la correcta.");

        }

    } else {
        $json = array("success" => "0",
            "mensaje" => "No existe tal email en la base de datos.");

    }

} else {
    $json = array("success" => "0",
        "mensaje" => "Los campos no deben estar vacios.");

}

echo json_encode($json);