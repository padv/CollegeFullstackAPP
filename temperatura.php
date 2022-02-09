<?php 
	
	class Evento {

		private $dataInicial;
		private $horarioInicial;
		private $dataAtual;
		private $horarioAtual;
		private $duração;


		function __construct($data, $horario, $tempo){
			$dataInicial = $data;
			$horarioInicial = $horario;
			$dataAtual = $data;
			$horarioAtual = $horario;
			$duração = $tempo;
			echo $data;
		}
	}






?>