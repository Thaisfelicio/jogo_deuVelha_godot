extends Node2D

@export var cena_circulo: PackedScene
@export var cena_xAzul: PackedScene

var jogador: int
var movimentos: int
var ganhador: int
var temp_marcador
var posicao_painel_jogador: Vector2i
var dados_grade: Array
var posicao_grade: Vector2i
var tamanho_tabuleiro: int
var tamanho_celula: int
var soma_linha: int
var soma_coluna: int
var soma_diagonal1: int
var soma_diagonal2: int

@onready var efeito = $efeito as AudioStreamPlayer

func _ready():
	tamanho_tabuleiro = $Tabuleiro.texture.get_width()
	#dividir o tamanho do tabuleiro por 3 para pegar o tamanho induvidual da célula
	tamanho_celula = tamanho_tabuleiro / 3

	#pegar as cordenadas do pequeno painel no lado direito da janela
	posicao_painel_jogador = $PainelJogador.get_position()
	
	novo_jogo()
	
#func _process(delta):
#	pass

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			if event.position.x < tamanho_tabuleiro:
				efeito.play()
				posicao_grade = Vector2i(event.position / tamanho_celula)
				if dados_grade[posicao_grade.y][posicao_grade.x] == 0:
					movimentos += 1
					dados_grade[posicao_grade.y][posicao_grade.x] = jogador
					#lugar que o jogador marca
					criar_marcador(jogador, posicao_grade * tamanho_celula + Vector2i(tamanho_celula / 2, tamanho_celula / 2))
					if verificar_ganhador() != 0:
						get_tree().paused = true
						$GameOverMenu.show()
						if ganhador == 1:
							$GameOverMenu.get_node("LabelResultado").text = "Jogador(a) 1 ganhou!"
						elif ganhador == -1:
							$GameOverMenu.get_node("LabelResultado").text = "Jogador(a) 2 ganhou!"
					#verificar se o tabuleiro foi preenchido
					elif movimentos == 9:
						get_tree().paused = true
						$GameOverMenu.show()
						$GameOverMenu.get_node("LabelResultado").text = "Deu velha!"
					jogador *= -1
					#atualizar o marcador do painel
					temp_marcador.queue_free()
					criar_marcador(jogador, posicao_painel_jogador + Vector2i(tamanho_celula / 2, tamanho_celula / 2), true)
					print(dados_grade)

func novo_jogo():
	jogador = 1
	movimentos = 0
	ganhador = 0
	dados_grade = [
		[0, 0, 0], 
		[0, 0, 0], 
		[0, 0, 0]
		]
	soma_linha = 0
	soma_coluna = 0
	soma_diagonal1 = 0
	soma_diagonal2 = 0
	#limpar os marcadores existentes
	get_tree().call_group("grupoXAzul", "queue_free")
	get_tree().call_group("grupoCirculoVerde", "queue_free")
	#criar um marcador para mostrar a vez do jogador inicial
	criar_marcador(jogador, posicao_painel_jogador + Vector2i(tamanho_celula / 2, tamanho_celula / 2), true)
	$GameOverMenu.hide()
	get_tree().paused = false


func criar_marcador(jogador, posicao, temp = false):
	#criar um nó marcador e adicioná-lo como um child
	if jogador == 1:
		var circulo = cena_circulo.instantiate()
		circulo.position = posicao
		add_child(circulo)
		if temp: temp_marcador = circulo
	else:
		var xAzul = cena_xAzul.instantiate()
		xAzul.position = posicao
		add_child(xAzul)
		if temp: temp_marcador = xAzul

func verificar_ganhador():
	
	for i in len(dados_grade):
		soma_linha = dados_grade[i][0] + dados_grade[i][1] + dados_grade[i][2]
		soma_coluna = dados_grade[0][i] + dados_grade[1][i] + dados_grade[2][i]
		soma_diagonal1 = dados_grade[0][0] + dados_grade[1][1] + dados_grade[2][2]
		soma_diagonal2 = dados_grade[0][2] + dados_grade[1][1] + dados_grade[2][0]
		
		#verificar se qualquer jogador tem 3 marcadores em uma linha
		if soma_linha == 3 or soma_coluna == 3 or soma_diagonal1 == 3 or soma_diagonal2 == 3:
			ganhador = 1
		elif soma_linha == -3 or soma_coluna == -3 or soma_diagonal1 == -3 or soma_diagonal2 == -3:
			ganhador = -1
	return ganhador


func _on_game_over_menu_recomecar():
	novo_jogo()
