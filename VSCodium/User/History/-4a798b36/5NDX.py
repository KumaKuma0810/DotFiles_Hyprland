data = {"a": 1, "b": 2, "c": 3}
res = {}
for k,v in data.items():
    res = data[k, v*=10]

print(res)