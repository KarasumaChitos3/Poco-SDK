extends Node
class_name PocoClient


var DEBUG:bool = false
var sock:StreamPeerTCP = null
var buf:String = ''
var sendbuf:String = ''
var client_index:int = 0


func _init(_sock:StreamPeerTCP,cli_index,debug:bool = false):
	sock = _sock
	client_index = cli_index
	DEBUG = debug
	sock.poll()
	

func input(data:String) :
	buf = buf + data
	var ret = []
	return data


# func _process(delta:float):
# 	receive()

func receive():
	# print('client is running')
	# sock.poll()
	var s = sock.get_utf8_string()
	if s: 
		var json = JSON.new()
		json.parse(s)
		return json.get_data()
	else:
		close()
	return 
	

	# clients[0].send(test(s))

func send(data):
	var json = JSON.new()
	var data_to_send = json.stringify(data)
	if DEBUG:
		print(data_to_send)
	sock.put_utf8_string(data_to_send)
	# sock.put_data(data_to_send.to_utf8_buffer())
	
func close():
	sock.disconnect_from_host()
#	sock.free()
	print('[poco] client disconnect')


func getAddress():
	return sock.get_connected_host()

