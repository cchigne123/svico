<?php

/**
 * autor: Jhonatan Sandoval
 * creación: 04 Ago 2014
 * descripcion: Webservice para login de conductor
 */

// cabecera json
header('Content-Type: application/json');

require_once '../util/funciones.php';

// creando el objecto conductorDAO
require_once '../dao/conductorDAO.php';
$conductorDAO = new ConductorDAO();

// recoger parametros de post
$email = $_REQUEST['usuario'];
$clave = $_REQUEST['password'];

// validando email y clave no sean vacios
if (($email !== '' && $clave !== '') &&
    (isset($_REQUEST['usuario']) && isset($_REQUEST['password'])) ) {

    // verificar con la BD si existe tal email de conductor
    $conductor = $conductorDAO->siExisteConductorConEmail_conductorDAO($email);

    // si existe, entonces
    if (count($conductor) > 0) {

        // verificar si el conductor esta habilitado
        if($conductor[0]['cond_estado']==true) {

            // si la clave de la BD es igual a la que se recogio por POST
            if ($conductor[0]['cond_clave'] === $clave) {

                // seteando idConductor
                $idConductor = $conductor[0]['cond_idconductor'];

                // creando token
                $token = generarStringAleatorio(20);

                // registrar token en BD
                $idSesion = $conductorDAO->registrarToken_conductorDAO($idConductor, $token);

                // array de retorno correcto
                $json = array(
                    "success" => true,
                    "mensaje" => "Logueado correctamente.",
                    "idSesion" => $idSesion,
                    "idConductor" => $idConductor,
                    "token" => $token,
                    "nombres" => $conductor[0]['cond_nombres'],
                    "apellidos" => $conductor[0]['cond_apellidos']
                );

                // insertar en movimiento de taxi
                $conductorDAO->regLoginUltMovTaxi_conductorDAO($idConductor);

            } else {
                // clave incorrecta
                $json = array("success" => false,
                    "mensaje" => "La clave ingresada no es la correcta.");

            }

        } else {
            // conductor no está habilitado
            $json = array("success" => false,
                "mensaje" => "El conductor no está habilitado en el sistema.");
        }

    } else {
        // no exite el email en BD
        $json = array("success" => false,
            "mensaje" => "No existe tal email en la base de datos.");

    }

} else {
    // campos vacios
    $json = array("success" => false,
        "mensaje" => "Los campos no deben estar vacíos.");

}

echo json_encode($json);