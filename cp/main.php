<?php

    session_start();

    $usuarioLogueado = utf8_encode($_SESSION['nombres'].' '.$_SESSION['apellidos']);

    if (isset($_REQUEST['opc'])) {
        $opc = $_REQUEST['opc'];
    } else {
        $opc = 1;
    }
?>

<!DOCTYPE HTML>
<html>
    <head>
    	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <title>.:: TAXI SVICO | Panel de Control ::.</title>
        <link rel="stylesheet" href="../vendor/bootstrap-3.2.0-dist/css/bootstrap.min.css"/>
        <link rel="stylesheet" href="../css/main.css"/>
        <link href='http://fonts.googleapis.com/css?family=Oswald:400,700' rel='stylesheet' type='text/css'>
        <link rel="shortcut icon" href="../img/logo.ico" />
    </head>
    <body>

        <div id="mainContainer">

            <header>
                <table align="center" width="100%">
                    <tr>
                        <td class="text-center" width="33%"><img src="../img/logo.png" width="200px" /></td>
                        <td class="text-center header-titulo" width="33%" align="center" valign="middle">PANEL DE CONTROL</td>
                        <td class="text-center opcHeader" width="33%" align="right">
                            Bienvenid@ <b><?php echo $usuarioLogueado;?></b> <br>
                            <a href="../cp/logout.php">
                                [ Cerrar sesión ]
                            </a>                        
                        </td>
                    </tr>
                </table>
            </header>
            
            <div class="menu">
                <div class="navbar navbar-default">
                    <div class="container">
                        <div class="collapse navbar-collapse">
                            <ul class="nav navbar-nav">
                                <li class="dropdown">
                                    <a href="javascript:void(0)" class="dropdown-toggle" data-toggle="dropdown">Unidades</a>
                                    <ul class="dropdown-menu">
                                        <li>
                                            <a href="javascript:void(0)">Conductores</a>
                                        </li>
                                        <li>
                                            <a href="javascript:void(0)">Taxis</a>
                                        </li>
                                    </ul>
                                </li>
                                <li class="dropdown">
                                    <a href="javascript:void(0)" class="dropdown-toggle" data-toggle="dropdown">Clientes</a>
                                </li>
                            </ul>
                        </div>
                    </div>
                </div>
            </div>
            
            
            <div class="contenido">
            
                <div class="tituloContenido">
                    <h1 id="titulo-Contenido"></h1>
                    <hr>
                </div>

                <div class="contenidoPrincipal" id="contenidoPrincipal">

                </div>
            
            </div>
            
            
        </div>
        
        <footer>
            <span class="footer-important">AppsLovers.com</span> | Todos los derechos reservados Lima - Perú 2014
        </footer>

        <script src="../vendor/jquery-2.1.1/jquery-2.1.1.min.js"></script>
        <script src="../vendor/bootstrap-3.2.0-dist/js/bootstrap.min.js"></script>
        <script src="../vendor/bootstrap-3.2.0-dist/js/modal.js"></script>
                
        <script>
            
            $(function() {
               CargarOpcion(<?php echo $opc;?>) ;
            });
            
            function CargarOpcion(opc) {
                var curl, titulo;
                switch(opc) {
                    case 1:
                        titulo = 'MANTENIMIENTO DE CONDUCTORES';
			curl = 'cp_conductores.php';
                        break;
                }
                
                $("#titulo-Contenido").html(titulo);
		$("#contenidoPrincipal").load(curl);
				
            }
            
        </script>
    </body>
</html>