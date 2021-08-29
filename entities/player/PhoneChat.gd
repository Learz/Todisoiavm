extends Control

var sentMessageScene = load("res://entities/player/ChatSentMessage.tscn")
var receivedMessageScene = load("res://entities/player/ChatReceivedMessage.tscn")

func _ready():
	$Dialogue.start_dialogue()
	pass # Replace with function body.

func _on_Dialogue_Choice_Next(ref, choices):
	for i in $VBoxContainer/Choices.get_children():
		i.queue_free()
	
	for i in range(0, choices.size()):
		var newButton = load("res://entities/player/ChatChoiceButton.tscn").instance()
		newButton.text = choices[i].Dialogue
		newButton.connect("pressed", self, "_on_choice_pressed", [i, choices[i].Dialogue])
		newButton.disabled = !choices[i]["PassCondition"]
		newButton.hint_tooltip = choices[i]["ToolTip"]
		$VBoxContainer/Choices.add_child(newButton) 

func _on_choice_pressed(id, text):
	add_message(text)
	for i in $VBoxContainer/Choices.get_children():
		i.queue_free()

func _on_Dialogue_Conditonal_Data_Needed():
	pass # Replace with function body.


func _on_Dialogue_Dialogue_Ended():
	pass # Replace with function body.


func _on_Dialogue_Dialogue_Next(ref, actor, text):
	add_message(text, actor)


func _on_Dialogue_Dialogue_Started():
	pass # Replace with function body.


func _on_Timer_timeout():
	$Dialogue.next_dialogue()
	
func add_message(text, actor = "Me"):
	var message
	if actor == "Me":
		message = sentMessageScene.instance()
	else:
		message = receivedMessageScene.instance()
	message.text = text
	$VBoxContainer/ScrollContainer/Messages.add_child(message)
	$Dialogue.next_dialogue()
	#$Timer.start()
