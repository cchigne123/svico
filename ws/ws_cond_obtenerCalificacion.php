<?php

header('Content-Type: application/json');

require_once '../dao/conductorDAO.php';
$conductorDAO = new ConductorDAO();

$idConductor = $_REQUEST['idConductor'];

if ($idConductor !== '' &&
        isset($_REQUEST['idConductor'])) {

    $conductor = $conductorDAO->datosDeConductor_conductorDAO($idConductor);

    if (count($conductor)>0) {

        $json = array("success" => true ,
            "calificacion" => $conductor[0]['cond_calificacion']
        );

    } else {
        $json = array("success" => false,
            "mensaje" => "No existe un conductor asociado a ese id.");
    }


} else {
    $json = array("success" => false,
        "mensaje" => "El id no debe estar vacio.");

}

echo json_encode($json);