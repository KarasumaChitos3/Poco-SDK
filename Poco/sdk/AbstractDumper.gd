extends IDumper
class_name AbstractDumper


func dumpHierarchy(onlyVisibleNode:bool = true):
	return self.dumpHierarchyImpl(getRoot(), onlyVisibleNode)

func dumpHierarchyImpl(node,onlyVisibleNode:bool = true):
	if not node:
		return null
	
	var payload = node.enumerateAttrs()
	var result = {}
	var children = []
	for child in node.getChildren():
		if not onlyVisibleNode or child.getAttr('visible'):
			children.append(self.dumpHierarchyImpl(child, onlyVisibleNode))
	if len(children) > 0:
		result['children'] = children
	if payload.get('name'):
		result['name'] = payload.get('name')
	else:
		result['name'] = node.getAttr('name')
	result['payload'] = payload

	return result

