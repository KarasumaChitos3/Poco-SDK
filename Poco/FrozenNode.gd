extends Node
class_name ForzenNode

var node = null

func _init(node):
    node = node

func getAvailableAttributeNames():
    var ret = [
        '_instanceId'
    ]
    # for name in GNode:
    #     pass


func getAttr(attrName):
    if attrName == '_instanceId':
        return node.get_instance_id()
    return null

