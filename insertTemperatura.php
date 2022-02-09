<?php

	$hostname = "localhost";
	$username = "root";
	$password = "";
	$dbname = "mainuser";
	$yourfield = "temperatura";
	$hora = isset($_POST['hora']) ? $_POST['hora'] : '-1';
	$temp = isset($_POST['temp']) ? $_POST['temp'] : '0';
	$data = isset($_POST['data']) ? $_POST['data'] : '0000-00-00';
	$dataFormatacao = explode('-', $data); 
	$novaData = $dataFormatacao[2].'-'.$dataFormatacao[1].'-'.$dataFormatacao[0];

	$query = "INSERT INTO `mainuser`.`ar_ativacoes` VALUES 
		(null, 3, 1, '$novaData', '$hora', '$temp')";

	$con = mysqli_connect($hostname,$username,$password) or die ("html>script language='JavaScript'>alert('Unable to connect to database! Please try again later.'),history.go(-1)/script>/html>"); 

	mysqli_select_db($con, $dbname);
	$result = mysqli_query($con,$query);


?>