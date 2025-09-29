words = ["apple", "banana", "apple", "orange", "banana", "kiwi"]

def count_words(lst):
    res_lst = 0
    for item in lst:
        if item == lst[-1]:
            res_lst +=1
            print(f' {int(lst[item])} - {res_lst} раз')
        else:
            print('Non')
    
count_words(words)
