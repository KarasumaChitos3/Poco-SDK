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
	if attrName == 'zOrders':
		return {'local': 0, 'global': 1}
	elif attrName == 'pos':
		var tmp1 = node.get('posotion')
		if tmp1 != null:return [tmp1[0],tmp1[1]]
		else:return [0,0]
	elif attrName == 'anchorPoint':
		return [0,0]
	elif attrName == 'size':
		if node.get('size') != null:
			return [node.get('size')[0],node.get('size')[1]]
		else:
			return [10,10]

	

	# print(attrName,'  ', node.get(attrName), '  ',typeof(node.get(attrName)))
	var tmp = node.get(attrName)
	if typeof(tmp) == 5 or typeof(tmp) ==6:
		tmp = [tmp[0],tmp[1]]
	if tmp != null:
		return tmp


func setAtrr(attrName,val):
	# return ERR_UNABLE_TO_SET_ATTRIBUTE 
	if attrName == 'text':
		node.text = val
		return true
	return AbstractNode.new().setAtrr(attrName,val)
