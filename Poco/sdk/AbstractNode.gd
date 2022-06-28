extends Node
class_name AbstractNode

func getParent():
    return null

func getChildren():
    # return ERR_NOT_IMPLEMENTED
    return ERR_PRINTER_ON_FIRE

func getAttr(attrName:String):
    var attrs = {
        'name': '<Root>',
        'type': 'Root',
        'visible': true,
        'pos': [0.0, 0.0],
        'size': [0.0, 0.0],
        'scale': [1.0, 1.0],
        'anchorPoint': [0.5, 0.5],
        'zOrders': {'local': 0, 'global': 0},
    }
    return attrs.get(attrName)

func setAtrr(attrName,val):
    # return ERR_UNABLE_TO_SET_ATTRIBUTE 
    return ERR_PRINTER_ON_FIRE

func getAvailableAttributeNames():
    return [    
        "name",
        "type",
        "visible",
        "pos",
        "size",
        "scale",
        "anchorPoint",
        "zOrders",
    ]

func enumerateAttrs():
    var attrs = {}
    for attrName in getAvailableAttributeNames():
        var attrVal = getAttr(attrName)
        if attrVal != null:
            attrs[attrName] = attrVal
    return attrs