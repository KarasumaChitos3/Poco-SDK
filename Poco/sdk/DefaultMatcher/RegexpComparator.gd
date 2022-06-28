extends Object
class_name RegexpComparator

func compare(origin, pattern):
    if origin == null or pattern == null:
        return false
    return pattern.search(origin) != null
    