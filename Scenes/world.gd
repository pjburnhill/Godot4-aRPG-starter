extends Node2D

@onready var main_menu = $MenuUI/MainMenu
@onready var addredd_entry = $MenuUI/MainMenu/MarginContainer/VBoxContainer/AddressEntry

const Player = preload("res://Assets/Player/player.tscn")

const PORT = 9999
var enet_peer = ENetMultiplayerPeer.new()

func _on_quit_pressed():
	get_tree().quit()

func _unhandled_input(_event):
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()

func _on_host_pressed():
	main_menu.hide()
	
	enet_peer.create_server(PORT)
	multiplayer.multiplayer_peer = enet_peer
	multiplayer.peer_connected.connect(add_player)
	
	add_player(multiplayer.get_unique_id())

func _on_join_pressed():
	main_menu.hide()
	
	enet_peer.create_client("localhost", PORT)
	multiplayer.multiplayer_peer = enet_peer
	

func add_player(peer_id):
	var player = Player.instantiate()
	player.name = str(peer_id)
	add_child(player)
