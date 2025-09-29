words = ["apple", "banana", "apple", "orange", "banana", "kiwi"]

def count_words(lst):
    res_lst = 0
    for item in lst:
        if lst[item] == item:
            print(item)
    
count_words(words)
