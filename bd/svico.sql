-- phpMyAdmin SQL Dump
-- version 4.0.4.1
-- http://www.phpmyadmin.net
--
-- Servidor: localhost
-- Tiempo de generación: 09-08-2014 a las 02:18:08
-- Versión del servidor: 5.6.12
-- Versión de PHP: 5.5.3

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Base de datos: `svico`
--
CREATE DATABASE IF NOT EXISTS `svico` DEFAULT CHARACTER SET latin1 COLLATE latin1_swedish_ci;
USE `svico`;

DELIMITER $$
--
-- Procedimientos
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `cond_DesconectarCond`()
begin

declare total_rows int;
declare contador int unsigned default 1;
declare diferencia_tiempo int;
declare fecha_ahora datetime;

select COUNT(*) into total_rows from mv_ulttaxi;

 start transaction;
 while contador <= total_rows do
   
select @codigo_row:=x.utaxi_idulttaxi, @fecha_row:=x.utaxi_diahora
from (select t.utaxi_idulttaxi,
              t.utaxi_diahora,
              @rownum := @rownum +1 as position
         from mv_ulttaxi t
         join (select @rownum := 0) r
		 where t.utaxi_estadocond='1'
     order by t.utaxi_idulttaxi) x where x.position=contador;

	 select CONVERT_TZ(now(), @@global.time_zone, '-05:00') into fecha_ahora;
	 select time_to_sec(timediff(fecha_ahora, @fecha_row)) / 3600 into diferencia_tiempo;

    if diferencia_tiempo >= 1 then
update mv_ulttaxi set utaxi_diahora=fecha_ahora, utaxi_estadocond='0', utaxi_estadosolicitud='0' where utaxi_idulttaxi=@codigo_row;
    end if;
   set contador=contador+1;
 end while;
 commit;
end$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `mv_calificacion`
--

CREATE TABLE IF NOT EXISTS `mv_calificacion` (
  `cal_idcalificacion` int(11) NOT NULL AUTO_INCREMENT,
  `cond_idconductor` int(11) DEFAULT NULL,
  `cal_calificacion` int(1) NOT NULL,
  `cal_feccrea` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`cal_idcalificacion`),
  KEY `fk_mv_calificacion_tb_conductor1_idx` (`cond_idconductor`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `mv_movimientos`
--

CREATE TABLE IF NOT EXISTS `mv_movimientos` (
  `mov_idmovimiento` int(11) NOT NULL AUTO_INCREMENT,
  `cond_idconductor` int(11) NOT NULL,
  `mov_lattaxi` varchar(45) DEFAULT NULL,
  `mov_lontaxi` varchar(45) DEFAULT NULL,
  `mov_estadocond` char(1) DEFAULT NULL COMMENT '0 = cond. inactivo / 1 = cond. activo / 2 = cond. en servicio',
  `mov_estadosolicitud` char(1) DEFAULT NULL COMMENT '0=cond. libre / 1=recibio solicitud / 2=acepto solicitud / 3=tiempo agotado / 4=rechazo servicio / 5=inicio servicio / 6=servicio culminado',
  `mov_diahora` varchar(45) DEFAULT NULL,
  `mov_latcliente` varchar(45) DEFAULT NULL,
  `mov_loncliente` varchar(45) DEFAULT NULL,
  `dserv_iddetalleservicio` int(11) DEFAULT NULL,
  PRIMARY KEY (`mov_idmovimiento`),
  KEY `fk_mv_movimientos_tb_detalleservicio1_idx` (`dserv_iddetalleservicio`),
  KEY `fk_mv_movimientos_tb_conductor1_idx` (`cond_idconductor`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=10 ;

--
-- Volcado de datos para la tabla `mv_movimientos`
--

INSERT INTO `mv_movimientos` (`mov_idmovimiento`, `cond_idconductor`, `mov_lattaxi`, `mov_lontaxi`, `mov_estadocond`, `mov_estadosolicitud`, `mov_diahora`, `mov_latcliente`, `mov_loncliente`, `dserv_iddetalleservicio`) VALUES
(2, 1, NULL, NULL, '0', '0', '2014-08-07 12:22:59', NULL, NULL, NULL),
(7, 1, '-12.046383289764293', '-76.96050613344727', '1', '1', '2014-08-07 12:50:40', '-12.0463', '-76.9656', 1),
(9, 1, '-12.57373', '-76.3874', '2', '2', '2014-08-08 14:22:54', '-12.0463', '-76.9656', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `mv_sesioncond`
--

CREATE TABLE IF NOT EXISTS `mv_sesioncond` (
  `scond_idsesioncond` int(11) NOT NULL AUTO_INCREMENT,
  `cond_idconductor` int(11) NOT NULL,
  `scond_token` varchar(20) NOT NULL,
  `scond_feccrea` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`scond_idsesioncond`),
  UNIQUE KEY `cond_idconductor_UNIQUE` (`cond_idconductor`),
  KEY `fk_mv_sesioncond_tb_conductor1_idx` (`cond_idconductor`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=4 ;

--
-- Volcado de datos para la tabla `mv_sesioncond`
--

INSERT INTO `mv_sesioncond` (`scond_idsesioncond`, `cond_idconductor`, `scond_token`, `scond_feccrea`) VALUES
(3, 1, 'GXHCwa4OpbjZJnP729hl', '2014-08-07 17:22:59');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `mv_ulttaxi`
--

CREATE TABLE IF NOT EXISTS `mv_ulttaxi` (
  `utaxi_idulttaxi` int(11) NOT NULL AUTO_INCREMENT,
  `cond_idconductor` int(11) NOT NULL,
  `utaxi_lattaxi` varchar(45) DEFAULT NULL,
  `utaxi_lontaxi` varchar(45) DEFAULT NULL,
  `utaxi_estadocond` char(1) DEFAULT NULL COMMENT '0 = cond. inactivo / 1 = cond. activo / 2 = cond. en servicio',
  `utaxi_diahora` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `utaxi_estadosolicitud` char(1) DEFAULT '0' COMMENT '0=cond. libre / 1=recibio solicitud / 2=acepto solicitud / 3=tiempo agotado / 4=rechazo servicio / 5=inicio servicio / 6=servicio culminado',
  `utaxi_latcliente` varchar(45) DEFAULT NULL,
  `utaxi_loncliente` varchar(45) DEFAULT NULL,
  `utaxi_tiempollegada` varchar(45) DEFAULT NULL COMMENT 'tiempo de llegada del cond. al punto de encuentro (en minutos)',
  `utaxi_esreserva` tinyint(4) DEFAULT '0' COMMENT '1=si, 0=no',
  `dserv_iddetalleservicio` int(11) DEFAULT NULL,
  PRIMARY KEY (`utaxi_idulttaxi`),
  KEY `fk_mv_ulttaxi_tb_conductor1_idx` (`cond_idconductor`),
  KEY `fk_mv_ulttaxi_tb_detalleservicio1_idx` (`dserv_iddetalleservicio`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=4 ;

--
-- Volcado de datos para la tabla `mv_ulttaxi`
--

INSERT INTO `mv_ulttaxi` (`utaxi_idulttaxi`, `cond_idconductor`, `utaxi_lattaxi`, `utaxi_lontaxi`, `utaxi_estadocond`, `utaxi_diahora`, `utaxi_estadosolicitud`, `utaxi_latcliente`, `utaxi_loncliente`, `utaxi_tiempollegada`, `utaxi_esreserva`, `dserv_iddetalleservicio`) VALUES
(1, 1, '-12.57373', '-76.3874', '2', '2014-08-08 19:22:54', '2', '-12.0463', '-76.9656', '15', 0, 1),
(2, 2, '-12.046383289764293', '-76.96050613344727', '2', '2014-08-07 17:04:46', '2', NULL, NULL, NULL, 0, 1),
(3, 3, NULL, NULL, '0', '2014-08-06 22:55:58', '0', NULL, NULL, NULL, 0, NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tb_cliente`
--

CREATE TABLE IF NOT EXISTS `tb_cliente` (
  `cli_idcliente` int(11) NOT NULL AUTO_INCREMENT,
  `emp_idempresa` int(11) DEFAULT NULL,
  `cli_correo` varchar(45) DEFAULT NULL COMMENT 'para login en app',
  `cli_clave` varchar(45) DEFAULT NULL COMMENT 'para login en app',
  `cli_nombres` varchar(45) DEFAULT NULL,
  `cli_apellidos` varchar(45) DEFAULT NULL,
  `cli_dni` int(9) DEFAULT NULL,
  `cli_ncelular` int(9) DEFAULT NULL,
  `cli_ciudad` varchar(100) DEFAULT NULL,
  `cli_distrito` varchar(100) DEFAULT NULL,
  `cli_direccion` varchar(100) DEFAULT NULL,
  `cli_idfacebook` varchar(45) DEFAULT NULL COMMENT 'id de su cuenta de facebook',
  `cli_activo` tinyint(4) NOT NULL DEFAULT '1' COMMENT '1=activo, 0=inactivo',
  `cli_feccrea` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `cli_fecmodi` datetime DEFAULT NULL,
  PRIMARY KEY (`cli_idcliente`),
  UNIQUE KEY `usu_correo_UNIQUE` (`cli_correo`),
  KEY `fk_tb_usuario_tb_empresa1_idx` (`emp_idempresa`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=3 ;

--
-- Volcado de datos para la tabla `tb_cliente`
--

INSERT INTO `tb_cliente` (`cli_idcliente`, `emp_idempresa`, `cli_correo`, `cli_clave`, `cli_nombres`, `cli_apellidos`, `cli_dni`, `cli_ncelular`, `cli_ciudad`, `cli_distrito`, `cli_direccion`, `cli_idfacebook`, `cli_activo`, `cli_feccrea`, `cli_fecmodi`) VALUES
(1, NULL, 'c1@c1.com', '123', 'Jhonatan', 'Sandoval', 73123125, 986823055, 'Lima', 'San Juan de Lurigancho', 'Campoy Urb. Las Magnolias', NULL, 1, '2014-08-05 19:31:27', NULL),
(2, NULL, 'c2@c2.com', '123', 'Patricio', 'Parodi', 54962180, NULL, NULL, NULL, NULL, NULL, 1, '2014-08-05 19:31:27', NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tb_conductor`
--

CREATE TABLE IF NOT EXISTS `tb_conductor` (
  `cond_idconductor` int(11) NOT NULL AUTO_INCREMENT,
  `taxi_idtaxi` int(11) DEFAULT NULL,
  `cond_correo` varchar(45) NOT NULL COMMENT 'usado para login app',
  `cond_clave` varchar(45) NOT NULL COMMENT 'usado para login app',
  `cond_nombres` varchar(45) DEFAULT NULL,
  `cond_apellidos` varchar(45) DEFAULT NULL,
  `cond_dni` int(9) DEFAULT NULL,
  `cond_fecnaci` date DEFAULT NULL,
  `cond_ciudad` varchar(45) DEFAULT NULL,
  `cond_distrito` varchar(45) DEFAULT NULL,
  `cond_direccion` varchar(500) DEFAULT NULL,
  `cond_calificacion` decimal(10,3) DEFAULT NULL,
  `cond_foto` varchar(100) DEFAULT NULL,
  `cond_celular` int(10) DEFAULT NULL,
  `cond_fijo` int(8) DEFAULT NULL,
  `cond_nlicencia` varchar(15) DEFAULT NULL,
  `cond_fecrenovlicencia` datetime DEFAULT NULL,
  `cond_categlicencia` varchar(3) DEFAULT NULL,
  `cond_tipo` char(1) DEFAULT NULL COMMENT 'R = Remisse , E = Estacion',
  `cond_aireacond` tinyint(4) DEFAULT '0' COMMENT '1=si , 0=no',
  `cond_estado` tinyint(1) NOT NULL DEFAULT '1' COMMENT '1=habilitado, 0=inhabilitado',
  `cond_feccrea` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `cond_fecmodi` datetime DEFAULT NULL,
  PRIMARY KEY (`cond_idconductor`),
  UNIQUE KEY `cond_correo_UNIQUE` (`cond_correo`),
  KEY `fk_tb_conductor_tb_taxi1_idx` (`taxi_idtaxi`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=4 ;

--
-- Volcado de datos para la tabla `tb_conductor`
--

INSERT INTO `tb_conductor` (`cond_idconductor`, `taxi_idtaxi`, `cond_correo`, `cond_clave`, `cond_nombres`, `cond_apellidos`, `cond_dni`, `cond_fecnaci`, `cond_ciudad`, `cond_distrito`, `cond_direccion`, `cond_calificacion`, `cond_foto`, `cond_celular`, `cond_fijo`, `cond_nlicencia`, `cond_fecrenovlicencia`, `cond_categlicencia`, `cond_tipo`, `cond_aireacond`, `cond_estado`, `cond_feccrea`, `cond_fecmodi`) VALUES
(1, NULL, 'a@a.a', '123', 'Carlos', 'Garcia', 84529615, NULL, NULL, 'Lince', NULL, '4.500', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, '2014-08-08 21:24:45', NULL),
(2, NULL, 'b@b.b', '123', 'Jair', 'Gonzales', 21568423, NULL, NULL, 'San Juan de Lurigancho', NULL, '2.000', NULL, NULL, NULL, 'A54D52SD', NULL, NULL, NULL, NULL, 1, '2014-08-08 21:25:04', NULL),
(3, NULL, 'c@c.c', '123', 'Ruben', 'Rojas', 98657841, NULL, NULL, 'San Borja', NULL, '5.000', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, '2014-08-08 22:47:36', NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tb_detalleservicio`
--

CREATE TABLE IF NOT EXISTS `tb_detalleservicio` (
  `dserv_iddetalleservicio` int(11) NOT NULL AUTO_INCREMENT,
  `dserv_origen` mediumtext COMMENT 'origen de servicio',
  `dserv_latorigen` varchar(45) DEFAULT NULL,
  `dserv_lonorigen` varchar(45) DEFAULT NULL,
  `dserv_destino` mediumtext COMMENT 'destino de servicio',
  `dserv_latdestino` varchar(45) DEFAULT NULL,
  `dserv_londestino` varchar(45) DEFAULT NULL,
  `dserv_conaire` tinyint(4) NOT NULL DEFAULT '0' COMMENT '1=si, 0=no',
  `dserv_tipo` char(1) NOT NULL DEFAULT '0' COMMENT '0=remisse , 1=estacion',
  `dserv_docpago` char(1) NOT NULL DEFAULT '0' COMMENT '0=boleta, 1=factura',
  `dserv_costo` decimal(10,2) DEFAULT NULL COMMENT 'costo del servicio',
  `cli_idcliente` int(11) NOT NULL,
  `dserv_diahora` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`dserv_iddetalleservicio`),
  KEY `fk_tb_detalleservicio_tb_cliente1_idx` (`cli_idcliente`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=2 ;

--
-- Volcado de datos para la tabla `tb_detalleservicio`
--

INSERT INTO `tb_detalleservicio` (`dserv_iddetalleservicio`, `dserv_origen`, `dserv_latorigen`, `dserv_lonorigen`, `dserv_destino`, `dserv_latdestino`, `dserv_londestino`, `dserv_conaire`, `dserv_tipo`, `dserv_docpago`, `dserv_costo`, `cli_idcliente`, `dserv_diahora`) VALUES
(1, 'ATE VITARTE 4 - Av. San juan ,Zona industrial', '-12.052804669476895', '-76.9453999322754', 'LIMA 3 - Barrios Altos', '-12.047096783984802', '-77.01552360476074', 0, '0', '0', '25.00', 1, '2014-08-06 21:55:34');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tb_empresa`
--

CREATE TABLE IF NOT EXISTS `tb_empresa` (
  `emp_idempresa` int(11) NOT NULL AUTO_INCREMENT,
  `emp_codigo` varchar(10) NOT NULL,
  `emp_nombre` varchar(100) NOT NULL,
  `emp_ruc` varchar(20) DEFAULT NULL,
  `emp_telefono` int(9) DEFAULT NULL,
  `emp_correo` varchar(100) DEFAULT NULL,
  `emp_estado` tinyint(4) NOT NULL DEFAULT '1' COMMENT '1=activo, 0=inactivo',
  `emp_contacto` varchar(100) DEFAULT NULL,
  `emp_usucrea` int(11) NOT NULL COMMENT 'id del usuario que creó el lugar (tabla tb_usuarioacceso)',
  `emp_feccrea` timestamp NULL DEFAULT NULL,
  `emp_fecmodi` datetime DEFAULT NULL,
  PRIMARY KEY (`emp_idempresa`),
  KEY `fk_tb_empresa_tb_usuarioacceso1_idx` (`emp_usucrea`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tb_factortarifario`
--

CREATE TABLE IF NOT EXISTS `tb_factortarifario` (
  `ftar_idfactortarifario` int(11) NOT NULL AUTO_INCREMENT,
  `ftar_valor1` decimal(10,2) DEFAULT NULL,
  `ftar_valor2` decimal(10,2) DEFAULT NULL,
  `ftar_operacion` char(1) DEFAULT NULL COMMENT 'S=Suma, M=Multiplicacion',
  `ftar_fecmodi` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`ftar_idfactortarifario`) COMMENT 'tabla usada para operaciones de las tarifas'
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tb_lugares`
--

CREATE TABLE IF NOT EXISTS `tb_lugares` (
  `lug_idlugar` int(11) NOT NULL AUTO_INCREMENT,
  `lug_descripcion` varchar(200) DEFAULT NULL COMMENT 'description del lugar',
  `lug_mod` int(5) DEFAULT NULL COMMENT 'nro. modificaciones del registro',
  `lug_estado` tinyint(4) NOT NULL DEFAULT '1' COMMENT '1=activo, 0=inactivo',
  `lug_feccrea` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`lug_idlugar`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=179 ;

--
-- Volcado de datos para la tabla `tb_lugares`
--

INSERT INTO `tb_lugares` (`lug_idlugar`, `lug_descripcion`, `lug_mod`, `lug_estado`, `lug_feccrea`) VALUES
(1, 'molina 1- camacho', 3, 0, '2014-04-18 08:45:35'),
(2, 'LA MOLINA1 - Camacho, Sta Patricia,Igenieros', 2, 0, '2014-04-18 08:45:31'),
(3, 'ATE VITARTE 1 - Salamanca', 7, 0, '2014-04-25 23:43:46'),
(4, 'ATE VITARTE 2 - Vulcano, mayorasgo', 8, 0, '2014-04-25 23:43:50'),
(5, 'ATE VITARTE 3 - Portales , Los angeles , Ceres ,Municipalidad de Vitarte , Cementerio', 9, 0, '2014-04-25 23:43:54'),
(6, 'ATE VITARTE 4 - Av. San juan ,Zona industrial', 10, 0, '2014-04-25 23:43:59'),
(7, 'ATE VITARTE 5 - Santa Clara', 11, 0, '2014-04-25 23:44:03'),
(8, 'ATE VITARTE 6 - H uaycan', 12, 0, '2014-04-25 23:44:07'),
(9, 'CALLAO 1 - Centro , Bellavista ,Aeropuerto , Perla', 17, 0, '2014-04-25 23:44:37'),
(10, 'CALLAO 2 - Carmen de la Legua, Reynoso', 13, 0, '2014-04-25 23:44:12'),
(11, 'CALLAO 3 - La punta', 14, 0, '2014-04-25 23:44:18'),
(12, 'CALLAO 4 - Zona industrial, Gambeta ,Sta Rosa , Grupo 8', 18, 0, '2014-04-25 23:44:42'),
(13, 'LIMA 1 - Centro de Lima', 19, 0, '2014-04-25 23:44:47'),
(14, 'LIMA 2  - Sta Beatriz', 20, 0, '2014-04-25 23:44:50'),
(15, 'LIMA 3 - Barrios Altos', 16, 0, '2014-04-25 23:44:29'),
(16, 'LIMA 4 - Sector Industrial , Urb Pando 3 etapa ,Cipreses', 15, 0, '2014-04-25 23:44:24'),
(17, 'ATE 1: Circunvalacion, Via Evita, C Central', 31, 1, '2014-04-27 07:47:58'),
(18, 'ATE 2 : Evitamiento, C Central, Ingenieros', 32, 1, '2014-04-27 07:48:32'),
(19, 'ATE 3 : Ingeniero, C Central, Puruchuco, J Prado', 33, 1, '2014-04-27 07:49:16'),
(20, 'ATE 4 :Puruchuco, Ceres, S Vitarte, Portales', 35, 1, '2014-04-27 07:50:51'),
(21, 'ATE 5 : Municipalidad, Manylsa, Sta Clara', 36, 1, '2014-04-27 07:54:58'),
(22, 'BARRANCO : BARRANCO', 0, 1, '2014-04-26 00:37:21'),
(23, 'BREÃ‘A : BREÃ‘A', 0, 1, '2014-04-26 00:37:39'),
(24, 'CALLAO 1 : LA PERLA', 0, 1, '2014-04-26 00:38:04'),
(25, 'CALLAO 2 : LA PUNTA', 0, 1, '2014-04-26 00:39:03'),
(26, 'CALLAO 3 : BELLAVISTA', 0, 1, '2014-04-26 00:39:17'),
(27, 'CALLAO 4 : SAN JOAQUIN', 0, 1, '2014-04-26 00:39:47'),
(28, 'CALLAO 5 : CERCADO', 0, 1, '2014-04-26 00:42:59'),
(29, 'CALLAO 6 : INDUSTRIAL I', 0, 1, '2014-04-26 00:43:58'),
(30, 'CALLAO 7 : INDUSTRIAL II', 0, 1, '2014-04-26 00:44:15'),
(31, 'CALLAO 8 :  CARMEN DE LA LEGUA', 0, 1, '2014-04-26 00:46:34'),
(32, 'CALLAO 9 : MARQUEZ', 0, 1, '2014-04-26 00:47:19'),
(33, 'CHORRILLOS 1 : MATELINI', 23, 1, '2014-04-27 06:11:15'),
(34, 'CHORRILLOS 2 : LOS CEDROS', 0, 1, '2014-04-26 00:49:31'),
(35, 'CHORRILLOS 3 : LA CAMPIÃ‘A', 0, 1, '2014-04-26 00:50:04'),
(36, 'CHORRILLOS 4 : ENCANTADA', 0, 1, '2014-04-26 00:50:31'),
(37, 'CHORRILLOS 5 : DELICIAS', 0, 1, '2014-04-26 00:50:47'),
(38, 'COMAS 1 : EL CARMEN', 0, 1, '2014-04-26 00:51:21'),
(39, 'COMAS 2 : RETABLO', 0, 1, '2014-04-26 00:51:35'),
(40, 'COMAS 3 : SAN FELIPE', 0, 1, '2014-04-26 00:51:55'),
(41, 'COMAS 4 :  COLLIQUE', 24, 1, '2014-04-27 06:11:40'),
(42, 'CARABAYLLO 1 :: Tugasuca, Trapiche', 38, 1, '2014-04-27 08:07:38'),
(43, 'EL AGUSTINO 1  :  STA ROSA', 27, 1, '2014-04-27 06:15:29'),
(44, 'INDEPENDENCIA  1: ErmitaÃ±o, Tahuantinsuyo', 39, 1, '2014-04-27 08:10:22'),
(45, 'INDEPENDENCIA 2 : MEGAPLAZA', 0, 1, '2014-04-26 00:55:47'),
(46, 'JESUS MARIA  1 :  SAN FELIPE', 0, 1, '2014-04-26 00:56:53'),
(47, 'JESUS MARIA 2 : CAMPO MARTE', 29, 1, '2014-04-27 06:46:35'),
(48, 'LA MOLINA 1 : CAMACHO', 0, 1, '2014-04-26 00:57:47'),
(49, 'LA MOLINA 2 : STA. PATRICIA', 0, 1, '2014-04-26 00:58:12'),
(50, 'LA MOLINA 3 : EL REMANSO', 0, 1, '2014-04-26 00:58:36'),
(51, 'LA MOLINA 4: LA CAPILLA', 0, 1, '2014-04-26 01:01:39'),
(52, 'LA MOLINA 5 : RINCONADA', 0, 1, '2014-04-26 01:04:11'),
(53, 'LA MOLINA 6 : LA PLANICIE', 0, 1, '2014-04-26 01:04:26'),
(54, 'LA MOLINA 7 : SOL DE LA MOLINA', 0, 1, '2014-04-26 01:05:20'),
(55, 'ATE 6 : Huaycan', 59, 1, '2014-05-01 03:46:37'),
(56, 'EL AGUSTINO 2 : RIVA AGUERO', 0, 1, '2014-04-27 06:15:10'),
(57, 'LA VICTORIA 1 : MATUTE', 0, 1, '2014-04-27 06:56:28'),
(58, 'LA VICTORIA 2 : STA CATALINA', 0, 1, '2014-04-27 06:56:43'),
(59, 'LIMA 1 : Cercado, sta Beatriz', 40, 1, '2014-04-27 08:11:52'),
(60, 'LIMA 2 : Industrial, Cipreces', 41, 1, '2014-04-27 08:12:13'),
(61, 'AEROPUERTO', 0, 1, '2014-04-27 07:58:38'),
(62, 'ANCON', 0, 1, '2014-04-27 07:58:52'),
(63, 'CARABAYLLO 2 : C. Canta', 0, 1, '2014-04-27 08:08:15'),
(64, 'LINCE', 0, 1, '2014-04-27 08:12:50'),
(65, 'LOS OLIVOS 1:  Trebol, Palmeras', 0, 1, '2014-04-27 08:14:13'),
(66, 'LOS OLIVOS 2 : Villa Sol, pro', 0, 1, '2014-04-27 08:16:25'),
(67, 'LURIGANCHO 1 : Campoy', 0, 1, '2014-04-27 08:18:20'),
(68, 'LURIGANCHO 2 : Huachipa', 0, 1, '2014-04-27 08:18:38'),
(69, 'LURIN 1: Pueblo', 61, 1, '2014-06-25 08:02:37'),
(70, 'LURIN 2 : Industrial', 62, 1, '2014-06-25 08:03:15'),
(71, 'MAGDALENA: Centro', 63, 1, '2014-06-25 08:03:48'),
(72, 'MIRAFLORES 1 : Aurora', 0, 1, '2014-04-27 08:20:13'),
(73, 'MIRAFLORES 2 : Huaca Pucllana', 0, 1, '2014-04-27 08:20:31'),
(74, 'MIRAFLORES 3 : Sta Cruz', 0, 1, '2014-04-27 08:20:43'),
(75, 'MIRAFLORES 4 : Reducto', 0, 1, '2014-04-27 08:20:59'),
(76, 'PUCUSANA', 0, 1, '2014-04-27 08:21:28'),
(77, 'PUEBLO LIBRE', 0, 1, '2014-04-27 08:21:49'),
(78, 'PUENTE PIEDRA 1: CENTRO', 0, 1, '2014-04-27 08:22:45'),
(79, 'PUENTE PIEDRA 2 : ZAPALLAL', 0, 1, '2014-04-27 08:22:57'),
(80, 'PUNTA HERMOSA', 0, 1, '2014-04-27 08:23:26'),
(81, 'PUNTA NEGRA', 0, 1, '2014-04-27 08:23:36'),
(82, 'RIMAC 1 : Pizarro, Alcazar', 42, 1, '2014-04-27 08:24:41'),
(83, 'RIMAC 2 : La Florida, Amancaes', 0, 1, '2014-04-27 08:25:22'),
(84, 'S. J. LURIGANCHO 1 : Zarate', 50, 1, '2014-04-27 09:49:55'),
(85, 'S. J. LURIGANCHO 2 : Mangomarca', 0, 1, '2014-04-27 08:34:38'),
(86, 'S. J. LURIGANCHO 3 : Las Flores', 0, 1, '2014-04-27 08:35:00'),
(87, 'S. J. LURIGANCHO 4 : Cto Grande', 0, 1, '2014-04-27 08:35:22'),
(88, 'S. J. LURIGANCHO 5 : Bayovar/Caceres', 51, 1, '2014-04-27 09:50:24'),
(89, 'S. J. LURIGANCHO 6 : Jicamarca', 0, 1, '2014-04-27 08:36:27'),
(90, 'S. J. MIRAFLORES 1 : Pan Sur', 49, 1, '2014-04-27 09:49:32'),
(91, 'S. J. MIRAFLORES 2 : Pamplona', 0, 1, '2014-04-27 08:37:33'),
(92, 'S. J. MIRAFLORES 3 : CT', 0, 1, '2014-04-27 08:37:48'),
(93, 'SAN BARTOLO', 0, 1, '2014-04-27 08:38:30'),
(94, 'SAN BORJA 1 : G civil', 43, 1, '2014-04-27 08:40:25'),
(95, 'SAN BORJA 2 : SB norte SB Sur', 44, 1, '2014-04-27 08:40:55'),
(96, 'SAN BORJA 3 : Pentagonito', 0, 1, '2014-04-27 08:39:31'),
(97, 'SAN BORJA 4 : Limatambo', 0, 1, '2014-04-27 08:41:53'),
(98, 'SAN ISIDRO 1 :Corpac', 0, 1, '2014-04-27 08:42:19'),
(99, 'SAN ISIDRO 2 :Juan de Arona', 0, 1, '2014-04-27 08:42:44'),
(100, 'SAN ISIDRO 3: Basadre', 0, 1, '2014-04-27 09:07:13'),
(101, 'SAN ISIDRO 4 : Orrantia', 0, 1, '2014-04-27 09:07:38'),
(102, 'SAN ISIDRO 5 : Golf Club', 0, 1, '2014-04-27 09:07:56'),
(103, 'SAN LUIS 1: La Videna', 45, 1, '2014-04-27 09:14:19'),
(104, 'SAN LUIS 2 : San Juan De Dios', 0, 1, '2014-04-27 09:16:55'),
(105, 'SAN MARTIN 1 : Zarumilla, Habich', 0, 1, '2014-04-27 09:18:47'),
(106, 'SAN MARTIN 2 : Fiori, San German', 0, 1, '2014-04-27 09:19:21'),
(107, 'SAN MARTIN 3 : Condevilla', 0, 1, '2014-04-27 09:20:01'),
(108, 'SAN MARTIN 4 : Fundo Odria', 46, 1, '2014-04-27 09:22:50'),
(109, 'SAN MARTIN 5 : San Diego', 0, 1, '2014-04-27 09:20:39'),
(110, 'SAN MIGUEL 1 : Pando', 0, 1, '2014-04-27 09:21:21'),
(111, 'SAN MIGUEL 2 : Maranga', 0, 1, '2014-04-27 09:21:37'),
(112, 'SAN MIGUEL 3 : Leyendas', 47, 1, '2014-04-27 09:23:15'),
(113, 'SANTA ANITA 1 : Ovalo', 0, 1, '2014-04-27 09:23:53'),
(114, 'SANTA ANITA 2 : Mercado productores', 0, 1, '2014-04-27 09:24:15'),
(115, 'STGO DE SURCO 1 :  Golf Inkas', 56, 1, '2014-04-27 09:53:11'),
(116, 'STGO DE SURCO 2 : Alamos', 0, 1, '2014-04-27 09:39:15'),
(117, 'STGO DE SURCO 3 : Valle Hermozo', 55, 1, '2014-04-27 09:52:59'),
(118, 'STGO DE SURCO 4 : Casuarinas', 54, 1, '2014-04-27 09:52:44'),
(119, 'STGO DE SURCO 5 : Chacarilla', 0, 1, '2014-04-27 09:40:41'),
(120, 'STGO DE SURCO 6 : Higuereta', 0, 1, '2014-04-27 09:41:01'),
(121, 'STGO DE SURCO 7 : Castellana', 0, 1, '2014-04-27 09:41:13'),
(122, 'STGO DE SURCO 8 : Chama', 53, 1, '2014-04-27 09:52:36'),
(123, 'STGO DE SURCO 9 : San Roque', 0, 1, '2014-04-27 09:41:56'),
(124, 'STGO DE SURCO   10 : Sagitario', 58, 1, '2014-04-27 09:53:56'),
(125, 'STGO DE SURCO  11: Las Palmas', 57, 1, '2014-04-27 09:53:38'),
(126, 'SURQUILLO 1: La Calera', 0, 1, '2014-04-27 09:43:33'),
(127, 'SURQUILLO 2 : Aramburu', 0, 1, '2014-04-27 09:43:52'),
(128, 'VENTANILLA 1 : Gambeta', 0, 1, '2014-04-27 09:44:32'),
(129, 'VENTANILLA 2 : Municipalidad', 0, 1, '2014-04-27 09:44:57'),
(130, 'VILLA EL SALVADOR 1 : Sector 1', 0, 1, '2014-04-27 09:45:48'),
(131, 'VILLA EL SALVADOR 2 : Sector 2, 3', 0, 1, '2014-04-27 09:46:09'),
(132, 'VILLA EL SALVADOR 3 : Sector 4', 0, 1, '2014-04-27 09:46:35'),
(133, 'VILLA EL SALVADOR 4 : Sector 5, 6', 0, 1, '2014-04-27 09:46:54'),
(134, 'VILLA MARIA DEL TRIUNFO 1 : San Gabriel', 0, 1, '2014-04-27 09:47:29'),
(135, 'VILLA MARIA DEL TRIUNFO 2 : Pesquero', 0, 1, '2014-04-27 09:47:45'),
(136, 'VILLA MARIA DEL TRIUNFO 3 : Tablada', 0, 1, '2014-04-27 09:48:06'),
(137, 'VILLA MARIA DEL TRIUNFO 4 : Jose Galvez', 0, 1, '2014-04-27 09:48:30'),
(138, 'CIENEGUILLA Comisaria, Pte Rio', 60, 1, '2014-05-01 03:53:28'),
(139, 'CHACLACAYO', 68, 1, '2014-07-02 18:40:59'),
(140, 'CHOSICA', 0, 1, '2014-05-02 00:53:34'),
(141, 'PIURA Centro', 65, 1, '2014-06-25 08:07:39'),
(142, 'PIURA Catacaos', 64, 1, '2014-06-25 08:04:14'),
(143, 'CUZCO Centro', 0, 1, '2014-06-25 08:08:37'),
(144, 'CUZCO Periferie', 0, 1, '2014-06-25 08:09:01'),
(145, 'Appslovers', 66, 0, '2014-06-26 21:44:02'),
(146, 'HUANCAYO Centro', 67, 1, '2014-06-29 20:00:47'),
(147, 'HUANCAYO chilca', 0, 1, '2014-06-29 19:59:48'),
(148, 'HUANCAYO El tambo', 0, 1, '2014-06-29 20:00:27'),
(149, 'PIURA - PLAZA DE ARMAS', 0, 1, '2014-07-02 05:35:34'),
(150, 'PIURA - Castilla - Miraflores', 0, 1, '2014-07-02 05:36:39'),
(151, 'PIURA - CASTILLA - Castilla (pasando colegio Miguel Grau hasta sta. rosa)', 0, 1, '2014-07-02 05:37:36'),
(152, 'PIURA - CASTILLA - El Indio', 0, 1, '2014-07-02 05:38:01'),
(153, 'PIURA - CASTILLA - Talarita', 0, 1, '2014-07-02 05:38:51'),
(154, 'PIURA - CATACAOS DE DIA', 0, 1, '2014-07-02 05:40:37'),
(155, 'PIURA - CATACAOS DE NOCHE', 0, 1, '2014-07-02 05:40:54'),
(156, 'PIURA - CENTRO 1: desde av. Sanchez cerro, Av. Wulman, Av. Bolognesi', 0, 1, '2014-07-02 05:41:45'),
(157, 'PIURA - DETRAS ESTADIO 1: Hasta colegio Militar Pedro Ruiz Gallo', 0, 1, '2014-07-02 05:42:26'),
(158, 'PIURA - DETRAS ESTADIO 2: Desde colegio Militar hasta los Medanos', 0, 1, '2014-07-02 05:43:41'),
(159, 'PIURA - LA LEGUA', 0, 1, '2014-07-02 05:43:59'),
(160, 'PIURA - CENTRO 2: Pachitea, Angamos, Santa Isabel, Mercado central', 0, 1, '2014-07-02 05:44:48'),
(161, 'PIURA - CENTRO 3: Urb. Sta. Ana, San Jose, California, San Carlos', 0, 1, '2014-07-02 05:45:34'),
(162, 'PIURA - CENTRO 4: Los Titanes, Jose C. Mariategui, Miguel Grau', 0, 1, '2014-07-02 05:46:30'),
(163, 'PIURA - Desde Av. CircunvalaciÃ³n  hacia Av. Gullman, hacia los Polvorines, Consuelo de Velasco', 0, 1, '2014-07-02 05:47:26'),
(164, 'PIURA - Fatima, Tupac Amaru , 11 de Abril', 0, 1, '2014-07-02 05:48:05'),
(165, 'PIURA - 26 DE OCTUBRE 1: AA.HH.Nueva Esperanza, Villa Peru CANADA', 0, 1, '2014-07-02 05:50:17'),
(166, 'PIURA - 26 DE OCTUBRE 2: Av. Cesar Vallejo, Sta. Roisa, Los Tallanes, La Alborada, Las Mercedes', 0, 1, '2014-07-02 05:51:44'),
(167, 'PIURA - 26 DE OCTUBRE 3: AA.HH. Las Capullanas, San Martin, Av. Chulucanas', 0, 1, '2014-07-02 05:52:55'),
(168, 'PIURA - 26 DE OCTUBRE 4: ENACE, Micaela Bastidas, San Sebastian, Luis Maceda', 0, 1, '2014-07-02 05:53:51'),
(169, 'PIURA - Zona industrial, senathi  club de tiro, bello horizonte, los bancarios.', 0, 1, '2014-07-02 05:55:55'),
(170, 'PIURA - Ignacio Merino, Los Algarrobos, AVIFAP, Los Jardines', 0, 1, '2014-07-02 05:56:43'),
(171, 'PIURA - UCV, Mercado nuevo, pesquero, salida a Sullana', 0, 1, '2014-07-02 05:57:28'),
(172, 'PIURA - Urb. El Chipe, El Golf, Los cocos del Chipe, San Eduardo, UPAO, los Cedros, Los Almendros.', 0, 1, '2014-07-02 05:58:39'),
(173, 'PIURA - Los Ejidos 1: Hasta caballos de paso', 0, 1, '2014-07-02 05:59:05'),
(174, 'PIURA - LOS EJIDOS 2: despues de caballos de paso, al fondo', 0, 1, '2014-07-02 05:59:33'),
(175, 'CHINCHA Centro', 0, 1, '2014-07-02 18:37:33'),
(176, 'CHINCHA Sunampe', 0, 1, '2014-07-02 18:37:55'),
(177, 'CHINCHA Grosio Prado', 0, 1, '2014-07-02 18:38:39'),
(178, 'CHINCHA Tambo Mora', 0, 1, '2014-07-02 18:39:53');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tb_reserva`
--

CREATE TABLE IF NOT EXISTS `tb_reserva` (
  `res_idreserva` int(11) NOT NULL AUTO_INCREMENT,
  `cli_idcliente` int(11) NOT NULL COMMENT 'fk tb_cliente',
  `res_origen` int(11) DEFAULT NULL,
  `cond_idconductor` int(11) NOT NULL,
  `res_reforigen` mediumtext COMMENT 'referencia del lugar de origen',
  `res_latorigen` varchar(45) DEFAULT NULL,
  `res_lonorigen` varchar(45) DEFAULT NULL,
  `res_destino` int(11) DEFAULT NULL,
  `res_diahorainicio` datetime DEFAULT NULL,
  `res_diahorafin` datetime DEFAULT NULL,
  `res_monto` decimal(10,2) DEFAULT NULL,
  `res_conaire` tinyint(4) NOT NULL DEFAULT '0' COMMENT '1=si, 0=no',
  `res_docpago` char(1) NOT NULL DEFAULT '0' COMMENT '0=boleta, 1=factura',
  `res_tipo` char(1) NOT NULL DEFAULT '0' COMMENT '0=remisse, 1=estacion',
  `res_tienecond` char(1) DEFAULT NULL COMMENT '0=no, 1=si',
  `res_estado` char(1) DEFAULT NULL COMMENT '0=culminada, 1=activa, 2=cancelada',
  `res_feccrea` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`res_idreserva`,`cond_idconductor`),
  KEY `fk_tb_reserva_tb_cliente1_idx` (`cli_idcliente`),
  KEY `fk_tb_reserva_tb_lugares1_idx` (`res_origen`),
  KEY `fk_tb_reserva_tb_conductor1_idx` (`cond_idconductor`),
  KEY `fk_tb_reserva_tb_lugares2_idx` (`res_destino`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tb_tarifario`
--

CREATE TABLE IF NOT EXISTS `tb_tarifario` (
  `tar_idtarifario` int(11) NOT NULL AUTO_INCREMENT,
  `tar_origen` int(11) DEFAULT NULL,
  `tar_destino` int(11) DEFAULT NULL,
  `tar_monto` decimal(10,2) DEFAULT NULL,
  `tar_estado` tinyint(4) NOT NULL DEFAULT '1' COMMENT '1=activo, 0=inactivo',
  `tar_mod` int(5) DEFAULT NULL COMMENT 'nro. modificaciones del registro',
  `tar_feccrea` timestamp NULL DEFAULT NULL,
  `tar_fecmodi` datetime DEFAULT NULL,
  PRIMARY KEY (`tar_idtarifario`) COMMENT 'tarifa según los lugares',
  KEY `fk_tb_tarifario_tb_lugares1_idx` (`tar_origen`),
  KEY `fk_tb_tarifario_tb_lugares2_idx` (`tar_destino`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tb_taxi`
--

CREATE TABLE IF NOT EXISTS `tb_taxi` (
  `taxi_idtaxi` int(11) NOT NULL AUTO_INCREMENT,
  `taxi_alias` varchar(45) DEFAULT NULL COMMENT 'alias para revisión rapida',
  `taxi_nplaca` varchar(45) DEFAULT NULL,
  `taxi_categclase` varchar(45) DEFAULT NULL,
  `taxi_marca` varchar(100) DEFAULT NULL,
  `taxi_modelo` varchar(100) DEFAULT NULL,
  `taxi_seriechasis` varchar(100) DEFAULT NULL,
  `taxi_motor` varchar(100) DEFAULT NULL,
  `taxi_color` varchar(45) DEFAULT NULL,
  `taxi_carroceria` varchar(45) DEFAULT NULL,
  `taxi_aniofab` int(4) DEFAULT NULL COMMENT 'año de fabricación',
  `taxi_certoperaciones` varchar(15) DEFAULT NULL,
  `taxi_fecrevtecnica` datetime DEFAULT NULL,
  `taxi_fecsoat` datetime DEFAULT NULL,
  `taxi_logo` tinyint(4) DEFAULT '0' COMMENT '1=con logo, 0=sin logo',
  `taxi_activo` tinyint(4) NOT NULL DEFAULT '1' COMMENT '1=si, 0=no',
  `taxi_feccrea` timestamp NULL DEFAULT NULL,
  `taxi_fecmodi` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`taxi_idtaxi`),
  UNIQUE KEY `taxi_nplaca_UNIQUE` (`taxi_nplaca`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tb_tiempoalerta`
--

CREATE TABLE IF NOT EXISTS `tb_tiempoalerta` (
  `tale_idtiempoalerta` int(11) NOT NULL AUTO_INCREMENT,
  `tale_demon` int(11) DEFAULT NULL COMMENT 'intervalo de tiempo para alertas',
  `tale_tiempo` int(11) DEFAULT NULL COMMENT 'intervalo tiempo ingresado por panel de control',
  `tale_descripcion` char(1) DEFAULT NULL COMMENT 'H=Horas, M=Minutos',
  `tale_diahora` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`tale_idtiempoalerta`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=3 ;

--
-- Volcado de datos para la tabla `tb_tiempoalerta`
--

INSERT INTO `tb_tiempoalerta` (`tale_idtiempoalerta`, `tale_demon`, `tale_tiempo`, `tale_descripcion`, `tale_diahora`) VALUES
(1, 3600, 1, 'H', '2014-08-05 16:20:10'),
(2, 1800, 30, 'M', '2014-08-05 16:20:10');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tb_tipousuario`
--

CREATE TABLE IF NOT EXISTS `tb_tipousuario` (
  `idtipousuario` int(11) NOT NULL AUTO_INCREMENT,
  `tipousuario` varchar(45) DEFAULT NULL COMMENT 'A=Administrador, S=Soporte',
  PRIMARY KEY (`idtipousuario`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=3 ;

--
-- Volcado de datos para la tabla `tb_tipousuario`
--

INSERT INTO `tb_tipousuario` (`idtipousuario`, `tipousuario`) VALUES
(1, 'A'),
(2, 'S');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tb_usuarioacceso`
--

CREATE TABLE IF NOT EXISTS `tb_usuarioacceso` (
  `idusuarioacceso` int(11) NOT NULL AUTO_INCREMENT,
  `idtipousuario` int(11) DEFAULT NULL COMMENT 'fk tabla tb_tipousuario',
  `idusuario` varchar(45) NOT NULL COMMENT 'para login',
  `clave` varchar(45) NOT NULL COMMENT 'para login',
  `nombres` varchar(45) DEFAULT NULL,
  `apellidos` varchar(45) DEFAULT NULL,
  `correo` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`idusuarioacceso`) COMMENT 'tabla de usuarios que acceden al panel de control',
  KEY `fk_tb_usuarioacceso_tb_tipousuario_idx` (`idtipousuario`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=3 ;

--
-- Volcado de datos para la tabla `tb_usuarioacceso`
--

INSERT INTO `tb_usuarioacceso` (`idusuarioacceso`, `idtipousuario`, `idusuario`, `clave`, `nombres`, `apellidos`, `correo`) VALUES
(1, 1, 'admin', '123', 'Admin', 'General', 'admin@localhost'),
(2, 2, 'soporte', '123', 'Soporte', 'Appslovers', 'soporte@appslovers.com');

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `mv_calificacion`
--
ALTER TABLE `mv_calificacion`
  ADD CONSTRAINT `fk_mv_calificacion_tb_conductor1` FOREIGN KEY (`cond_idconductor`) REFERENCES `tb_conductor` (`cond_idconductor`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `mv_movimientos`
--
ALTER TABLE `mv_movimientos`
  ADD CONSTRAINT `fk_mv_movimientos_tb_conductor1` FOREIGN KEY (`cond_idconductor`) REFERENCES `tb_conductor` (`cond_idconductor`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_mv_movimientos_tb_detalleservicio1` FOREIGN KEY (`dserv_iddetalleservicio`) REFERENCES `tb_detalleservicio` (`dserv_iddetalleservicio`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `mv_sesioncond`
--
ALTER TABLE `mv_sesioncond`
  ADD CONSTRAINT `fk_mv_sesioncond_tb_conductor1` FOREIGN KEY (`cond_idconductor`) REFERENCES `tb_conductor` (`cond_idconductor`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `mv_ulttaxi`
--
ALTER TABLE `mv_ulttaxi`
  ADD CONSTRAINT `fk_mv_ulttaxi_tb_conductor1` FOREIGN KEY (`cond_idconductor`) REFERENCES `tb_conductor` (`cond_idconductor`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_mv_ulttaxi_tb_detalleservicio1` FOREIGN KEY (`dserv_iddetalleservicio`) REFERENCES `tb_detalleservicio` (`dserv_iddetalleservicio`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `tb_cliente`
--
ALTER TABLE `tb_cliente`
  ADD CONSTRAINT `fk_tb_usuario_tb_empresa1` FOREIGN KEY (`emp_idempresa`) REFERENCES `tb_empresa` (`emp_idempresa`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `tb_conductor`
--
ALTER TABLE `tb_conductor`
  ADD CONSTRAINT `fk_tb_conductor_tb_taxi1` FOREIGN KEY (`taxi_idtaxi`) REFERENCES `tb_taxi` (`taxi_idtaxi`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `tb_detalleservicio`
--
ALTER TABLE `tb_detalleservicio`
  ADD CONSTRAINT `fk_tb_detalleservicio_tb_cliente1` FOREIGN KEY (`cli_idcliente`) REFERENCES `tb_cliente` (`cli_idcliente`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `tb_empresa`
--
ALTER TABLE `tb_empresa`
  ADD CONSTRAINT `fk_tb_empresa_tb_usuarioacceso1` FOREIGN KEY (`emp_usucrea`) REFERENCES `tb_usuarioacceso` (`idusuarioacceso`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `tb_reserva`
--
ALTER TABLE `tb_reserva`
  ADD CONSTRAINT `fk_tb_reserva_tb_cliente1` FOREIGN KEY (`cli_idcliente`) REFERENCES `tb_cliente` (`cli_idcliente`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_tb_reserva_tb_conductor1` FOREIGN KEY (`cond_idconductor`) REFERENCES `tb_conductor` (`cond_idconductor`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_tb_reserva_tb_lugares1` FOREIGN KEY (`res_origen`) REFERENCES `tb_lugares` (`lug_idlugar`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_tb_reserva_tb_lugares2` FOREIGN KEY (`res_destino`) REFERENCES `tb_lugares` (`lug_idlugar`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `tb_tarifario`
--
ALTER TABLE `tb_tarifario`
  ADD CONSTRAINT `fk_tb_tarifario_tb_lugares1` FOREIGN KEY (`tar_origen`) REFERENCES `tb_lugares` (`lug_idlugar`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_tb_tarifario_tb_lugares2` FOREIGN KEY (`tar_destino`) REFERENCES `tb_lugares` (`lug_idlugar`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `tb_usuarioacceso`
--
ALTER TABLE `tb_usuarioacceso`
  ADD CONSTRAINT `fk_tb_usuarioacceso_tb_tipousuario` FOREIGN KEY (`idtipousuario`) REFERENCES `tb_tipousuario` (`idtipousuario`) ON DELETE NO ACTION ON UPDATE NO ACTION;

DELIMITER $$
--
-- Eventos
--
CREATE DEFINER=`root`@`localhost` EVENT `sadafd` ON SCHEDULE EVERY 10 SECOND STARTS '2014-08-06 12:33:48' ON COMPLETION PRESERVE ENABLE DO CALL cond_DesconectarCond()$$

DELIMITER ;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
