<?php

require_once '../dao/conductorDAO.php';

$conductorDAO = new ConductorDAO();

try {

    switch($controller) {
        case 1: // lista de conductores
            $Conductores = $conductorDAO->listaDeConductores();
            break;
    }

} catch (Exception $e) {
    throw $e;
}