extends Control

var dialogue_resource = preload("res://resources/dialogue/chat.tres")
	
var sentMessageScene = load("res://entities/player/ChatSentMessage.tscn")
var receivedMessageScene = load("res://entities/player/ChatReceivedMessage.tscn")

onready var messages = $VBoxContainer/ScrollContainer/Messages
onready var choices = $VBoxContainer/ReplyBox/Choices
onready var scrollbar = $VBoxContainer/ScrollContainer.get_v_scrollbar()

var dialogue_line : DialogueLine
var max_scroll = 0

func _ready():
	scrollbar.connect("changed", self, "_scroll_to_bottom")
	max_scroll = scrollbar.max_value 
	add_message("intro")

func _on_choice_pressed(id, text):
	for i in choices.get_children():
		i.queue_free()
	
	var message = sentMessageScene.instance()
	message.text = text
	messages.add_child(message)
	
	add_message(id)
	
func add_message(id):
	$Timer.start()
	yield($Timer,"timeout")
	dialogue_line = yield(DialogueManager.get_next_dialogue_line(id, dialogue_resource), "completed")
	if dialogue_line != null:
		var message
		message = receivedMessageScene.instance()
		message.text = dialogue_line.dialogue
		messages.add_child(message)
		if dialogue_line.responses.empty():
			add_message(dialogue_line.next_id)
		else:
			add_choice()

func add_choice():
	for i in choices.get_children():
		i.queue_free()
	
	for choice in dialogue_line.responses:
		choice = choice as DialogueResponse
		var newButton = load("res://entities/player/ChatChoiceButton.tscn").instance()
		newButton.text = choice.prompt
		newButton.connect("pressed", self, "_on_choice_pressed", [choice.next_id, choice.prompt])
		choices.add_child(newButton) 

func _scroll_to_bottom():
	if max_scroll != scrollbar.max_value:
		max_scroll = scrollbar.max_value
		$VBoxContainer/ScrollContainer.scroll_vertical = max_scroll
