package main

import (
	"encoding/csv"
	"fmt"
	"log"
	"os"
	"reflect"
	"runtime"
	"strings"
	"testing"
)

var numeros []int
var da DynamicArray
var ds DynamicSlice

func main() {

	// Aramazena os valores passados no input em um slice
	var temp int

	for {
		_, err := fmt.Scan(&temp)
		if err != nil {
			break
		}
		numeros = append(numeros, temp)
	}

    // Tamanhos de entrada
	entradas := []int{10000, 30000, 50000, 100000}

    // Funções/Benchmarks que serão testadas
	funcoes := []func(b *testing.B){BenchmarkAddIndiceArray, BenchmarkSearchArray,
                                     BenchmarkRemoveElementArray, BenchmarkRemoveIndiceArray,
                                     BenchmarkAddIndiceSlice, BenchmarkSearchSlice,
                                     BenchmarkRemoveElementSlice, BenchmarkRemoveIndiceSlice}

    // Armazenando os resultados
	data := [][]string {{"Linguagem_Tipo", "Tamanho", "Operacao", "Tempo(ms)", "Memoria(bytes)"}}

	for _, n := range entradas {
		da = DynamicArray{n, n, numeros[:n]}
		for _, f := range funcoes[:4] {
			data = append(data, append([]string{"Go_DynamicArray", fmt.Sprintf("%d", n)}, benchmarkFormat(f)...))
		}
	}

	for _, n := range entradas {
		ds = DynamicSlice{numeros[:n]}
		for _, f := range funcoes[4:] {
			data = append(data, append([]string{"Go_DynamicSlice", fmt.Sprintf("%d", n)}, benchmarkFormat(f)...))
		}
	}

	// Cria ou atualiza o arquivo go.csv
	file, err := os.Create("../../Resultados/go.csv")
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
func benchmarkFormat(f func(b *testing.B)) []string {
	funcao := runtime.FuncForPC(reflect.ValueOf(f).Pointer()).Name()
	nomeFunc := strings.Split(funcao, ".")

    operacao := nomeFunc[len(nomeFunc)-1]
    operacao = strings.ReplaceAll(operacao, "Benchmark", "")
    operacao = strings.ReplaceAll(operacao, "Array", "")
    operacao = strings.ReplaceAll(operacao, "Slice", "")

	resultado := testing.Benchmark(f)
	tempo := float64(resultado.T.Nanoseconds()) / float64(resultado.N) / 1e6
	memoria := resultado.AllocedBytesPerOp()

	dados := []string{operacao, fmt.Sprintf("%.3f", tempo), fmt.Sprintf("%d", memoria)}

	return dados
}
