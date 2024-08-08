extends Control

signal escolha_bloquear
signal escolha_apagar

func _on_apagar_pressed():
	escolha_apagar.emit()


func _on_bloquear_pressed():
	escolha_bloquear.emit()

