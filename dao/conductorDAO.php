<?php

date_default_timezone_set('America/Lima');

require_once '../db/database.php';

class ConductorDAO
{
    function datosDeConductor_conductorDAO($idConductor)
    {
        try {

            $database = new ConexionBD();

            $sql = ' SELECT * FROM tb_conductor WHERE cond_idconductor=:idConductor AND cond_estado="1" ';

            $database->query($sql);
            $database->bind(':idConductor', $idConductor);
            $database->execute();
            return $database->resultSet();

        } catch (Exception $e) {
            throw $e;
        }
    }

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


    function registrarToken_conductorDAO($idConductor, $token)
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

    function existeSesion_conductorDAO($idSesion, $idConductor, $token)
    {
        try {

            $database = new ConexionBD();

            $sql = ' SELECT * FROM mv_sesioncond
                        WHERE scond_idsesioncond=:idSesion
                             AND cond_idconductor=:idConductor
                             AND scond_token=:token ';

            $database->query($sql);
            $database->bind(':idSesion', $idSesion);
            $database->bind(':idConductor', $idConductor);
            $database->bind(':token', $token);
            $database->execute();
            return $database->resultSet();

        } catch (Exception $e) {
            throw $e;
        }
    }

    function cerrarSesion_conductorDAO($idSesion, $idConductor, $token)
    {
        try {

            $database = new ConexionBD();

            $existe = $this->existeSesion_conductorDAO($idSesion, $idConductor, $token);

            if (count($existe)>0) {

                $sql = ' DELETE FROM mv_sesioncond
                        WHERE scond_idsesioncond=:idSesion
                             AND cond_idconductor=:idConductor
                             AND scond_token=:token ';

                $database->query($sql);
                $database->bind(':idSesion', $idSesion);
                $database->bind(':idConductor', $idConductor);
                $database->bind(':token', $token);
                $database->execute();

                return "ok";

            } else {
                return "no_existe";
            }

        } catch (Exception $e) {
            throw $e;
        }
    }

}
 