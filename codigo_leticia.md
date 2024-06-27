extends Node2D

# Variáveis exportadas para o editor
@export var cena_circulo: PackedScene
@export var cena_xAzul: PackedScene

# Variáveis de controle do jogo
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

# Variáveis para controle do bônus
var bonus_disponivel: bool = false
var escolha_bonus: int = 0  # 1 para excluir jogada, -1 para bloquear a vez do adversário

func _ready():
    tamanho_tabuleiro = $Tabuleiro.texture.get_width()
    tamanho_celula = tamanho_tabuleiro / 3
    posicao_painel_jogador = $PainelJogador.get_position()
    novo_jogo()

func _input(event):
    if event is InputEventMouseButton:
        if event.button_index == BUTTON_LEFT and event.pressed:
            if event.position.x < tamanho_tabuleiro:
                posicao_grade = Vector2i(event.position / tamanho_celula)
                if dados_grade[posicao_grade.y][posicao_grade.x] == 0:
                    if bonus_disponivel:
                        aplicar_bonus(posicao_grade)
                    else:
                        fazer_jogada(posicao_grade)
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
    get_tree().call_group("grupoXAzul", "queue_free")
    get_tree().call_group("grupoCirculoVerde", "queue_free")
    criar_marcador(jogador, posicao_painel_jogador + Vector2i(tamanho_celula / 2, tamanho_celula / 2), true)
    $GameOverMenu.hide()
    get_tree().paused = false
    bonus_disponivel = false
    escolha_bonus = 0

func criar_marcador(jogador, posicao, temp = false):
    if jogador == 1:
        var circulo = cena_circulo.instance()
        circulo.position = posicao
        add_child(circulo)
        if temp: temp_marcador = circulo
    else:
        var xAzul = cena_xAzul.instance()
        xAzul.position = posicao
        add_child(xAzul)
        if temp: temp_marcador = xAzul

func verificar_ganhador():
    for i in range(3):
        soma_linha = dados_grade[i][0] + dados_grade[i][1] + dados_grade[i][2]
        soma_coluna = dados_grade[0][i] + dados_grade[1][i] + dados_grade[2][i]
        soma_diagonal1 = dados_grade[0][0] + dados_grade[1][1] + dados_grade[2][2]
        soma_diagonal2 = dados_grade[0][2] + dados_grade[1][1] + dados_grade[2][0]
        
        if soma_linha == 3 or soma_coluna == 3 or soma_diagonal1 == 3 or soma_diagonal2 == 3:
            ganhador = 1
        elif soma_linha == -3 or soma_coluna == -3 or soma_diagonal1 == -3 or soma_diagonal2 == -3:
            ganhador = -1
    return ganhador

func aplicar_bonus(posicao):
    if escolha_bonus == 1:
        excluir_jogada_adversario(posicao)
    elif escolha_bonus == -1:
        bloquear_vez_adversario()

    bonus_disponivel = false
    escolha_bonus = 0
    fazer_jogada(posicao)

func excluir_jogada_adversario(posicao):
    if dados_grade[posicao.y][posicao.x] != 0:
        dados_grade[posicao.y][posicao.x] = 0
        # Implemente uma lógica adicional se necessário, como desfazer a última jogada do adversário

func bloquear_vez_adversario():
    # Pode ser implementado de várias formas, como alterar a lógica no _input para ignorar a jogada do adversário
    # Aqui, você pode adicionar lógica para impedir o adversário de jogar na próxima vez

func fazer_jogada(posicao):
    dados_grade[posicao.y][posicao.x] = jogador
    criar_marcador(jogador, posicao * tamanho_celula + Vector2i(tamanho_celula / 2, tamanho_celula / 2))
    if verificar_ganhador() != 0:
        get_tree().paused = true
        $GameOverMenu.show()
        if ganhador == 1:
            $GameOverMenu.get_node("LabelResultado").text = "Jogador(a) 1 ganhou!"
        elif ganhador == -1:
            $GameOverMenu.get_node("LabelResultado").text = "Jogador(a) 2 ganhou!"
    elif movimentos == 9:
        get_tree().paused = true
        $GameOverMenu.show()
        $GameOverMenu.get_node("LabelResultado").text = "Deu empate!"
    else:
        jogador *= -1
        temp_marcador.queue_free()
        criar_marcador(jogador, posicao_painel_jogador + Vector2i(tamanho_celula / 2, tamanho_celula / 2), true)
        print("Vez do jogador", jogador)
        bonus_disponivel = true  # Ativar o bônus após a jogada do jogador

