<?php

session_start();

$usuario = $_REQUEST['usuario'];
$clave = $_REQUEST['clave'];

$controller = 1;
require_once '../controller/usuarioAccesoController.php';

if (count($usuarioAcceso)>0) {

    if ($clave===$usuarioAcceso[0]['clave']) {

        $_SESSION['errors'] = NULL;

        $_SESSION['idusuarioacceso'] = $usuarioAcceso[0]['idusuarioacceso'];
        $_SESSION['idtipousuario'] = $usuarioAcceso[0]['idtipousuario'];
        $_SESSION['nombres'] = $usuarioAcceso[0]['nombres'];
        $_SESSION['apellidos'] = $usuarioAcceso[0]['apellidos'];
        $_SESSION['correo'] = $usuarioAcceso[0]['correo'];


        header("Location: ../app/opc/1");

    } else {
        $_SESSION['errors'] = 'La contraseña ingresada, es incorrecta.';
        header("location: ../app/");

    }

} else {
    $_SESSION['errors'] = 'Tal usuario no existe.';
    header("location: ../app/");

}