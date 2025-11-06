extends Object
class_name PocoDumper

func get_root() -> PocoNode:
    return PocoNode.new(Engine.get_main_loop().root)

func dump_hierarchy(only_visible:bool = true) -> Dictionary:
    return dump_hierachy_implementation(get_root(), only_visible)

func dump_hierachy_implementation(node:PocoNode, only_visible: bool) -> Dictionary:
        var ret = {}
        ret['name'] = node.get_attribute('name')
        var payload = node.enumerate_attributes()
        var children:Array[Dictionary] = []
        for child in node.get_children():
            if only_visible and not child.get_attribute('visible'):
                continue
            children.append(dump_hierachy_implementation(child, only_visible))
        if children.size() > 0:
            payload['children'] = children
        ret['payload'] = payload
        ret['visible'] = node.get_attribute('visible')
        return ret
