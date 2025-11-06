extends Object
class_name PocoNode

var proxy_node :Node = null

func _init(proxy_node:Node) -> void:
    self.proxy_node = proxy_node

func get_parent() -> PocoNode:
    return PocoNode.new(proxy_node.get_parent())

func get_children() -> Array[PocoNode]:
    var children :Array[PocoNode] = []
    for child in proxy_node.get_children():
        children.append(PocoNode.new(child))
    return children

func enumerate_attributes() -> Dictionary:
    var attributes = {}
    # for key in proxy_node.get_property_list():
    #     attributes[key.name] = proxy_node.get(key.name)
    attributes['name'] = proxy_node.get('name')
    attributes['visible'] = attributes.get('visible') if attributes.get('visible') else true
    attributes['pos'] =[proxy_node.get('global_position').x, proxy_node.get('global_position').y] if proxy_node.get('global_position') else [0,0]
    attributes['size'] =[proxy_node.get('size').x, proxy_node.get('size').y] if proxy_node.get('size') else [0,0]
    attributes['scale'] =[proxy_node.get('scale').x, proxy_node.get('scale').y] if proxy_node.get('scale') else [1,1]
    attributes['anchorPoint'] = [0,5,0,5]
    attributes['zOrders'] = {"global":0, "local":0}



    return attributes

func get_attribute(name:String) -> Variant:
    if name == 'visible':
        return proxy_node.get('visible') or false
    return proxy_node.get(name)
