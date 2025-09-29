people = [
    {"name": "Alice", "age": 25},
    {"name": "Bob", "age": 30},
    {"name": "Charlie", "age": 25},
    {"name": "David", "age": 30},
    {"name": "Eve", "age": 35}
]

def group_by_age(people):
    res = {}
    
    for p in people:
        print(p)
    
group_by_age(people)