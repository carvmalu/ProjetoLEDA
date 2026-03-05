package main

import (
	"encoding/csv"
	"fmt"
	"log"
	"os"
	"runtime"
	"runtime/debug"
	"testing"
)

var numeros []int
var array DynamicArray
var slice DynamicSlice

func main() {
	runtime.GOMAXPROCS(runtime.NumCPU())
	debug.FreeOSMemory()

	file, err := os.Create("../../Resultados/Go/resultadosGo.csv")
	if err != nil {
		log.Fatalf("Erro ao criar arquivo: %s", err)
	}
	defer file.Close()

	writer := csv.NewWriter(file)
	defer writer.Flush()

	var temp int

	for {
		_, err := fmt.Scan(&temp)
		if err != nil {
			break
		}
		numeros = append(numeros, temp)
	}

	data := [][]string {
		{"Tipo", "Teste de Método", "Tempo µs", "Bytes"},
		append([]string{"DynamicArray", "Add"}, benchmarkFormat(array.BenchmarkAddArray)...),
		append([]string{"DynamicArray", "AddIndice"}, benchmarkFormat(array.BenchmarkAddIndiceArray)...),
		append([]string{"DynamicArray", "Search"}, benchmarkFormat(array.BenchmarkSearchArray)...),
		append([]string{"DynamicArray", "Remove"}, benchmarkFormat(array.BenchmarkRemoveArray)...),
		append([]string{"DynamicArray", "RemoveFirst"}, benchmarkFormat(array.BenchmarkRemoveFirstArray)...),
		append([]string{"DynamicSlice", "Add"}, benchmarkFormat(slice.BenchmarkAddSlice)...),
		append([]string{"DynamicSlice", "AddIndice"}, benchmarkFormat(slice.BenchmarkAddIndiceSlice)...),
		append([]string{"DynamicSlice", "Search"}, benchmarkFormat(slice.BenchmarkSearchSlice)...),
		append([]string{"DynamicSlice", "Remove"}, benchmarkFormat(slice.BenchmarkRemoveSlice)...),
		append([]string{"DynamicSlice", "RemoveFirst"}, benchmarkFormat(slice.BenchmarkRemoveFirstSlice)...),
	}

	for _, value := range data {
		err := writer.Write(value)
		if err != nil {
			log.Fatalf("Erro ao escrever linha: %s", err)
		}
	}

}

func benchmarkFormat(f func (b *testing.B)) []string {
	resultado := testing.Benchmark(f)
	tempo := float64(resultado.T.Nanoseconds()) / float64(resultado.N) / 1e3
	memoria := resultado.AllocedBytesPerOp()
	dados := []string{
		fmt.Sprintf("%.4f", tempo),
		fmt.Sprintf("%d", memoria),
	}

	return dados
}

func (array DynamicArray) BenchmarkAddArray(b *testing.B) {

	b.ResetTimer()

	for i := 0; i < b.N; i++ {
		b.StopTimer()
		tempArray := DynamicArray{Size: 0, Capacity: 0, Array: []int{}}
		b.StartTimer()

		for _, num := range numeros {
			tempArray.Add(num)
		}
	}

}

func (slice *DynamicSlice) BenchmarkAddSlice(b *testing.B) {

	b.ResetTimer()

	for i := 0; i < b.N; i++ {
		b.StopTimer() // Para o cronômetro
		tempSlice := DynamicSlice{Slice: []int{}}
		b.StartTimer()

		for _, num := range numeros {
			tempSlice.Add(num)
		}
	}

}

func (array *DynamicArray) BenchmarkAddIndiceArray(b *testing.B) {

	b.ReportAllocs()

	for i := 0; i < b.N; i++ {

		array.AddIndice(0, 824)

		array.RemoveIndice(0)
	}
}

func (slice *DynamicSlice) BenchmarkAddIndiceSlice(b *testing.B) {

	b.ResetTimer()

	for i := 0; i < b.N; i++ {

		slice.AddIndice(0, 824)

		slice.RemoveIndice(0)
	}
}

func (array *DynamicArray) BenchmarkSearchArray(b *testing.B) {

	b.ResetTimer()

	for i := 0; i < b.N; i++ {
		array.Search(7)
	}
}

func (slice *DynamicSlice) BenchmarkSearchSlice(b *testing.B) {

	b.ResetTimer()

	for i := 0; i < b.N; i++ {
		slice.Search(7)
	}
}

func (array *DynamicArray) BenchmarkRemoveArray(b *testing.B) {

	b.ResetTimer()

	for i := 0; i < b.N; i++ {
		array.Remove(7)
	}

}

func (slice *DynamicSlice) BenchmarkRemoveSlice(b *testing.B) {

	b.ResetTimer()

	for i := 0; i < b.N; i++ {
		slice.Remove(7)
	}

}
func (array *DynamicArray) BenchmarkRemoveFirstArray(b *testing.B) {

	b.ResetTimer()

	for i := 0; i < b.N; i++ {

		array.Remove(-79545)

		array.AddIndice(0, -79545)
	}
}

func (slice *DynamicSlice) BenchmarkRemoveFirstSlice(b *testing.B) {

	b.ResetTimer()

	for i := 0; i < b.N; i++ {

		slice.Remove(-79545)

		slice.AddIndice(0, -79545)
	}
}

//forma de rodar estes testes no terminal: go test -run=^$ -bench=. -benchmem
