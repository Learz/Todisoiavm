extends Control

var songList = ["Lazy Day", "Out And About", "Bobbin", "On My Own", "Vibes"]
var song_playing

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_Previous_pressed():
	var curSong = songList.find(SoundManager.bgm_playing)
	if curSong != -1:
		SoundManager.play_bgm(songList[(curSong-1)%songList.size()])
	$VBoxContainer/Title.text = SoundManager.bgm_playing

func _on_Next_pressed():
	var curSong = songList.find(SoundManager.bgm_playing)
	if curSong != -1:
		SoundManager.play_bgm(songList[(curSong+1)%songList.size()])
	$VBoxContainer/Title.text = SoundManager.bgm_playing

func _on_PlayPause_pressed():
	if SoundManager.is_bgm_playing():
		song_playing = SoundManager.bgm_playing
		var t = Texture.new()
		$VBoxContainer/MusicControls/PlayPause.texture_normal = load("res://resources/Phone_UI_Play.png")
		SoundManager.stop_bgm()
	else:
		
		$VBoxContainer/MusicControls/PlayPause.texture_normal = load("res://resources/Phone_UI_Stop.png")
		SoundManager.play_bgm(song_playing)
	pass # Replace with function body.
