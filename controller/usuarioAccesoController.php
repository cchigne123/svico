<?php

require_once '../dao/usuarioAccesoDAO.php';
$usuarioAccesoDAO = new UsuarioAccesoDAO();

try {

    switch($controller) {
        case 1: // login de usuario panel de control
            $usuarioAcceso = $usuarioAccesoDAO->existeUsuarioAcceso($usuario);
            break;
    }

} catch (Exception $e) {
    throw $e;
}