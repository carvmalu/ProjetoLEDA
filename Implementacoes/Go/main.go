package main

import (
	"encoding/csv"
	"fmt"
	"log"
	"os"
	"testing"
)

var numeros []int
var array DynamicArray
var slice DynamicSlice

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

	array = DynamicArray{Size: len(numeros), Capacity: len(numeros), Array: numeros}
	slice = DynamicSlice{Slice: numeros}

	// Estes são os resultados de cada um dos testes executados
	data := [][]string{
		{"Tipo", "Operacao", "Tempo(ms)", "Memoria(bytes)"},
		append([]string{"DynamicArray", "AddIndice"}, benchmarkFormat(BenchmarkAddIndiceArray)...),
		append([]string{"DynamicArray", "Search"}, benchmarkFormat(BenchmarkSearchArray)...),
		append([]string{"DynamicArray", "RemoveElement"}, benchmarkFormat(BenchmarkRemoveElementArray)...),
		append([]string{"DynamicArray", "RemoveIndice"}, benchmarkFormat(BenchmarkRemoveIndiceArray)...),
		append([]string{"DynamicSlice", "AddIndice"}, benchmarkFormat(BenchmarkAddIndiceSlice)...),
		append([]string{"DynamicSlice", "Search"}, benchmarkFormat(BenchmarkSearchSlice)...),
		append([]string{"DynamicSlice", "RemoveElement"}, benchmarkFormat(BenchmarkRemoveElementSlice)...),
		append([]string{"DynamicSlice", "RemoveIndice"}, benchmarkFormat(BenchmarkRemoveIndiceSlice)...),
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
	resultado := testing.Benchmark(f)
	tempo := float64(resultado.T.Nanoseconds()) / float64(resultado.N) / 1e6
	memoria := resultado.AllocedBytesPerOp()
	dados := []string{
		fmt.Sprintf("%.3f", tempo),
		fmt.Sprintf("%d", memoria),
	}

	return dados
}

// Testes de AddIndice no pior caso (adicionar no índice 0)
func BenchmarkAddIndiceArray(b *testing.B) {

	b.ReportAllocs()

	for i := 0; i < b.N; i++ {

		array.AddIndice(0, 824)

		b.StopTimer()
		array.RemoveIndice(0)
		b.StartTimer()
	}
}

func BenchmarkAddIndiceSlice(b *testing.B) {

	b.ResetTimer()

	for i := 0; i < b.N; i++ {

		slice.AddIndice(0, 824)

		b.StopTimer()
		slice.RemoveIndice(0)
		b.StartTimer()
	}
}

// Teste de Search no pior caso (elemento não existente no slice)
func BenchmarkSearchArray(b *testing.B) {

	b.ResetTimer()

	for i := 0; i < b.N; i++ {
		array.Search(7)
	}
}

func BenchmarkSearchSlice(b *testing.B) {

	b.ResetTimer()

	for i := 0; i < b.N; i++ {
		slice.Search(7)
	}
}

// Teste de RemoveElement no pior caso (elemento não existe no slice)
func BenchmarkRemoveElementArray(b *testing.B) {

	b.ResetTimer()

	for i := 0; i < b.N; i++ {
		array.RemoveElemento(7)
	}

}

func BenchmarkRemoveElementSlice(b *testing.B) {

	b.ResetTimer()

	for i := 0; i < b.N; i++ {
		slice.RemoveElemento(7)
	}

}

// Testes de RemoveIndice no pior caso (remover no indice 0)
func BenchmarkRemoveIndiceArray(b *testing.B) {

	b.ResetTimer()

	for i := 0; i < b.N; i++ {

		array.RemoveIndice(0)

		b.StopTimer()
		array.AddIndice(0, -79545)
		b.StartTimer()
	}
}

func BenchmarkRemoveIndiceSlice(b *testing.B) {

	b.ResetTimer()

	for i := 0; i < b.N; i++ {

		slice.RemoveIndice(0)

		b.StopTimer()
		slice.AddIndice(0, -79545)
		b.StartTimer()
	}
}

