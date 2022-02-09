<?php 
	
	$hostname = "localhost";
	$username = "root";
	$password = "";
	$dbname = "mainuser";
	$yourfield = "temperatura";
	$hora = isset($_POST['hora']) ? $_POST['hora'] : 'ERRO!';

	$query = "SELECT `ar_ativacoes`.`temperatura`
    FROM `mainuser`.`ar_ativacoes` 
    WHERE `ar_ativacoes`.`horario`= '$hora' AND `ar_ativacoes`.`desligar-ligar` = 1;";

	$con = mysqli_connect($hostname,$username,$password) or die ("html>script language='JavaScript'>alert('Unable to connect to database! Please try again later.'),history.go(-1)/script>/html>"); 

	mysqli_select_db($con, $dbname);


	$result = mysqli_query($con,$query);

	if($result){
		$todasTemps = [];
		while($row = mysqli_fetch_array($result)){
			$temp = $row["$yourfield"];
			$todasTemps[] = $temp;
		}

		$qtd = count($todasTemps);

		if($qtd > 0){
			$soma = array_sum($todasTemps);
			$media = ceil($soma/$qtd);
			echo json_encode($media);
		}else{
			echo json_encode(20);
		}


	};

?>