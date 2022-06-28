extends AbstractDumper
class_name Dumper




func getRoot():
	print('dumper里的getRoot')
	return PocoManager.get_tree().get_root()

func dumpHierarchy(onlyVisibleNode:bool = true):
	print('fuck you')
	return self.dumpHierarchyImpl(getRoot(), onlyVisibleNode)

	
