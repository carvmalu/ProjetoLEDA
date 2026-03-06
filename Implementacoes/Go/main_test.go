// forma de rodar estes testes no terminal: go test -run=^$ -bench=. -benchmem
package main

import (
	"fmt"
	"os"
	"strings"
	"testing"
)

func inicialização() {

	var temp int

	conteudo, err := os.ReadFile("../../input/entrada.txt")
	if err != nil {
		fmt.Println("Erro ao ler o arquivo:", err)
		return
	}

	reader := strings.NewReader(string(conteudo))

	for {
		_, err := fmt.Fscan(reader, &temp)
		if err != nil {
			break
		}
		numeros = append(numeros, temp)
	}

	array = DynamicArray{Size: len(numeros), Capacity: len(numeros), Array: numeros}
	slice = DynamicSlice{Slice: numeros}

}

func BenchmarkAddIndiceA(b *testing.B) {
	inicialização()

	b.ResetTimer()
	b.ReportAllocs()

	for i := 0; i < b.N; i++ {

		array.AddIndice(0, 824)

		b.StopTimer()
		array.RemoveIndice(0)
		b.StartTimer()
	}
}

func BenchmarkAddIndiceS(b *testing.B) {
	inicialização()

	b.ResetTimer()
	b.ReportAllocs()

	for i := 0; i < b.N; i++ {

		slice.AddIndice(0, 824)

		b.StopTimer()
		slice.RemoveIndice(0)
		b.StartTimer()
	}
}

func BenchmarkSearchA(b *testing.B) {
	inicialização()

	b.ResetTimer()
	b.ReportAllocs()

	for i := 0; i < b.N; i++ {
		array.Search(7)
	}
}

func BenchmarkSearchS(b *testing.B) {
	inicialização()

	b.ResetTimer()
	b.ReportAllocs()

	for i := 0; i < b.N; i++ {
		slice.Search(7)
	}
}

func BenchmarkRemoveA(b *testing.B) {
	inicialização()

	b.ResetTimer()
	b.ReportAllocs()

	for i := 0; i < b.N; i++ {
		array.RemoveElemento(7)
	}

}

func BenchmarkRemoveS(b *testing.B) {
	inicialização()

	b.ResetTimer()
	b.ReportAllocs()

	for i := 0; i < b.N; i++ {
		slice.RemoveElemento(7)
	}

}
func BenchmarkRemoveFirstA(b *testing.B) {
	inicialização()

	b.ResetTimer()
	b.ReportAllocs()

	for i := 0; i < b.N; i++ {

		array.RemoveIndice(0)

		b.StopTimer()
		array.AddIndice(0, -79545)
		b.StartTimer()
	}
}

func BenchmarkRemoveFirstS(b *testing.B) {
	inicialização()

	b.ResetTimer()
	b.ReportAllocs()

	for i := 0; i < b.N; i++ {

		slice.RemoveIndice(0)

		b.StopTimer()
		slice.AddIndice(0, -79545)
		b.StartTimer()
	}
}
