// Exemplo de comando: go -C run . Implementacoes/Go input/entrada.txt Resultados/ 10000,30000,50000,100000 10000
// Estrutura do comando: 
// go -C run . (para executar o go)
// Implementacoes/Go (caminho para os arquivos .go)
// input/entrada (caminho da raiz até o arquivo de entrada)
// Resultados/ (caminho da raiz até a pasta do arquivo .csv)
// 10000,30000,50000,100000 (tamanhos de entrada separados por ",")
// 10000 (número de runs)

package main

import (
	"bufio"
	"encoding/csv"
	"fmt"
	"log"
	"os"
	"reflect"
	"runtime"
	"strconv"
	"strings"
)

var numeros []int
var da DynamicArray
var ds DynamicSlice

func main() {

	// Recebendo os argumentos da linha de comando
	args := os.Args

	// Armazenando a entrada em uma lista
	entrada := fmt.Sprintf("../../" + args[1])
	arquivo, err := os.Open(entrada)
	if err != nil {
		fmt.Println("Erro ao abrir arquivo:", err)
		return
	}
	defer arquivo.Close()

	scanner := bufio.NewScanner(arquivo)
	scanner.Split(bufio.ScanWords)

	for scanner.Scan() {
		n, err := strconv.Atoi(scanner.Text())
		if err != nil {
			fmt.Println("Erro de conversão:", err)
			return
		}
		numeros = append(numeros, n)
	}

	// Definindo arquivo de saída
	saida := args[2]

	// Recebendo os tamanhos de entrada
	tamanhos := strings.Split(args[3], ",")

	// Recebendo o número de runs
	run, err := strconv.Atoi(args[4])
	if err != nil {
		fmt.Println("Erro na conversão:", err)
		return
	}
	runs = run

	// Funções/Benchmarks que serão testadas
	funcoes := []func() (float64, float64){adicaoIndiceArray, buscaArray,
		remocaoValorArray, remocaoIndiceArray,
		adicaoIndiceSlice, buscaSlice,
		remocaoValorSlice, remocaoIndiceSlice}

	// Armazenando os resultados
	data := [][]string{{"Linguagem_Tipo", "Tamanho", "Operacao", "Tempo(ms)", "Memoria(bytes)"}}

	// Executa as funções de cálculo de tempo de execução e memória
	for _, n := range tamanhos {
		num, err := strconv.Atoi(n)
		if err != nil {
			fmt.Println("Erro na conversão:", err)
			return
		}
		da = DynamicArray{num, num, numeros[:num]}
		for _, f := range funcoes[:4] {
			data = append(data, append([]string{"Go_DynamicArray", fmt.Sprintf(n)}, benchmarkFormat(f)...))
		}
		ds = DynamicSlice{numeros[:num]}
		for _, f := range funcoes[4:] {
			data = append(data, append([]string{"Go_DynamicSlice", fmt.Sprintf(n)}, benchmarkFormat(f)...))
		}
	}

	// Cria ou atualiza o arquivo go.csv
	file, err := os.Create("../../" + saida + "/go.csv")
	if err != nil {
		log.Fatalf("Erro ao criar arquivo: %s", err)
	}
	defer file.Close()

	writer := csv.NewWriter(file)
	defer writer.Flush()

	for _, value := range data {
		err := writer.Write(value)
		if err != nil {
			log.Fatalf("Erro ao escrever linha: %s", err)
		}
	}
}

// Formata o resultado das benchmarks
func benchmarkFormat(f func() (float64, float64)) []string {
	memoria, tempo := f()

	funcao := runtime.FuncForPC(reflect.ValueOf(f).Pointer()).Name()
	nomeFunc := strings.Split(funcao, ".")

	operacao := nomeFunc[len(nomeFunc)-1]
	operacao = strings.ReplaceAll(operacao, "Array", "")
	operacao = strings.ReplaceAll(operacao, "Slice", "")

	dados := []string{operacao, fmt.Sprintf("%.3f", tempo/1e3), fmt.Sprintf("%.0f", memoria)}

	return dados
}
