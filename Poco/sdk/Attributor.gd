extends Object
class_name Attributor

func getAttr(node, attrName):
    var node_ = node
    if typeof(node) == TYPE_ARRAY:
        node_ = node[0]
    return node_.getAttr(attrName)

func setAttr(node, attrName, attrVal):
    var node_ = node
    if typeof(node) == TYPE_ARRAY:
        node_ = node[0]
    node_ .setAttr(attrName, attrVal)