extends Node

const VERSION:String = '0.0.1'
var port:int = 5001

var _server:TCPServer = null
# var server:AsyncTcpServer = null

var PocoManager = {}

var DEBUG = false
var all_socks = []
# var clients:Array[PocoClient] = []
var clients:Array[PocoClient] = []

var dispatcher = {
	'GetSDKVersion' : func(): return VERSION,
	# 'Dump' : 
	# 'Screenshot' : 
	# 'dispatcher':
	# "SetText":
	'test' :  func(arg1:String, arg2:String): return 'test arg1:' +arg1 +' arg2:' + arg2
}

func _ready() -> void:
	init_server()


func _process(delta: float) -> void:
	server_loop()


func init_server() -> void:
	print('strat server ....')
	_server = TCPServer.new()
	_server.listen(port)
	print('strat server success')
	print('[poco] server listens on tcp://*:%d' % port)

func server_loop() -> void:
	var sock:StreamPeerTCP = _server.take_connection()
	if sock:
		var new_client = PocoClient.new(sock,true)
		clients.append(new_client)
		var s = sock.get_utf8_string()
		print(s)
		clients[0].send(test(s))

func onRequest(req:Dictionary):
	var client:String = req.client
	var method:String = req.method
	var params:String = req.paramas
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
	var res = function.call(params)
	
	
func test(s):
	var json = JSON.new()
	json.parse(s)
	var a = json.get_data()
	return {
		'id' : a['id'],
		'jsonrpc': a['jsonrpc'],
		'error':{'message' : '哈哈，这是开发过程中的测试'},
		'result':{'name':'刘备','payload':'关羽','children':{}}
	}