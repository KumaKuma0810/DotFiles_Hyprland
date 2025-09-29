data = {"a": 1, "b": 2, "c": 3}

for k,v in data.items():
    res = dict()
    res = data[k, v*=10]

print(res)