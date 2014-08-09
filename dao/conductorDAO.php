<?php

date_default_timezone_set('America/Lima');

require_once '../db/database.php';

class ConductorDAO
{

    private $hoy_fechahora;

    function __construct()
    {
        $this->hoy_fechahora = date("Y-m-d H:i:s");
    }
	
	function listaDeConductores()
	{
		try {
			
			$database = new ConexionBD();
			
			$sql = ' SELECT a.cond_idconductor as idconductor, a.taxi_idtaxi as idtaxi, a.cond_correo as correo, 
                                    a.cond_nombres as nombres, a.cond_apellidos as apellidos, a.cond_dni as dni,
                                    a.cond_fecnaci as fecnaci, a.cond_ciudad as ciudad, a.cond_distrito as distrito,
                                    a.cond_direccion as direccion, a.cond_celular as celular, a.cond_nlicencia as nlicencia,
                                    a.cond_categlicencia as categlicencia, a.cond_calificacion as calificacion,
                                    a.cond_estado as estado
                                FROM
                                    tb_conductor a LEFT JOIN 
                                            tb_taxi b ON a.taxi_idtaxi=b.taxi_idtaxi  ';
			
			$database->query($sql);
			$database->execute();
			return $database->resultSet();			
			
		} catch (Exception $e) {
			throw $e;	
		}
	}

    function datosDeConductor_conductorDAO($idConductor)
    {
        try {

            $database = new ConexionBD();

            $sql = ' SELECT * FROM tb_conductor WHERE cond_idconductor=:idConductor  AND cond_estado="1" ';

            $database->query($sql);
            $database->bind(':idConductor', $idConductor);
            $database->execute();
            return $database->resultSet();

        } catch (Exception $e) {
            throw $e;
        }
    }

    function siExisteConductorConEmail_conductorDAO($email)
    {
        try {

            $database = new ConexionBD();

            $sql = ' SELECT * FROM tb_conductor WHERE cond_correo=:email ';

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

            $sql = ' INSERT INTO mv_sesioncond (cond_idconductor, scond_token, scond_feccrea)
                           VALUES (:idconductor, :token, :hoy_fechahora) ';

            $database->query($sql);
            $database->bind(':idconductor', $idConductor);
            $database->bind(':token', $token);
            $database->bind(':hoy_fechahora', $this->hoy_fechahora);
            $database->execute();
            return $database->lastInsertId();

        } catch (Exception $e) {
            throw $e;
        }
    }

    function existeConductorEnUltMovTaxi_conductorDAO($idConductor)
    {
        try {

            $database = new ConexionBD();

            $sql = ' SELECT * FROM mv_ulttaxi WHERE cond_idconductor=:idConductor ';
            $database->query($sql);
            $database->bind(':idConductor', $idConductor);
            $database->execute();

            $existe = $database->resultSet();

            return $existe;

        } catch (Exception $e) {
            throw $e;
        }
    }

    function regLoginUltMovTaxi_conductorDAO($idConductor)
    {
        try {

            $database = new ConexionBD();

            $existe = $this->existeConductorEnUltMovTaxi_conductorDAO($idConductor);

            if(count($existe)>0) {
                $sql = ' UPDATE mv_ulttaxi SET
                            utaxi_estadocond="0",
                            utaxi_estadosolicitud="0",
                            utaxi_diahora=:hoy_fechahora,
                            dserv_iddetalleservicio=NULL
                         WHERE cond_idconductor=:idConductor ';
                $database->query($sql);
                $database->bind(':idConductor', $idConductor);
                $database->bind(':hoy_fechahora', $this->hoy_fechahora);
                $database->execute();

            } else {
                $sql = ' INSERT INTO mv_ulttaxi (cond_idconductor, utaxi_estadocond, dserv_iddetalleservicio, utaxi_diahora)
                            VALUES (:idConductor, "0", NULL, :hoy_fechahora) ';

                $database->query($sql);
                $database->bind(':idConductor', $idConductor);
                $database->bind(':hoy_fechahora', $this->hoy_fechahora);
                $database->execute();

            }

            //$this->registroMovimientos_conductorDAO($idConductor, '0', '0', NULL, NULL);
            
            return "ok";

        } catch (Exception $e) {
            throw $e;
        }
    }

    function actualizarCoordsConductor_conductorDAO($idConductor, $latitud, $longitud)
    {
        try {

            $database = new ConexionBD();


            $sql = ' UPDATE mv_ulttaxi SET
                                utaxi_lattaxi=:latitud,
                                utaxi_lontaxi=:longitud,
                                utaxi_diahora=:hoy_fechahora
                         WHERE cond_idconductor=:idConductor ';

            $database->query($sql);
            $database->bind(':latitud', $latitud);
            $database->bind(':longitud', $longitud);
            $database->bind(':idConductor', $idConductor);
            $database->bind(':hoy_fechahora', $this->hoy_fechahora);
            $database->execute();
            
            return "ok";

        } catch (Exception $e) {
            throw $e;
        }
    }

    function activarConductor_conductorDAO($idConductor, $latitud, $longitud)
    {
        try {

            $database = new ConexionBD();

            $existe = $this->existeConductorEnUltMovTaxi_conductorDAO($idConductor);

            if(count($existe)>0) {
                $sql = ' UPDATE mv_ulttaxi SET
                                utaxi_estadocond="1" ,
                                utaxi_diahora=:hoy_fechahora
                         WHERE cond_idconductor=:idConductor ';
                $database->query($sql);
                $database->bind(':idConductor', $idConductor);
                $database->bind(':hoy_fechahora', $this->hoy_fechahora);
                $database->execute();

            } else {
                $sql = ' INSERT INTO mv_ulttaxi (cond_idconductor, utaxi_estadocond, dserv_iddetalleservicio, utaxi_diahora)
                            VALUES (:idConductor, "1", NULL, :hoy_fechahora) ';

                $database->query($sql);
                $database->bind(':idConductor', $idConductor);
                $database->bind(':hoy_fechahora', $this->hoy_fechahora);
                $database->execute();

            }

            $this->actualizarCoordsConductor_conductorDAO($idConductor, $latitud, $longitud);
            $this->registroMovimientos_conductorDAO($idConductor, '1', '0', $latitud, $longitud);

            return "ok";

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

    function siHaySolicitudParaConductor_conductorDAO($idConductor)
    {
        try {

            $database = new ConexionBD();

            $sql = ' SELECT * FROM mv_ulttaxi
                        WHERE cond_idconductor=:idconductor AND
                               utaxi_estadosolicitud="1" AND
                               utaxi_estadocond="1" ';

            $database->query($sql);
            $database->bind(':idconductor', $idConductor);
            $database->execute();
            return $database->resultSet();

        } catch (Exception $e) {
            throw $e;
        }
    }
    
    
    function registroMovimientos_conductorDAO($idConductor, $estadoCond, $estadoSolicitud, $latitud, $longitud)
    {
        try {
            
            $database = new ConexionBD();
            
            $idDetalleServicio = NULL;
            $latCliente = NULL;
            $lonCliente = NULL;
            
            // obtener id detalle de servicio
            $sql = ' SELECT * FROM mv_ulttaxi 
                    WHERE cond_idconductor=:idconductor ';            
            
            $database->query($sql);
            $database->bind(':idconductor', $idConductor);
            $database->execute();
            $detalleServicio = $database->resultSet();
            if (count($detalleServicio)>0) {
                $idDetalleServicio = $detalleServicio[0]['dserv_iddetalleservicio'];
                $latCliente = $detalleServicio[0]['utaxi_latcliente'];
                $lonCliente = $detalleServicio[0]['utaxi_loncliente'];
            } 
            
            $sql = ' INSERT INTO mv_movimientos 
                        (cond_idconductor, mov_lattaxi, mov_lontaxi, mov_estadocond, mov_estadosolicitud, 
                                mov_diahora, mov_latcliente, mov_loncliente, dserv_iddetalleservicio)
                     VALUES (:idconductor, :latitud, :longitud, :estadoCond, :estadoSol, 
                                :hoy_fechahora, :latCliente, :lonCliente, :idDetalleServicio) ';

            $database->query($sql);
            $database->bind(':idconductor', $idConductor);
            $database->bind(':latitud', $latitud);
            $database->bind(':longitud', $longitud);
            $database->bind(':estadoCond', $estadoCond);
            $database->bind(':estadoSol', $estadoSolicitud);
            $database->bind(':hoy_fechahora', $this->hoy_fechahora);
            $database->bind(':latCliente', $latCliente);
            $database->bind(':lonCliente', $lonCliente);
            $database->bind(':idDetalleServicio', $idDetalleServicio);
            $database->execute();
                
            return "ok";
            
        } catch (Exception $ex) {
            throw $ex;
        }
    }
    
    function cambioEstadoSolicitud_conductorDAO($idConductor, $estadoSolicitud, $latitud, $longitud)
    {
        try {
            
            $database = new ConexionBD();
            
            switch ($estadoSolicitud) {
                case 2:
                case 5:
                    $estadoCond = 2;
                    break;
                case 0:
                case 4:
                case 6:
                    $estadoCond = 1;
                    break;
            }
            
            $sql = ' UPDATE mv_ulttaxi SET
                        utaxi_lattaxi = :latitud ,
                        utaxi_lontaxi = :longitud ,
                        utaxi_estadocond = :estadoCond ,
                        utaxi_estadosolicitud = :estadoSol ,
                        utaxi_diahora = :hoy_fechahora 
                    WHERE cond_idconductor = :idconductor ';

            $database->query($sql);
            $database->bind(':idconductor', $idConductor);
            $database->bind(':latitud', $latitud);
            $database->bind(':longitud', $longitud);
            $database->bind(':estadoCond', $estadoCond);
            $database->bind(':estadoSol', $estadoSolicitud);
            $database->bind(':hoy_fechahora', $this->hoy_fechahora);
            $database->execute();
            
            $this->registroMovimientos_conductorDAO($idConductor, $estadoCond, $estadoSolicitud, $latitud, $longitud);
                
            return "ok";
            
        } catch (Exception $ex) {
            throw $ex;
        }
    }
	
	function registroAceptarSolicitud_conductorDAO($Datos)
	{
		try {
			$database = new ConexionBD();
			
			$sql = ' UPDATE mv_ulttaxi SET
						utaxi_lattaxi=:latitud ,
						utaxi_lontaxi=:longitud ,
						utaxi_estadocond="2" ,
						utaxi_estadosolicitud="2" ,
						utaxi_tiempollegada=:tiempoLlegada ,
						utaxi_diahora=:hoy_fechahora
					WHERE cond_idconductor=:idConductor ';
					
			$database->query($sql);
			$database->bind(':latitud', $Datos['latitud']);
			$database->bind(':longitud', $Datos['longitud']);
			$database->bind(':tiempoLlegada', $Datos['tiempoLlegada']);
			$database->bind(':idConductor', $Datos['idConductor']);
            $database->bind(':hoy_fechahora', $this->hoy_fechahora);
			$database->execute();
			
			// guardar en registro de movimientos
			$this->registroMovimientos_conductorDAO($Datos['idConductor'], '2', '2', 
						$Datos['latitud'], $Datos['longitud']);
			
			return "ok";
			
		} catch (Exception $e) {
			throw $e;	
		}
	}

}