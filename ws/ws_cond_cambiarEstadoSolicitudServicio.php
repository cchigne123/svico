<?php

/**
 * autor: Jhonatan Sandoval
 * fecha: 06 Ago 2014
 * descripcion: Webservices para setear el estado de la solicitud de servicio
 *              dependiento del parámetro que se recibe vía POST
 */

// cabecera JSON
header('Content-Type: application/json');

// creando el objecto conductorDAO
require_once '../dao/conductorDAO.php';
$conductorDAO = new ConductorDAO();

// datos recibidos
$idConductor = $_REQUEST['idConductor'];
$estadoSolicitud = $_REQUEST['estadoSolicitud'];
$latitud = $_REQUEST['latitud'];
$longitud = $_REQUEST['longitud'];

if ($idConductor!=='' && $estadoSolicitud!=='' && 
        isset($_REQUEST['idConductor']) && isset($_REQUEST['estadoSolicitud'])) {
    
    $cambioEstado = $conductorDAO->cambioEstadoSolicitud_conductorDAO($idConductor, $estadoSolicitud, $latitud, $longitud);
    
    $json = array("success" => true ,
                    "mensaje" => "Estado de solicitud cambiada.");
    
    
} else {
    $json = array("success" => false ,
                    "mensaje" => "Los campos no deben estar nulos o vacíos.");
}

echo json_encode($json);