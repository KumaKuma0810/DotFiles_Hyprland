grades = {"Alice": 5, "Bob": 3, "Charlie": 4}

res_rades = [x for k, v in grades.items() if v >= 4]
print(res_rades)