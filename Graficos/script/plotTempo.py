# python3 -m venv Graficos/script/venv
# source Graficos/script/venv/bin/activate (No Windows é venv\Scripts\activate)
# pip install -r Graficos/script/requirements.txt
# python Graficos/script/plotTempo.py

import matplotlib.pyplot as plt
import csv

# Lê os dados do arquivo .csv e retorna o tamanho da entrada e o tempo de execução
def carregar_dados(nome_arquivo, estrutura, operacao):
    x = []
    y = []
    with open(nome_arquivo, 'r') as arquivo:
        leitor = csv.reader(arquivo)
        next(leitor)
        for linha in leitor:
            if estrutura in linha[0] and operacao in linha[2]: 
                x.append(float(linha[1])) 
                y.append(float(linha[3]))
    return x, y

# Cria a linha com estas informações no gráfico
def criar_linha(linguagem, estrutura, metodo):
    x, y = carregar_dados('Resultados/' + linguagem + '.csv', estrutura, metodo)
    plt.plot(x, y, label=linguagem, marker='o')

linguagens = ["go"]
estruturas = ["ArrayManual", "ArrayNativo"]
operacoes = ["adicaoIndice", "busca", "remocaoValor", "remocaoIndice"]

# Cria um arquivo png para cada gráfico
for op in operacoes:
    plt.figure() 
    for es in estruturas:
        for l in linguagens: 
            criar_linha(l, es, op)

            plt.title("Tempo de execução do " + es + " em " + op)
            plt.xlabel('Tamanho de entrada')
            plt.ylabel('Tempo de execução(ms)')
            plt.legend()
            plt.grid(True)

        plt.savefig('Graficos/tempo_' + es + "_" + op + '.png')
        plt.close()
