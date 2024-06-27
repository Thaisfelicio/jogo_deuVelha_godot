extends Node2D

# Definir uma matriz para representar o tabuleiro
var board := [[0, 0, 0],
              [0, 0, 0],
              [0, 0, 0]]

# Variável para armazenar o quadrado premiado atualmente
var quadrado_premiado := null

func _ready():
    # Iniciar o jogo
    selecionar_quadrado_premiado()

# Função para selecionar um novo quadrado premiado aleatoriamente
func selecionar_quadrado_premiado():
    var possiveis_quadrados = []
    
    # Encontrar todos os quadrados vazios para o próximo prêmio
    for x in range(3):
        for y in range(3):
            if board[x][y] == 0:  # Quadrado vazio
                possiveis_quadrados.append(Vector2(x, y))
    
    # Escolher aleatoriamente um quadrado entre os possíveis
    if possiveis_quadrados.size() > 0:
        quadrado_premiado = possiveis_quadrados[randi() % possiveis_quadrados.size()]
        print("Novo quadrado premiado:", quadrado_premiado)
    else:
        print("Não há quadrados vazios para selecionar como premiado.")

# Função para verificar se um jogador fez uma jogada no quadrado premiado
func verificar_movimento_premiado(jogador, linha, coluna):
    if quadrado_premiado and quadrado_premiado.x == linha and quadrado_premiado.y == coluna:
        aplicar_bonus()

# Função para aplicar o bônus quando o quadrado premiado é jogado
func aplicar_bonus():
    print("Parabéns! Você recebeu um bônus por jogar no quadrado premiado.")
    selecionar_quadrado_premiado()  # Selecionar um novo quadrado premiado para a próxima rodada
