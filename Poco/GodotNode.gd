extends AbstractNode
class_name  GDNode

var node:Node = null


func _init(node:Node):
    node = node

func getParent():
    var parent = node.get_parent()
    if parent == null:
        return null
    return GDNode.new(parent)

func getChildren():
    var children = []
    for child in node.get_children():
        children.append(GDNode.new(child))
    return children

func getAvailableAttributeNames():
    var ret = [
        'text',
        'touchable',
        'enabled',
        'tag',
        'desc',
        'rotation',
        'rotation3D',
        'skew',
    ]
    for name in AbstractNode.new().getAvailableAttributeNames():
        ret.append(name)
    return ret


func getAttr(attrName:String):
    # 未来大修
    var dic = node.get_property_list()
    if dic.has(attrName):
        return dic.get(attrName)


func setAtrr(attrName,val):
    # return ERR_UNABLE_TO_SET_ATTRIBUTE 
    if attrName == 'text':
        node.text = val
        return true
    return AbstractNode.new().setAtrr(attrName,val)