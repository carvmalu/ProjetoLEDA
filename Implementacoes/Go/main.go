package main

import (
	"encoding/csv"
	"fmt"
	"log"
	"os"
	"reflect"
	"runtime"
	"strings"
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
	funcoes := []func() (float64, float64) {AdicionaIndiceArray, BuscaArray,
                                            RemoveElementoArray, RemoveIndiceArray,
                                            AdicionaIndiceSlice, BuscaSlice,
                                            RemoveElementoSlice, RemoveIndiceSlice}

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
func benchmarkFormat(f func() (float64, float64)) []string {
	memoria, tempo := f()

	funcao := runtime.FuncForPC(reflect.ValueOf(f).Pointer()).Name()
	nomeFunc := strings.Split(funcao, ".")

    operacao := nomeFunc[len(nomeFunc)-1]
    operacao = strings.ReplaceAll(operacao, "Array", "")
    operacao = strings.ReplaceAll(operacao, "Slice", "")

	dados := []string{operacao, fmt.Sprintf("%.3f", tempo / 1e3), fmt.Sprintf("%.0f", memoria)}

	return dados
}
