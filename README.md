# Proposta de Projeto

Esse repositório contém os arquivos utilizados na experimentação sobre a comparação de desempenho entre diferentes linguagens de programação, tendo como base a implementação de arrays dinâmicos e a execução de benchmarks padronizados.

## Equipe
- Camila Gomes dos Santos — 124211420  
- Laís Ferreira Lira — 124211095  
- Maria Luísa Costa Carvalho — 124211648  
- Natália Rodrigues da Silva — 124211389  
- Raissa Tainá Pordeus Ferreira — 124211908  

## Resumo
O projeto consiste em uma análise comparativa e experimental de desempenho entre diferentes linguagens de programação, baseada na implementação de arrays dinâmicos.

A proposta central não é eleger uma linguagem como superior, mas sim investigar e compreender como as distintas arquiteturas internas das linguagens, com diferentes níveis de abstração e modos de execução (compiladas ou interpretadas), impactam a eficiência computacional quando submetidas a condições idênticas de estresse.

A análise será fundamentada nas seguintes métricas:

- tempo de execução das operações fundamentais (inserção, busca e remoção)
- consumo de memória (Heap e Stack)

Através de testes padronizados com entradas de diferentes tamanhos e cenários de pior caso, o trabalho busca interpretar tecnicamente os resultados obtidos e correlacioná-los aos contextos em que cada linguagem se sobressai devido ao seu comportamento interno e paradigma de execução.

## Motivação
A relevância deste projeto reside na necessidade de compreender como diferentes arquiteturas de linguagens impactam diretamente o custo computacional em larga escala.

Em um cenário onde eficiência e velocidade de resposta são cruciais, entender o comportamento de estruturas de dados em diferentes ecossistemas fornece dados úteis para:

- análise de desempenho de sistemas
- decisões de arquitetura de software
- estudo de escalabilidade em aplicações com grandes volumes de dados

## Metodologia

Com o objetivo de examinar o desempenho de arrays dinâmicos em tempo de execução e consumo de memória para diferentes linguagens de programação, o estudo é conduzido por meio de uma abordagem experimental e comparativa, cujas etapas principais envolvem:

- implementação da estrutura de dados em cada uma das linguagens analisadas;
- execução de benchmarks tanto para a estrutura implementada manualmente quanto para estruturas que utilizam recursos nativos das linguagens;
- coleta das métricas de desempenho;
- representação dos resultados por meio de gráficos;
- análise e interpretação dos dados obtidos.

As linguagens utilizadas no experimento são:

- Python
- Java
- C++
- Haskell
- Go

Considerando as diferenças entre essas linguagens, todas as implementações seguem a mesma lógica estrutural e são executadas sob as mesmas condições de teste, garantindo que a comparação seja feita de forma mais justa.

## Geração de Dados de Entrada

As entradas são geradas por meio de um script que utiliza a função randint da biblioteca random da linguagem Python.

Características da entrada utilizada nos experimentos:

- 100.000 valores inteiros
- números aleatórios no intervalo entre -100.000 e 100.000

Para a realização de testes de pior caso, o valor 7 foi removido da sequência gerada. Dessa forma, operações como busca podem ser executadas procurando um elemento inexistente, forçando a estrutura a percorrer todos os elementos.

## Distribuição das Linguagens por Integrante

| Integrante | Linguagem |
|------------|-----------|
| Camila | Python |
| Laís | Java |
| Maria Luísa | Haskell |
| Natália | Go |
| Raissa | C++ |

Cada integrante é responsável pela implementação da estrutura de dados na linguagem atribuída, execução dos benchmarks, análise dos resultados e documentação correspondente.

## Comandos para executar o experimento

Para executar todos os benchmarks de uma só vez:

```
chmod +x input/comandos.sh && ./input/comandos.sh

```

Para gerar os gráficos atualizados com os resultados:

```
python gerar_graficos.py

```

### Artefatos de Entrega

Além deste repositório, o projeto também possui um relatório completo de análise experimental, contendo a descrição detalhada da metodologia, análise dos resultados obtidos e referências utilizadas.

Link do relatório:
https://docs.google.com/document/d/1AZMmW-bYlDqWOUMPmu8KvXaEFI5ZxfQisdtQT_UZ9nc/edit?tab=t.0
