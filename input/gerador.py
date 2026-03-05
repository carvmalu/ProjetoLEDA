import random

#aqui o número 7 é utilizado para os piores casos, pois ele não estará presente na entrada
n = 7
sorteio = 7

for i in range(100000):
    while sorteio == n:
        sorteio = random.randint(-100000, 100000)
    print(sorteio, end = " ")
    sorteio = 7
