# https://pt.stackoverflow.com/questions/547418/como-ler-arquivos-csv-usando-python-e-plotar-gr%C3%A1ficos
import csv
import matplotlib.pyplot as plt
import numpy as np

# Arquivos CSV de cada linguagem
arquivos = {
    "Haskell": "Resultados/Haskell/media_300x_100k.csv",
    "Java": "Resultados/Java/resultados.csv",
    "Python": "Resultados/Python/resultados.csv",
    "C++": "Resultados/C++/resultados.csv",
    "Go": "Resultados/Golang/resultados.csv"
}

# Cores por linguagem
cores = {
    "Haskell": "#1938e9",
    "Java": "#6cf1b3",
    "Python": "#AF11A7",
    "C++": "#fb6340",
    "Go": "#deeb2d"
}

# Dicionário para armazenar dados
dados = {}

# Ler cada arquivo CSV
for linguagem, arquivo in arquivos.items():
    operacoes = []
    tempos = []
    
    try:
        with open(arquivo, "r") as file:
            leitor = csv.reader(file, delimiter=",")
            next(leitor)  # Pula o header
            
            for linha in leitor:
                operacao = linha[2]  # Coluna 3: Operacao
                tempo = float(linha[3])  # Coluna 4: Tempo(ms)
                
                operacoes.append(operacao)
                tempos.append(tempo)
        
        dados[linguagem] = {"operacoes": operacoes, "tempos": tempos}
    except FileNotFoundError:
        print(f"Arquivo não encontrado: {arquivo}")

# Criar gráfico com todas as linguagens
plt.figure(figsize=(14, 8))

# Largura das barras
largura = 0.15
indice = np.arange(len(dados[list(dados.keys())[0]]["operacoes"]))

# Plotar barras para cada linguagem
for i, (linguagem, cor) in enumerate(cores.items()):
    if linguagem in dados:
        deslocamento = (i - 2) * largura
        plt.bar(indice + deslocamento, dados[linguagem]["tempos"], 
                largura, label=linguagem, color=cor)

# Configurar gráfico
plt.xlabel('Operações', fontsize=12, fontweight='bold')
plt.ylabel('Tempo (ms)', fontsize=12, fontweight='bold')
plt.title('Comparação de Performance - 100k elementos', fontsize=14, fontweight='bold')
plt.xticks(indice, dados[list(dados.keys())[0]]["operacoes"], rotation=45)
plt.legend(fontsize=10)
plt.tight_layout()
plt.grid(axis='y', alpha=0.3)

# Salvar gráfico
plt.savefig('grafico_comparacao_100k.png', dpi=300)
plt.show()