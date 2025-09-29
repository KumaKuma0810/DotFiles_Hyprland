data = {"a": 1, "b": 2, "c": 3}

for k,v in data.items():
    res = dict()
    v = v * 10
    res = data[k, v]

print(res)