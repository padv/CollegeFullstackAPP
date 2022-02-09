<?php 

	include "temperatura.php";

	$data = htmlspecialchars($_POST['data']);
	$horario = htmlspecialchars($_POST['horario']);
	$tempo = htmlspecialchars($_POST['tempo']);

	$evento = new Evento($data, $horario, $tempo);

?>