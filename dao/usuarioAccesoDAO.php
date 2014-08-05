<?php

require_once '../db/database.php';

class UsuarioAccesoDAO
{

    function existeUsuarioAcceso($usuario)
    {
        try {

            $database = new ConexionBD();

            $sql = ' SELECT * FROM tb_usuarioacceso WHERE idusuario=:usuario ';

            $database->query($sql);
            $database->bind(':usuario', $usuario);
            $database->execute();
            return $database->resultSet();

        } catch (Exception $e) {
            throw $e;
        }
    }

}