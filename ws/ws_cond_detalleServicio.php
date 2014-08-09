<?php

/**
 * autor: Jhonatan Sandoval
 * fecha: 06 Ago 2014
 * descripcion: Webservice para traer el detalle de un servicio
 */

// cabecera JSON
header('Content-Type: application/json');

// seteando objeto
require_once '../dao/servicioDAO.php';
$servicioDAO = new ServicioDAO();

$idConductor = $_REQUEST['idConductor'];

if ($idConductor!=='' && isset($_REQUEST['idConductor'])) {
    
    $servicio = $servicioDAO->detalleServicioDeConductor_servicioDAO($idConductor);
    
    if (count($servicio)>0) {
        
        if ($servicio[0]['conaire']==true) {
            $aireAcond = true;
        } else {
            $aireAcond = false;
        }
        
        if ($servicio[0]['tipo']==='0') {
            $tipo = 'REMISSE';
        } else {
            $tipo = 'ESTACIÓN';
        }
        
        if ($servicio[0]['docpago']==='0') {
            $docPago = 'boleta';
        } else {
            $docPago = 'factura';
        }
        
        $json = array("success" => true ,
                        "origen" => utf8_encode($servicio[0]['origen']) ,
                        "latOrigen" => $servicio[0]['latorigen'] ,
                        "lonOrigen" => $servicio[0]['lonorigen'] ,
                        "destino" => utf8_encode($servicio[0]['destino']) ,
                        "latDestino" => $servicio[0]['latdestino'] ,
                        "lonDestino" => $servicio[0]['londestino'] ,
                        "aireAcond" => $aireAcond ,
                        "tipo" => utf8_encode($tipo) ,
                        "docpago" => $docPago ,
                        "costo" => $servicio[0]['costo'] ,
                        "clienteCorreo" => $servicio[0]['cli_correo'] ,
                        "clienteNombres" => $servicio[0]['cli_nombres'] ,
                        "clienteApellidos" => $servicio[0]['cli_apellidos']
                );
        
    } else {
        // no existe un servicio con ese id
        $json = array("success" => false ,
                        "mensaje" => "No existe servicios para ese ID de conductor.");
    }
    
    
} else {
    // campos vacios
    $json = array("success" => false ,
                    "mensaje" => "El ID del Servicio no puede ser nulo o vacío.");
}

echo json_encode($json);