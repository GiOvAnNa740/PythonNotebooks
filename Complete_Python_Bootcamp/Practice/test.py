from itertools import product

items = ['A','B']

for item in product(items, repeat=4):
    print(item)
##!
#('A', 'A', 'A', 'A')
#('A', 'A', 'A', 'B')
#('A', 'A', 'B', 'A')
#('A', 'A', 'B', 'B')
#('A', 'B', 'A', 'A')
#('A', 'B', 'A', 'B')
#('A', 'B', 'B', 'A')
#('A', 'B', 'B', 'B')
#('B', 'A', 'A', 'A')
#('B', 'A', 'A', 'B')
#('B', 'A', 'B', 'A')
#('B', 'A', 'B', 'B')
#('B', 'B', 'A', 'A')
#('B', 'B', 'A', 'B')
#('B', 'B', 'B', 'A')
#('B', 'B', 'B', 'B')