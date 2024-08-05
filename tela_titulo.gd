extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_botao_comecar_pressed():
	get_tree().change_scene_to_file("res://Principal.tscn")


func _on_botao_creditos_pressed():
	get_tree().change_scene_to_file("res://creditos.tscn")


func _on_botao_sair_pressed():
	get_tree().quit()
