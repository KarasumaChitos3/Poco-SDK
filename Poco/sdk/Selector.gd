extends Object
class_name Selector

var dumper = null
var matcher = null

func _init(dumper, matcher = null):
    dumper = dumper
    matcher = matcher or DefaultMatcher.new()

func getRoot():
    return dumper.getRoot()

func select(cond, multiple = false):
    return null
    
func selectImpl(cond, multiple, root,maxDepth, onlyVisibleNode, includeRoot):
    var result = []
    if not root:
        return result

    var op = cond[0]
    var args = cond[1]

    if op in ['>', '/']:
        # children or offsprings
        # 父子直系相对节点选择
        var parents = [root]
        for index in range(args.size()):
            var arg = args[index]
            var midResult = []
            for parent in parents:
                var _maxDepth = null
                if op == '/' and index != 0:
                    _maxDepth = 1
                else:
                    _maxDepth = maxDepth
                # 按路径进行遍历一定要multiple为true才不会漏掉
                var _res = selectImpl(arg, true, parent, _maxDepth, onlyVisibleNode, false)
                for r in _res:
                    if r not in midResult:
                        midResult.append(r)
            parents = midResult
        result = parents
    elif op == '-':
        # sibling
        # 兄弟节点选择
        var query1 = args[0]
        var query2 = args[1]
        var result1 = selectImpl(query1, multiple, root, maxDepth, onlyVisibleNode, includeRoot)
        for n in result1:
            var sibling_result = selectImpl(query2, multiple, n.getParent(), 1, onlyVisibleNode, includeRoot)
            for r in sibling_result:
                if r not in result:
                    result.append(r)
    elif op == 'index':
        cond = args[0]
        var i = args[1]
        result = [selectImpl(cond, multiple, root, maxDepth, onlyVisibleNode, includeRoot)[i]]
    elif op == '^':
        # parent
        # only select parent of the first matched UI element
        var query1 = args[0]
        var result1 = selectImpl(query1, false, root, maxDepth, onlyVisibleNode, includeRoot)
        if result1:
            var parent_node = result1[0].getParent()
            if parent_node != null:
                result = [parent_node]
    else:
        _selectTraverse(cond, root, result, multiple, maxDepth, onlyVisibleNode, includeRoot)

    return result

func _selectTraverse(cond, node, outResult, multiple, maxDepth, onlyVisibleNode, includeRoot):
    
    if onlyVisibleNode and not node.getAttr('visible'):
        return false
    if matcher._match(cond, node):
        if includeRoot:
            if node not in outResult:
                outResult.append(node)
            if not multiple:
                return true

    if maxDepth == 0:
        return false
    maxDepth -= 1

    for child in node.getChildren():
        var finished = _selectTraverse(cond, child, outResult, multiple, maxDepth, onlyVisibleNode, true)
        if finished:
            return true

    return false