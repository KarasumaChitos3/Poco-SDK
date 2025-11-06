extends Node

const VERSION:String = '0.0.1'
var port:int = 5001

var _server:TCPServer = null

var socks: Array[StreamPeerTCP] = []
var rpc_handler:JSONRPC = null
var dumper:PocoDumper = null
func _init() -> void:
    pass

func _ready() -> void:
    _server = TCPServer.new()
    var err = _server.listen(port)
    if err != OK:
        printerr('[poco] server listen failed')
        printerr(err)
        return
    print('strat server success')
    print('[poco] server listens on tcp://*:%d' % port)

    dumper = PocoDumper.new()

    rpc_handler = JSONRPC.new()
    rpc_handler.set_method('Dump',dump)
    rpc_handler.set_method('GetSDKVersion',get_sdk_version)
    rpc_handler.set_method('GetScreenSize',get_scren_size)
    rpc_handler.set_method('Screenshot',take_a_screenshot)
    rpc_handler.set_method('GetDebugProfilingData',get_debug_profiling_data)



func _process(_delta: float) -> void:
    if _server.is_connection_available():
        var sock = _server.take_connection()
        socks.append(sock)
        print('[poco] client connect from %s' % sock.get_connected_host())
    for sock in socks:
        sock.poll()
        match sock.get_status():
            StreamPeerTCP.STATUS_CONNECTED:
                if sock.get_available_bytes() >= 4: receive(sock)
            StreamPeerTCP.STATUS_NONE,StreamPeerTCP.STATUS_ERROR:
                socks.erase.call_deferred(sock)
                print('[poco] client disconnect from %s' % sock.get_connected_host())

func receive(sock: StreamPeerTCP):
    var data_size = sock.get_32() # get 4 bytes data to determine the data size
    var payload = sock.get_utf8_string(data_size)
    var json = JSON.new()
    var error = json.parse(payload)
    
    if error == OK:
        var data_received = json.data
        if(typeof(data_received) != TYPE_DICTIONARY):
            print("意外数据")
        # print("S<-C ",data_received)
        var ret = rpc_handler.process_action(data_received)
        var ret_str = JSON.stringify(ret)
        var ret_buffer = ret_str.to_utf8_buffer()
        sock.put_32(ret_buffer.size())
        sock.put_data(ret_buffer)
        print("S->C ",ret_str)
    else:
        print("JSON 解析错误：", json.get_error_message(), " 位于 ", payload, " 行号 ", json.get_error_line())
        return


func dump(only_visible:bool = true):
    var ret = dumper.dump_hierarchy(only_visible)
    return ret

func get_sdk_version():
    return VERSION

func get_scren_size():
    return [DisplayServer.screen_get_size().x,DisplayServer.screen_get_size().y]

func take_a_screenshot(_empty_arg:Variant = null): 
    # This unused parameter is to accommodate incorrect calls in the official tools; 
    # otherwise, JSONRPC will not call this method.
    var buffer = get_viewport().get_texture().get_image().save_jpg_to_buffer()
    var base64_string = Marshalls.raw_to_base64(buffer)
    return [base64_string, "jpg"]

func get_debug_profiling_data():
    return {
        'dump':0,
        'screenshot':0,
        'packRpcResponse':0,
        'sendRpcResponse':0
    }