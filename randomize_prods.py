import random

options1 = ["ОНИГИРИ", "БУТЕРБРОД", "СЭНДВИЧ", "БУЛОЧКА", "ЧЕ_ТО"]
options2 = ["СЛИВ_КРАБ", "ХАХАХАХАХАХАХАХАХХА", "КУРИЦА", "СМАК", "НЕ_ЗНАЮ_ЧЕ_ЕЩЁ_НАПИСАТ"]
options3 = ["ИВАНУШКИ", "ДЕЛЬЦЫ", "ТОРГОВЦЫ", "МЕРЧАНТЫ", "ФАРМИЛЫ"]
options4 = ["ИНТЕРНЕШНЛ", "УСТРИЦ", "ЗА_ЗАБОРОМ", "ХАХАХАХА", "НЕ_ЗНАЮ_ЧЕ_ЕЩЁ_НАПИСАТ"]
months = ["JAN", "FEB", "MAR", "APR", "MAY", "JUN", "JUL", "AUG", "SEP", "OCT", "NOV", "DEC"]
prod_codes = []
ord_codes = []

f = open("products_test.txt", "w")
for i in range(91):
    s = ""
    prod_codes.append(random.randint(1, 99999999))
    s += str(prod_codes[i])
    s += " "*(8-len(s)) + "|"
    s += options1[random.randint(0, len(options1)-1)] + "_" + options2[random.randint(0, len(options2)-1)]
    s += " "*(32-len(s)+9) + "|"
    s += str(random.randint(0, 9999999)) + "." + str(random.randint(10, 99))
    s += " "*(10-len(s)+33+9) + "|"
    f.write(s + '\n')
f.close()

d = dict()
f = open("orders_test.txt", "w")
for i in range(91):
    s = ""
    a = random.randint(1, 99999999)
    d[a] = []
    ord_codes.append(a)
    s += str(a)
    s += " "
    s += options3[random.randint(0, len(options3)-1)] + "_" + options4[random.randint(0, len(options4)-1)]
    s += " "
    s += "7" + str(random.randint(0, 9999999999))
    s += " "
    s += str(random.randint(10, 31))
    s += " "
    s += months[random.randint(0, len(months)-1)]
    s += " "
    s += str(random.randint(2000, 2099))
    s += " "
    c = 0
    for i in range(random.randint(1, 25)):
        b = random.randint(0, 90)
        if c > prod_codes[b]:
            continue
        s += str(prod_codes[b])
        c = prod_codes[b]
        d[a].append(prod_codes[b])
        s += " "
        s += str(random.randint(0, 99999999))
        s += " "
    f.write(s.rstrip() + '\n')
f.close()

f = open("shipments_test.txt", "w")
for i in range(91):
    s = ""
    s += str(random.randint(10, 31))
    s += " "
    s += months[random.randint(0, len(months)-1)]
    s += " "
    s += str(random.randint(2000, 2099))
    s += " "
    a = ord_codes[random.randint(0, len(ord_codes)-1)]
    s += str(a)
    s += " "
    for i in range(len(d[a])):
        s += str(d[a][i])
        s += " "
        s += str(random.randint(0, 99999999))
        s += " "
    f.write(s.rstrip() + '\n')
f.close()