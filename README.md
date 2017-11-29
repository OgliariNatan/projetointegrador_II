<h1> Projeto Integrador 2 </h1>
<p>Repositorio criado para a disciplina de Prpjeto Integrador 2 do curso de engenharia eletrônica do IFSC - câmpus Florianópolis. <br/>
Identificação junto aos mentores: "Equipe 2". <br/>
</p>

<h2> Requisitos de projeto: </h2> <p>
O projeto consiste em um sistema integrado com alguns sensores pré estabelecidos. <br/>
Resumindo, uma esteira com sensor de altura e cor com um seletor de para selecionar entre duas saidas. <br/>
	<ul>
		<li>Placa de desenvolvimento <a href="https://drive.google.com/open?id=0BzUZsr8WwPNLbmZDWnhsazVjMEE
">KIT DE2-115</a>.</li>
		<li>Linguagem VHDL ou Diagrama de Blocos.</li>
		<li>Sensor de distância <a href="https://cdn.sparkfun.com/datasheets/Sensors/Proximity/HCSR04.pdf">HCSR04</a>.</li>
		<li>Módulo de reconhecimento de cores <a href="http://www.mouser.com/catalog/specsheets/TCS3200-E11.pdf">TCS3200</a>.</li>
		<li>Sensor de proximidade infravermelho.</li>
		<li>Display de 7 segmentos ou LCD.</li>
		<li>Controle de velocidade de um motor DC.</li>
		<li>Controle do motor de passo.</li>
		<li>Interface homem-maquina.</li>
	</ul>
</p>



<h3>Softwares utilizados:</h3>
<p>
	<a href="http://dl.altera.com/16.1/?edition=lite">Quartus Lite Edition V16.1</a> <br/>
</p>
<h4>Contribuinte:</h4> <p>
		<a href="https://github.com/gutovsk49">Augusto</a>. <br/>
	</p>
<h4>Demais Informações relevantes para o projeto:</h4>
<p>
	Echo GPIO(1) <br/> Trigger GPIO(2) <br/>
	SW(17) --Habilita leitura do sensor de altura <br/>
	KEY(0)	--Seleciona entre leitura de cor e leitura de altura <br/>
	SW(11)	--Inicia o processo de leitura do sensor (futuro sensor de presença) <br/>
	GPIO(15)	--Saída em frequência do sensor (OUT)
	GPIO(35 ao 32)	--Seletor do filtro para cor
</p>
<p> A Pasta chamada D_7SEG, é o projeto principal. <br/>  </p>

<p>Para a interpretação dos dados mostrados no display de 7 segmentos, utilize a imagem abaixo:<br/>
 <img alt="7SEG." src="http://www.twyman.org.uk/Fonts/7%20Seq-3D.jpg"/> <br/>
Bits setados para os caracteres utilizados no projeto:<br/>
<table>
	<tr>
		<th align=center>Caracteres</th> <th>a</th><th>b</th> <th>c</th> <th>d</th> <th>e</th> <th>f</th> <th>g</th>
	</tr>
	<tr>
		<td align=center>C</td>	<td>0</td>	<td>1</td>	<td>1</td> <td>0</td>	<td>0</td>	<td>0</td>	<td>1</td>
	</tr>
	<tr>
		<td align=center>O</td>	<td>0</td>	<td>0</td>	<td>0</td>	<td>0</td>	<td>0</td>	<td>0</td>	<td>1</td>
	</tr>
	<tr>
		<td align=center>R</td>	<td>1</td>	<td>1</td>	<td>1</td>	<td>1</td>	<td>0</td>	<td>1</td>	<td>0</td>
	</tr>
	<tr>
		<td align=center>E</td>	<td>0</td>	<td>1</td>	<td>1</td>	<td>0</td>	<td>0</td>	<td>0</td>	<td>0</td>
	</tr>
	<tr>
		<td align=center>D</td>	<td>1</td>	<td>0</td>	<td>0</td>	<td>0</td>	<td>0</td>	<td>1</td>	<td>0</td>
	</tr>
	<tr>
		<td align=center>B</td>	<td>1</td>	<td>1</td>	<td>0</td>	<td>0</td>	<td>0</td>	<td>0</td>	<td>0</td>
	</tr>
	<tr>
		<td align=center>L</td>	<td>1</td>	<td>1</td>	<td>1</td>	<td>0</td>	<td>0</td>	<td>0</td>	<td>1</td>
	</tr>
	<tr>
		<td align=center>U</td>	<td>1</td>	<td>0</td>	<td>0</td>	<td>0</td>	<td>0</td>	<td>0</td>	<td>1</td>
	</tr>
	<tr>
		<td align=center>G</td>	<td>0</td>	<td>0</td>	<td>0</td>	<td>0</td>	<td>1</td>	<td>0</td>	<td>0</td>
	</tr>
	<tr>
		<td align=center>N</td>	<td>1</td>	<td>0</td>	<td>1</td>	<td>1</td>	<td>1</td>	<td>0</td>	<td>0</td>
	</tr>
</table> <br/>
</p>
