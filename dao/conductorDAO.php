<?php

require_once '../db/database.php';

class ConductorDAO
{

    function validarLogin_conductorDAO($email)
    {
        try {

            $database = new ConexionBD();

            $sql = ' SELECT * FROM tb_conductor WHERE cond_correo=:email AND cond_estado="1" ';

            $database->query($sql);
            $database->bind(':email', $email);
            $database->execute();
            return $database->resultSet();

        } catch (Exception $e) {
            throw $e;
        }
    }


    function registrarToken($idConductor, $token)
    {
        try {

            $database = new ConexionBD();

            $sql = ' SELECT * FROM mv_sesioncond WHERE cond_idconductor=:idconductor ';

            $database->query($sql);
            $database->bind(':idconductor', $idConductor);
            $database->execute();
            $rs = $database->resultSet();

            if (count($rs)>0) {
                // ya existe uno, entonces se borra
                $sql = ' DELETE FROM mv_sesioncond WHERE cond_idconductor=:idconductor ';

                $database->query($sql);
                $database->bind(':idconductor', $idConductor);
                $database->execute();

            }

            $sql = ' INSERT INTO mv_sesioncond (cond_idconductor, scond_token)
                           VALUES (:idconductor, :token) ';

            $database->query($sql);
            $database->bind(':idconductor', $idConductor);
            $database->bind(':token', $token);
            $database->execute();
            return $database->lastInsertId();

        } catch (Exception $e) {
            throw $e;
        }
    }

}
 