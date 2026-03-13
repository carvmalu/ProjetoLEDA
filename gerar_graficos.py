"""
Script para gerar gráficos a respeito da comparação
da estrutura ArrayList (nativo e manual) em diferentes linguagens.
Os gráficos estão separados consumo de memória(bytes) e tempo(ms),
e pelos benchmarks utilizados para a comparação de desempenho. 
"""

import os
import pandas as pd
import matplotlib.pyplot as plt
import matplotlib.patches as mpatches
import numpy as np

# Caminhos para extrair

ARQUIVOS = {
    "CPP":     "Resultados/Cpp/resultadosC++_medias.csv",
    "Python":  "Resultados/Python/resultados.csv",
    "Go":      "Resultados/Go/go.csv",
    "Haskell": [
        "Resultados/Haskell/media_10000k.csv",
        "Resultados/Haskell/media_30000k.csv",
        "Resultados/Haskell/media_50000k.csv",
        "Resultados/Haskell/media_100000k.csv",
    ],
    "Java":    "Resultados/Java/JavaResults.csv",
}

# Normalização de operações

OPERACAO_MAP = {
    "adicaoinicio":  "adicaoInicio",
    "adicaoindice":  "adicaoInicio",   
    "busca":         "busca",
    "remocaoindice": "remocaoIndice",
    "remocaovalor":  "remocaoValor",
}

OPERACOES    = ["busca", "adicaoInicio", "remocaoIndice", "remocaoValor"]
TITULOS_OP   = {
    "busca":         "Busca",
    "adicaoInicio":  "Adição no Início",
    "remocaoIndice": "Remoção por Índice",
    "remocaoValor":  "Remoção por Valor",
}

TAMANHOS     = [10000, 30000, 50000, 100000]
LABELS_TAM   = {10000: "10k", 30000: "30k", 50000: "50k", 100000: "100k"}

# Séries e cores

SERIES = [
    "CPP_Manual",    "CPP_Nativo",
    "Python_Manual", "Python_Nativo",
    "Go_Manual",     "Go_Nativo",
    "Java_Manual",   "Java_Nativo",
    "Haskell_Manual",
]

CORES = {
    "CPP_Manual":     "#34D399",
    "CPP_Nativo":     "#059669",
    "Python_Manual":  "#60A5FA",
    "Python_Nativo":  "#2563EB",
    "Go_Manual":      "#D11261",
    "Go_Nativo":      "#E26484",
    "Java_Manual":    "#FB923C",
    "Java_Nativo":    "#F97316",
    "Haskell_Manual": "#C084FC",
}

ESTILO = {
    "fundo_figura": "#0F172A",
    "fundo_eixos":  "#1E293B",
    "texto":        "#F1F5F9",
    "grade":        "#334155",
    "borda_eixos":  "#475569",
}
# normalização

def detectar_sep(caminho):
    with open(caminho, "r", encoding="utf-8") as f:
        primeira = f.readline()
    return "," if primeira.count(",") >= primeira.count("\t") else "\t"


def normalizar_df(df):
    """Renomeia colunas para nomes canônicos e normaliza operações."""
    col_map = {}
    for col in df.columns:
        low = col.lower().replace(" ", "").replace("_", "").replace("(", "").replace(")", "")
        if low.startswith("linguagem") or (low.startswith("ling") and "tipo" in low):
            col_map[col] = "Linguagem_Tipo"
        elif low in ("tamanho", "size", "n"):
            col_map[col] = "Tamanho"
        elif "operac" in low or "operaç" in low or "operation" in low:
            col_map[col] = "Operacao"
        elif "tempo" in low or "time" in low:
            col_map[col] = "Tempo_ms"
        elif "memori" in low or "memory" in low or "mem" in low:
            col_map[col] = "Memoria_bytes"
    df = df.rename(columns=col_map)

    df["Operacao"] = (
        df["Operacao"]
        .str.strip()
        .str.lower()
        .map(OPERACAO_MAP)
    )
    df["Tamanho"]       = pd.to_numeric(df["Tamanho"],       errors="coerce")
    df["Tempo_ms"]      = pd.to_numeric(df["Tempo_ms"],      errors="coerce")
    df["Memoria_bytes"] = pd.to_numeric(df["Memoria_bytes"], errors="coerce")
    return df


def extrair_serie_key(linguagem_tipo: str) -> str:
    """
    Converte o campo Linguagem_Tipo para uma chave de série canônica.
    Exemplos:
      CPP_ArrayManual       → CPP_Manual
      CPP_ArrayNativo       → CPP_Nativo
      Python_ArrayManual    → Python_Manual
      Python_ArrayNativo    → Python_Nativo
      Go_ArrayManual        → Go_Manual
      Go_ArrayNativo        → Go_Nativo
      Java_ArrayListManual  → Java_Manual
      Java_ArrayListBuildIn → Java_Nativo   ← BuildIn tratado como Nativo
      Haskell_dataVector    → Haskell_Manual
    """
    lt = linguagem_tipo.lower()

    if lt.startswith("cpp"):       lang = "CPP"
    elif lt.startswith("python"):  lang = "Python"
    elif lt.startswith("go"):      lang = "Go"
    elif lt.startswith("java"):    lang = "Java"
    elif lt.startswith("haskell"): lang = "Haskell"
    else:                          lang = linguagem_tipo.split("_")[0]

    if lang == "Haskell":
        return "Haskell_Manual"

    if "buildin" in lt or "nativo" in lt or "native" in lt or "builtin" in lt:
        impl = "Nativo"
    else:
        impl = "Manual"

    return f"{lang}_{impl}"


def ler_csv(caminho):
    sep = detectar_sep(caminho)
    df  = pd.read_csv(caminho, sep=sep, engine="python", skipinitialspace=True)
    return normalizar_df(df)


def carregar_todos():
    frames = []
    for lang, arq in ARQUIVOS.items():
        arquivos_lista = arq if isinstance(arq, list) else [arq]
        existentes = [a for a in arquivos_lista if os.path.exists(a)]

        if not existentes:
            print(f"  ⚠  Arquivo não encontrado para {lang} — omitido dos gráficos.")
            continue

        try:
            dfs = []
            for a in existentes:
                dfs.append(ler_csv(a))
                if a not in arquivos_lista[:1]:
                    pass
            df = pd.concat(dfs, ignore_index=True)
            df["Serie"] = df["Linguagem_Tipo"].apply(extrair_serie_key)
            frames.append(df)
            series_enc = sorted(df["Serie"].unique())
            print(f"  ✔  {lang}: {len(df)} linhas | séries: {series_enc}")
        except Exception as e:
            print(f"  ✗  Erro ao ler {lang}: {e}")

    if not frames:
        raise RuntimeError("Nenhum CSV carregado.")
    return pd.concat(frames, ignore_index=True)

# extração de valores

def extrair_valores(df, operacao, metrica):
    col = "Tempo_ms" if metrica == "tempo" else "Memoria_bytes"
    sub = df[df["Operacao"] == operacao]
    resultado = {}
    for serie in SERIES:
        vals = []
        for tam in TAMANHOS:
            linha = sub[(sub["Serie"] == serie) & (sub["Tamanho"] == tam)]
            vals.append(float(linha[col].iloc[0]) if not linha.empty else 0.0)
        resultado[serie] = vals
    return resultado

# plotar

def plotar(dados, titulo, ylabel, nome_arquivo):
    series_ativas = SERIES

    n_grupos = len(TAMANHOS)
    n_barras = len(series_ativas)
    largura  = min(0.09, 0.72 / n_barras)
    x        = np.arange(n_grupos)
    offsets  = np.linspace(-(n_barras-1)/2, (n_barras-1)/2, n_barras) * largura

    fig, ax = plt.subplots(figsize=(16, 7))
    fig.patch.set_facecolor(ESTILO["fundo_figura"])
    ax.set_facecolor(ESTILO["fundo_eixos"])

    for i, serie in enumerate(series_ativas):
        cor     = CORES[serie]
        valores = dados[serie]
        barras  = ax.bar(x + offsets[i], valores, width=largura,
                         color=cor, alpha=0.90, zorder=3)
        for barra, val in zip(barras, valores):
            if val == 0:
                label = "0"
            elif val < 0.001:
                label = f"{val:.2e}"
            elif val < 0.01:
                label = f"{val:.4f}"
            elif val < 1:
                label = f"{val:.3f}"
            else:
                label = f"{val:.1f}"
            altura = barra.get_height() if val > 0 else 0
            ax.text(
                barra.get_x() + barra.get_width() / 2,
                altura * 1.012 + (0.002 if val == 0 else 0),
                label,
                ha="center", va="bottom",
                fontsize=5.8, color=cor, fontweight="bold", rotation=90,
            )

    ax.set_xticks(x)
    ax.set_xticklabels([LABELS_TAM[t] + " entradas" for t in TAMANHOS],
                       color=ESTILO["texto"], fontsize=12)
    ax.tick_params(axis="y", colors=ESTILO["texto"], labelsize=10)
    ax.set_ylabel(ylabel, fontsize=12, labelpad=10, color=ESTILO["texto"])
    ax.set_xlabel("Tamanho do Dataset", fontsize=12, labelpad=10, color=ESTILO["texto"])
    ax.grid(axis="y", color=ESTILO["grade"], linewidth=0.8, zorder=0)
    for spine in ax.spines.values():
        spine.set_edgecolor(ESTILO["borda_eixos"])
    ax.set_title(titulo, fontsize=15, fontweight="bold",
                 color=ESTILO["texto"], pad=18)

    patches = [mpatches.Patch(color=CORES[s], label=s.replace("_", " ")) for s in series_ativas]
    leg = ax.legend(handles=patches, loc="upper left", framealpha=0.25,
                    facecolor=ESTILO["fundo_eixos"], edgecolor=ESTILO["borda_eixos"],
                    labelcolor=ESTILO["texto"], fontsize=8.5, ncol=1,
                    title="Linguagem / Implementação", title_fontsize=9)
    leg.get_title().set_color(ESTILO["texto"])

    plt.tight_layout(pad=1.8)
    plt.savefig(nome_arquivo, dpi=160, bbox_inches="tight",
                facecolor=ESTILO["fundo_figura"])
    plt.close()

# main

METRICAS = [
    ("tempo",   "Tempo (ms)"),
    ("memoria", "Memória (bytes)"),
]
SLUGS_OP = {
    "busca":         "busca",
    "adicaoInicio":  "adicao_inicio",
    "remocaoIndice": "remocao_indice",
    "remocaoValor":  "remocao_valor",
}

if __name__ == "__main__":
    print("Carregando CSVs...\n")
    df = carregar_todos()
    print(f"\nTotal de linhas: {len(df)}")
    print(f"Operações:  {sorted(df['Operacao'].dropna().unique())}")
    print(f"Séries:     {sorted(df['Serie'].unique())}\n")

    print("Gerando gráficos...\n")
    for op in OPERACOES:
        for metrica, ylabel in METRICAS:
            tipo   = "Tempo de Execução" if metrica == "tempo" else "Uso de Memória"
            titulo = f"{TITULOS_OP[op]} — {tipo}"
            arq    = f"benchmark_{SLUGS_OP[op]}_{metrica}.png"
            plotar(extrair_valores(df, op, metrica), titulo, ylabel, arq)

