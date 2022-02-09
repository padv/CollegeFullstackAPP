function eventoAr(){

	let seletorDataEHorario = `
		<div>
			<form>
				<label for="date">Data:</label>
				<input type="date" id="data" name="data">
				<label for="time">Horário:</label>
				<select id="time" name="time">
				</select>
				<label for="duration">Duração:</label>
				<select id="duration" name="duration">
					<option value="4">4 Horas</option>
					<option value="6">6 Horas</option>
					<option value="8">8 Horas</option>
				</select>
				<button type="button" onclick="iniciarJornada()">Iniciar</button>
			</form>
		</div>
	`;


	document.getElementById('mutavel').innerHTML="<h3>Selecione DATA e HORÁRIO que o João entrou no seu quarto</h3>"+seletorDataEHorario;

	for(let i = 0; i < 24; i++){
		let node = document.createElement("option");
		node.setAttribute("value", i)
		node.innerHTML = `${i}:00`;
		document.getElementById("time").appendChild(node);
		  
	}

}

function iniciarJornada(){

	if(document.getElementById("data").value === ""){
		alert("Favor inserir data!");
	}
	else{

		let horaInicial = document.getElementById("time").value;
		let formData = new FormData();
		formData.append("hora", horaInicial);

		fetch('mediaTemperatura.php', {
			method: 'POST',
			body: formData
		}).then(response => response.json()).then(temp => {
			console.log(temp);
			const dataInicial = document.getElementById("data").value;
			let duracao = document.getElementById("duration").value;
			console.log(dataInicial);
			let dataAtual = formatarData(dataInicial, false, true);
			console.log(dataAtual);
			let horaAtual = horaInicial;
			let temperaturaMedia = temp; //BACKEND CALCULAR ESSE VALOR PASSAR FUNÇÃO
			let temperaturaAtual = temperaturaMedia;

			document.getElementById('mutavel').innerHTML=`
				<div>
					<h3>DURAÇÃO</h3>
					<div id="duracao">${duracao}</div>
					HORAS
				</div>
				<div>
					<h3>TEMPERATURA MÉDIA DO HORÁRIO</h3>
					<div id="tempMedia">${temperaturaMedia}</div>
					<div>C</div>
				</div>
				<div>
					<h3>DATA</h3>
					<div id="dataAtual">${dataAtual}</div>
				</div>
				<div>
					<h3>HORÁRIO</h3>
					<div id="horaAtual">${horaAtual}</div>
					:00
				</div>
				<div>
					<h1>TEMPERATURA ATUAL</h1>
					<div style="font-size: 100px">
						<button type="button" onclick="alterarTemp(1)">-</button>
						<div id="tempAtual">${temperaturaAtual}</div>
						C
						<button type="button" onclick="alterarTemp(2)">+</button>
						<button type="button" onclick="passarUmaHora()">Zzzz...</button>
					</div>
					
				</div>

			`;
	
		})
	}
}
function alterarTemp(maisOuMenos){

	let temperaturaAtual = parseInt(document.getElementById('tempAtual').innerHTML);
	let mudanca;
	if(maisOuMenos == 1){
		mudanca = temperaturaAtual - 1;
	}
	else{
		mudanca = temperaturaAtual + 1;
	}

	if(mudanca < 16){ //NÃO DEIXA TEMPERATURA SER MENOR QUE 16 OU MAIOR QUE 30
		mudanca = 16;
	}else if(mudanca > 30){
		mudanca = 30;
	}

	document.getElementById('tempAtual').innerHTML=`${mudanca}`;

}


function passarUmaHora(){

	//1 - salvar valores no banco de dados 2 - pegar nova temperatura média em relação aquele novo horario do BD 3 - Alterar temperatura atual para a média do novo horário
	
	let horaSalva = parseInt(document.getElementById('horaAtual').innerHTML);
	let tempSalva = parseInt(document.getElementById('tempAtual').innerHTML);
	let dataSalva = document.getElementById('dataAtual').innerHTML;

	let formData = new FormData();
	formData.append("hora", horaSalva);
	formData.append("temp", tempSalva);
	formData.append("data", dataSalva);

	fetch('insertTemperatura.php', {
		method: 'POST',
		body: formData
	});

	formData = new FormData();
	formData.append("hora", (horaSalva + 1));

	fetch('mediaTemperatura.php', {
		method: 'POST',
		body: formData
	}).then(response => response.json()).then(temp => {

		document.getElementById('tempMedia').innerHTML=`${temp}`
		let duracao = parseInt(document.getElementById('duracao').innerHTML) - 1;
		document.getElementById('duracao').innerHTML=`${duracao}`;

		let horaAtual = parseInt(document.getElementById('horaAtual').innerHTML) + 1;
		if(horaAtual == 24){
			horaAtual = 0;
			let dataInicial = formatarData(document.getElementById('dataAtual').innerHTML, true, false);  //MUDA O DIA ATUAL PARA O PRÓXIMO SE ATINGIR MEIA NOITE
			let dataAtual = formatarData(adicionarDia(dataInicial), false, true);
			document.getElementById('dataAtual').innerHTML=`${dataAtual}`;
		}
		document.getElementById('horaAtual').innerHTML=`${horaAtual}`;

		if(duracao < 1){ //FINALIZA O PROGRAMA QUANDO ACABAR A DURAÇÃO
			document.getElementById('mutavel').innerHTML="<h1>Obrigado por testar nossa aplicação! Aperte F5 para tentar novamente!</h1>";
		}
	})
}

function formatarData(data, originalDiaMes, destinoDiaMes){
	let nData;

	if(originalDiaMes != true){
		nData = new Date(data);
		console.log(nData);
	}
	else{
		dataSplit = data.split("-").reverse().join("-");
		console.log(dataSplit);
		nData = new Date(dataSplit);
	}
	console.log(nData);
	let dia = nData.getUTCDate();
	let mes = nData.getUTCMonth() + 1;
	let ano = nData.getUTCFullYear();
	let dataDiaMes = dia + "-" + mes + "-" + ano;
	let dataMesDia = mes + "-" + dia + "-" + ano;

	if(destinoDiaMes == true){
		return dataDiaMes;
	}
	else{
		return dataMesDia
	}
	
}

function adicionarDia(data) {
  let novaData = new Date(data);
  novaData.setDate(novaData.getDate() + 1);
  console.log(data);
  console.log(novaData);
  return novaData;
}