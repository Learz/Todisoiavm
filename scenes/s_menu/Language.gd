extends MenuButton

#TODO : Automate adding new locales (get_loaded_locales)
func _ready():
	set_current_mode_text()
	get_popup().connect("id_pressed", self, "_on_item_pressed")

func _on_item_pressed(id):
	match id:
		0:
			TranslationServer.set_locale("en")
		1:
			TranslationServer.set_locale("fr")
	get_tree().reload_current_scene()

#DESIGN : locale name is always in english, maybe unwanted?
func set_current_mode_text():
	text = TranslationServer.get_locale_name(TranslationServer.get_locale())
