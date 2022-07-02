extends AbstractDumper
class_name Dumper




func getRoot():
	# print('dumper里的getRoot')
	return GDNode.new(PocoManager.get_parent())

func dumpHierarchy(onlyVisibleNode:bool = true):
	# print('fuck you')
	return self.dumpHierarchyImpl(getRoot(), onlyVisibleNode)

	
