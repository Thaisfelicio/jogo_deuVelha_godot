extends CanvasLayer

signal recomecar

func _on_botao_recomecar_pressed():
	recomecar.emit()
