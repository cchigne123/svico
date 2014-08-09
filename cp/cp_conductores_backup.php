<?php
	session_start();
	
	include '../funciones/funciones.php';
	
	$buscar = "%";
	$estado = "%";
	$empresa = "%";
	
	$controller=3;
	require_once '../controller/reportesController.php';
?>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title></title>
<link href="../css/panel.css" rel="stylesheet" type="text/css" />
<link href="../css/panelanexo.css" rel="stylesheet" type="text/css" />
</head>
<body>
<table width="94%" align="center">
  	<tr>
    	<td width="29%"><h2 class="txt-titulo-lista">&nbsp;</h2></td>
    	<td width="43%" align="center"><span class="txt-titulo-lista">LISTA DE CONDUCTORES</span></td>
    	<td width="28%" align="right" valign="middle">
        <button class="boton" type="button" onClick="javascript:ConductorDetalle('A')"><i class="glyphicon glyphicon-plus"></i> AGREGAR</button> &nbsp; &nbsp; &nbsp; &nbsp;<a href="#" onClick="javascript:ExportarExcel()"><img src="../images/excel.png" align="absmiddle" /> </a>
          </td>
    </tr>
  </table>
  
  
<table width="95%" border="0" align="center" cellpadding="0" cellspacing="1" class="mitabla">
  <tr >
    <td width="874" height="30" align="left"><form id="formlistado004" name="formlistado004" method="post" action="">
      <table width="95%" border="0" align="center">
        <tr>
          <td width="157" align="right" >Buscar:</td>
          <td width="249" height="41"><div class="form-group">
            <div class="col-sm-9">
              <input type="text" class="form-control" id="txt_buscar" placeholder="" size="40">
            </div>
          </div></td>
          <td width="19">&nbsp;</td>
          <td width="195" align="center">Estado: 
            <select class="form-control" id="estado" name="estado">
          	<option value="%">-- Todos --</option>
            <option value="1">Disponibles</option>
            <option value="0">No Disponibles</option>
            <option value="2">En Servicio</option>
          </select></td>
          <td width="221" align="center">Empresa: 
            <select class="form-control" id="empresa" name="empresa">
            <option value="%">-- Todas --</option>
            <option value="MO">Taxi Molina</option>
            <option value="ME">Metrotours</option>
          </select>
            </td>
            <td width="1" align="left"></a>
        </tr>
      </table>
    </form></td>
  </tr>
  <tr >
    <td height="20" align="center" valign="middle" bgcolor="#FFFFFF"><br>
      <br>
      <div id="conductoresDiv" style="max-height:600px;overflow:auto;">
        <table width="98%" border="1" cellpadding="0" cellspacing="1" id="Exportar_a_Excel" class="mitabla" style="border-collapse:collapse"; >
          <tr class = "pixel">
            <td width="142" align="center" background="../images/fondo-lista.png">Apellidos y Nombres</td>
            <td width="64" align="center" background="../images/fondo-lista.png">DNI</td>
            <td width="120" align="center" background="../images/fondo-lista.png">Distrito</td>
            <td width="75" height="35" align="center" background="../images/fondo-lista.png">N° Celular</td>
            <td width="93" align="center" background="../images/fondo-lista.png">N° Licencia</td>
            <td width="56" align="center" background="../images/fondo-lista.png">Categoría</td>
            <td width="95" align="center" background="../images/fondo-lista.png">Empresa</td>
            <td width="66" align="center" background="../images/fondo-lista.png">Placa de Taxi</td>
            <td width="76" align="center" background="../images/fondo-lista.png">¿Bloqueado?</td>
            <td width="27" align="center" background="../images/fondo-lista.png">&nbsp;</td>
          </tr>
          <?php
		    for ($x=0; $x<count($ListCond); $x++)
			{
				$idconductor = $ListCond[$x]['id_usu_detalle'];
				$conductor = utf8_encode($ListCond[$x]['conductor']);
				$dni = $ListCond[$x]['dni'];
				$distrito = strtoupper($ListCond[$x]['distrito']);
				$celular = $ListCond[$x]['ncelular'];
				$licencia = $ListCond[$x]['nlicencia'];
				$categoria = $ListCond[$x]['cate_licencia'];
				$placa = $ListCond[$x]['num_placa'];
				$activo = $ListCond[$x]['activo'];
				if($activo==="S") { // esta activo, entonces hay que bloquear
					$img = "../images/unlock-icon.png";
					$ttl = "BLOQUEAR";
					$cambio = "N";
				} else {
					$img = "../images/lock-icon.png";
					$ttl = "DESBLOQUEAR";
					$cambio = "S";
				}
	
				$empretxt = "";
				$empresa = $ListCond[$x]['empresa'];
				if ( $empresa == "MO" ) {
					$empretxt = "Taxi Molina";	
				} 
				
				if ( $empresa == "ME" ) {
					$empretxt = "Metrotours";
				}
			?>
          <tr 
		style="" 
	    onmouseover="javascript:this.style.backgroundColor='#bebec0'" onMouseOut="javascript:this.style.backgroundColor=''" bgcolor="#FFFFFF" height="30">
            <td align="center"><?php echo $conductor;?></td>
            <td align="center"><?php echo $dni;?></td>
            <td align="center"><?php echo $distrito;?></td>
            <td align="center"><?php echo $celular;?></td>
            <td align="center"><?php echo $licencia;?></td>
            <td align="center"><?php echo $categoria;?></td>
            <td align="center"><?php echo $empretxt;?></td>
            <td align="center"><?php echo $placa;?></td>
            <td align="center"><a href="javascript:BDConductor(<?php echo $idconductor;?>, '<?php echo $cambio;?>')" title="<?php echo $ttl;?>"><img src="<?php echo $img;?>" width="22" height="22" /></a></td>
            <td align="center"><a href="javascript:ConductorDetalle('E', <?php echo $idconductor;?>)" title="EDITAR"><img src="../images/edit-icon.png" width="22" height="22" /></a></td>
          </tr>
          <?php } ?>
        </table>
      </div></td>
  </tr>
  <tr >
    <td height="20" align="center" valign="middle" bgcolor="#FFFFFF"><div class="linea-final-lista"></div></td>
  </tr>
  <tr >
    <td height="20" align="center" valign="middle">&nbsp;</td>
  </tr>
</table>


<script>

	$(function() {
			
			$("#txt_buscar").keyup(function() {
				var buscar = $(this).val();
				if(buscar==""){
					buscar = "%";	
				}
				var estado = $("#estado").val();
				var empresa = $("#empresa").val();
				busquedaDinamica(buscar, estado, empresa);
			});
			
			$("#estado").change(function() {
				var buscar = $("#txt_buscar").val();
				if(buscar==""){
					buscar = "%";	
				}
				var estado = $(this).val();
				var empresa = $("#empresa").val();
			   busquedaDinamica(buscar, estado, empresa);
			});
			
			$("#empresa").change(function() {
				var buscar = $("#txt_buscar").val();
				if(buscar==""){
					buscar = "%";	
				}
				var estado = $("#estado").val();
				var empresa = $(this).val();
			   busquedaDinamica(buscar, estado, empresa);
			});
			
		});
		
		
		function busquedaDinamica(buscar, estado, empresa) {
			var curl = "../view/rep_conductor_search.php?buscar="+buscar+"&estado="+estado+"&empresa="+empresa;	
			$("#conductoresDiv").load(curl);
		}
		
		
		function ConductorDetalle(tipo, idconductor) {
			var curl;
			var title;
			if (tipo==="A") {
				title = "Agregando conductor ...";
				curl = "../view/rep_conductor_detail.php";
			} else {
				title = "Editando conductor ..."
				curl = "../view/rep_conductor_detail.php?idconductor="+idconductor;
			}
			$EditarCondDialog = $("#ConductorDiv").dialog({
			   width: 650,
			   height: 'auto',
			   position: ['center', 20],
			   title: title,
			   modal: true,
			   resizable: false,
			   close: function() {
				   $("#ConductorDiv").html("Cargando datos ...");
			   }
			});
			
			$("#ConductorDiv").load(curl);
		}
		
		
		function BDConductor(idconductor, cambio) {
			var curl = "../view/rep_conductor_bd.php?idconductor="+idconductor+"&cambio="+cambio;	
			$.ajax({
				url: curl,
				method: "post",
				cache: false,
				success: function(data){
					busquedaDinamica( $("#txt_buscar").val() , $("#estado").val() );
				}
			});
		}
		
		function ExportarExcel(){
			var buscar = $("#txt_buscar").val();
			if(buscar==""){
				buscar = "%";	
			}
			var estado = $("#estado").val();
			var curl = "../view/rep_conductor_excel.php?buscar="+buscar+"&estado="+estado;
			window.location = curl;
		}

</script>

</body>
</html>