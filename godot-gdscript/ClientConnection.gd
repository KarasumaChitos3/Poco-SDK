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
	

func input(data:String) :
	buf = buf + data
	var ret = []
	return data


func _process(delta:float):
	
	receive()

func receive():
	print('client is running')
	var s = sock.get_utf8_string()
	if not s: 
		return 
	print('######Clent：',s)

	# clients[0].send(test(s))

func send(data):
	var json = JSON.new()
	var data_to_send = json.stringify(data)
	if DEBUG:
		print(data_to_send)
	sock.put_utf8_string(data_to_send)
	
func close():
	sock.disconnect_from_host()
	sock.free()
	print('[poco] client disconnect')


func getAddress():
	return sock.get_connected_host()

