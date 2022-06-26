extends RefCounted
class_name PocoClient


var DEBUG:bool = false
var sock:StreamPeerTCP = null
var buf:String = ''
var sendbuf:String = ''


func _init(sock:StreamPeerTCP,debug:bool = false):
    sock = sock
    DEBUG = debug

func input(data:String) :
    buf = buf + data
    var ret = []
    return data

func receive():
    pass

func send(data):
    var json = JSON.new()
    var data_to_send = json.stringify(data)
    if DEBUG:
        print(data_to_send)
    sock.put_utf8_string(data_to_send)