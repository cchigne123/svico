<?php

date_default_timezone_set('America/Lima');

require_once '../db/database.php';

class ServicioDAO
{
    
    private $now;

    function __construct()
    {
        $this->now = date("Y-m-d H:i:s");
    }
    
    function detalleServicioDeConductor_servicioDAO($idConductor)
    {
        try {
            
            $database = new ConexionBD();
            
            $sql = ' SELECT a.dserv_origen as origen, a.dserv_latorigen as latorigen, a.dserv_lonorigen as lonorigen, 
                       a.dserv_destino as destino, a.dserv_latdestino as latdestino, a.dserv_londestino as londestino,
                       a.dserv_conaire as conaire, a.dserv_tipo as tipo, a.dserv_docpago as docpago,
                       a.dserv_costo as costo, b.cli_correo, b.cli_nombres, b.cli_apellidos
                    FROM tb_detalleservicio a, tb_cliente b, mv_ulttaxi c
                    WHERE c.cond_idconductor = :idconductor AND 
					(
						(c.utaxi_estadocond="1" AND c.utaxi_estadosolicitud="1") OR
						(c.utaxi_estadocond="2")
					) AND
					 a.cli_idcliente = b.cli_idcliente AND
                            a.dserv_iddetalleservicio = c.dserv_iddetalleservicio ';
            
            $database->query($sql);
            $database->bind(':idconductor', $idConductor);
            $database->execute();
            return $database->resultSet();
            
        } catch (Exception $ex) {
            throw $ex;
        }
    }
    
}