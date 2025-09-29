words = ["apple", "banana", "pear", "kiwi", "plum"]
res_word = []

res_word = [w for w in words if len(w) >= 4]
print(res_word)