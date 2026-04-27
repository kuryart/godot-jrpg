class_name Shadowable extends TileMapLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# 1. Cria o nó da sombra dinamicamente
	var shadow = Sprite2D.new()
	
	# 2. Copia a textura EXATA do objeto (garante o detalhe das folhas)
	shadow.texture = $Sprite2D.texture # Ajuste para o caminho do seu sprite principal
	
	# 3. Garante que fique SEMPRE atrás do objeto
	shadow.show_behind_parent = true
	# shadow.z_index = -1 # (Alternativa, caso show_behind_parent não baste na sua árvore de cena)
	
	# 4. Transforma em sombra (Preto com 50% de transparência)
	shadow.modulate = Color(0, 0, 0, 0.5)
	
	# 5. Projeta no chão usando as propriedades nativas do Godot 4
	shadow.scale.y = 0.5  # Achata a sombra pela metade
	shadow.skew = 0.5     # "Tomba" a sombra para o lado (Projeção)
	
	# 6. Desloca para a base do objeto
	# Ajuste esse valor dependendo de onde fica o "pé" do seu sprite
	shadow.position = Vector2(16, 32) 
	
	# Adiciona a sombra como filha
	add_child(shadow)
