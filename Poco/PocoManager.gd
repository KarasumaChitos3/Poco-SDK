extends Node

const VERSION:String = '0.0.1'
var port:int = 5001
@onready 
var dumper = Dumper.new()


var _server:TCPServer = null
var server_thread:Thread

var PocoManager = {}

var DEBUG = false
var all_socks = []
# var clients:Array[PocoClient] = []
var clients:Array[PocoClient] = []

var dispatcher = {
	'GetSDKVersion' : func(): return VERSION,
	'Dump' : func(onlyVisibleNode:bool): return dumper.dumpHierarchy(onlyVisibleNode),
	# 'Screenshot' : func(width)
	# 'dispatcher':
	# "SetText":
	'test' :  func(arg1:String, arg2:String): return 'test arg1:' +arg1 +' arg2:' + arg2
}

signal receive_msg(client_index:int)

func _ready() -> void:
	init_server()
	server_thread = Thread.new()
	server_thread.start(server_loop)


func _process(delta: float) -> void:
	# server_loop()
	print(clients)

func init_server() -> void:
	print('strat server ....')
	_server = TCPServer.new()
	_server.listen(port)
	print('strat server success')
	print('[poco] server listens on tcp://*:%d' % port)

func server_loop() -> void:
	while true:
		var sock:StreamPeerTCP = _server.take_connection()
		if sock:
			all_socks.append(sock)
			var new_client = PocoClient.new(sock,clients.size(),true)
			print('[poco] new client accepted')
			clients.append(new_client)
		for client in clients:
			var reqs = client.receive()
			if reqs:
				onRequest(client,reqs)
			else:
				print('未收到消息')
		# var s = sock.get_utf8_string()
		# print(s)
		# clients[0].send(test(s))

# func recive_client_signal(cli_index:int,reqs):
# 	var client = clients[cli_index]
# 	var reqs = reqs
	

func onRequest(client,req:Dictionary):
	print(req)
	# var client:String = req.client
	var method:String = req.method
	var params:Array = req.params
	var function:Callable = dispatcher[method]
	var ret = {
		'id' : req.id,
		'jsonrpc' : req.jsonrpc,
		'result' : null,
		'error' : null
	}
	# if not function:
	# 	# ret['error'] = {message : 'No such rpc method '+ method , reqid: %s, client:%s' % (method, req.id, req.client)}
	# 	ret['error'] = {message : 'No such rpc method ' + method}
	var res = function.call(params[0])
	# print(res)
	ret['result'] = res
	client.send(ret)

	
	
func test(s):
	return {'name':'刘备','payload':'关羽','children':{}}
	
