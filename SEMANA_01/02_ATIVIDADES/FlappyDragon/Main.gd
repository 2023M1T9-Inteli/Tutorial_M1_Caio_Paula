extends Node # instancia a classe Node2D

var status = 0 #A variável status define se o o jogo está ou não sendo executado. Prefito abrir o jogo e depois executá-lo
var vscore = 0 #O vscore representa o valor da pontuação, que depois será projetado na tela.
var x = 3.5 #X é o valor que depois será usado para a movimentação horizontal do jogo, do cenário e colunas no caso-> mudei o valor de x para 3.5, assim o cenário corre mais rápido
var y = 1 #Y é o valor que será usado para a movimentação vertical no joco, do dração no caso

# executa essa função ao carregar o jogo
func _ready():
	# oculta o "gameover"
	$gameover.hide()


# executa essa função a cada frame (60 FPS)
func _process(delta):
	
	if status == 1: # jogando
		
		# movimenta o cenário do fundo
		$background.position.x -= 1.5*x #--> aumentei o multiplicador da posição x do cenário, apra acelerá-lo
		if ($background.position.x) < -200:
			$background.position.x = 600
			
		# movimenta as colunas para colisão
		$columns.position.x -= 2*x #--> aumentei das colunas também
		if ($columns.position.x) < -550:
			$columns.position.x = rand_range(0, 350) - 50
			$columns.position.y = rand_range(0, 400) - 200
		
		# puxa o dragão para baixo
		$dragon.position.y += y

		# se bateu no fundo, não desce mais e termina o jogo
		if $dragon.position.y > 480:
			$dragon.position.y = 480
			status = 0 # muda o status para "parado"

		# se bateu no teto, não sobe mais
		if $dragon.position.y < -20:
			$dragon.position.y = -20
			
		# se apertou seta para baixo, aumenta o valor de y (posição vertical) do dragão
		if Input.is_action_pressed("ui_down"):
			$dragon.position.y += 3.5 #para descer mais rápido, aumentei a valor da movimentação vertical quando seta-para-baixo é apertada

		# se apertou seta para cima, diminui o valor de y (posição vertical) do dragão
		if Input.is_action_pressed("ui_up"):
			$dragon.position.y -= 5 #nesse caso, a velocidade é maior para cima
			
	elif status == 0: # parado 
		
		$dragon/dragonImages.playing = false # faz dragão parar de bater as asas
		$gameover.show() # exibe imagem gameover

		# se apertou enter ou space, recomeça o jogo
		if Input.is_action_pressed("ui_accept"):
			$score.set_text("0") # zera o score
			vscore = 0 # zera o score
			status = 1 # muda o status para "jogando"
			$dragon/dragonImages.playing = true # faz dragão voltar a bater as asas
			$dragon.position.y = 0 # volta o dragão para a posição original
			$columns.position.x = 400 # muda a posição das colunas
			$gameover.hide() # oculta o gameover

			

# executa essa função quando o dragão bate na coluna
func _on_columns_body_shape_entered(body_id, body, body_shape, local_shape):
	if (local_shape < 2): # esse node tem 3 shapes de colisão: 0 e 1 são as colunas
		status = 0 # muda o status para "parado"

# executa essa função quando o dragão atravessa entre as colunas
func _on_columns_body_shape_exited(body_id, body, body_shape, local_shape):
	if (local_shape == 2): # esse node tem 3 shapes de colisão: 0 e 1 são as colunas
		vscore += 1 # aumenta o score
		$score.set_text(str(vscore)) # atualiza o painel
		

