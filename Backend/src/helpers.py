def intersection(iterableA, iterableB, key=lambda x: x):
    """Return the intersection of two iterables with respect to `key` function.

    """
    def unify(iterable):
        d = {}
        for item in iterable:
            d.setdefault(key(item), []).append(item)
        return d

    A, B = unify(iterableA), unify(iterableB)

    return [(A[k], B[k]) for k in A if k in B]

def has_food(text):
    print(text)
    with open('food.txt', 'r') as f:
        foods = f.read().splitlines()
    textList = text.split(' ')
    for index in range(len(textList)):
        if textList[index][-1] == 's':
            textList[index] = textList[index][:-1]

    if len(intersection(foods, textList, key=str.lower)) != 0:
        return True
    else:
        return False
