extends IMatcher
class_name DefaultMatcher

var comparators = {}

func _init():
    comparators = {
        'attr=': EqualizationComparator.new(),
        'attr.*=': RegexpComparator.new(),
    }

func _match(cond, node):
    var op = cond[0]
    var args = cond[1]
    if op == 'and':
        for arg in args:
            if not _match(arg, node):
                return false
        return true
    if op == 'or':
        for arg in args:
            if _match(arg, node):
                return true
        return false

    var comparator = comparators.get(op)
    if comparator != null:
        var attribute = args[0]
        var value = args[1]
        var targetValue = node.getAttr(attribute)
        return comparator.compare(targetValue, value)
    