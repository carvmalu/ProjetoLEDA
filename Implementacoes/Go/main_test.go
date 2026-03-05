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

}

func BenchmarkAddA(b *testing.B) {
	inicialização()

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

func BenchmarkAddS(b *testing.B) {
	inicialização()

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

func BenchmarkAddIndiceA(b *testing.B) {
	inicialização()

	b.ReportAllocs()

	for i := 0; i < b.N; i++ {

		array.AddIndice(0, 824)

		array.RemoveIndice(0)
	}
}

func BenchmarkAddIndiceS(b *testing.B) {
	inicialização()

	b.ResetTimer()

	for i := 0; i < b.N; i++ {

		slice.AddIndice(0, 824)

		slice.RemoveIndice(0)
	}
}

func BenchmarkSearchA(b *testing.B) {
	inicialização()

	b.ResetTimer()

	for i := 0; i < b.N; i++ {
		array.Search(7)
	}
}

func BenchmarkSearchS(b *testing.B) {
	inicialização()

	b.ResetTimer()

	for i := 0; i < b.N; i++ {
		slice.Search(7)
	}
}

func BenchmarkRemoveA(b *testing.B) {
	inicialização()

	b.ResetTimer()

	for i := 0; i < b.N; i++ {
		array.Remove(7)
	}

}

func BenchmarkRemoveS(b *testing.B) {
	inicialização()

	b.ResetTimer()

	for i := 0; i < b.N; i++ {
		slice.Remove(7)
	}

}
func BenchmarkRemoveFirstA(b *testing.B) {
	inicialização()

	b.ResetTimer()

	for i := 0; i < b.N; i++ {

		array.Remove(-79545)

		array.AddIndice(0, -79545)
	}
}

func BenchmarkRemoveFirstS(b *testing.B) {
	inicialização()

	b.ResetTimer()

	for i := 0; i < b.N; i++ {

		slice.Remove(-79545)

		slice.AddIndice(0, -79545)
	}
}

//forma de rodar estes testes no terminal: go test -run=^$ -bench=. -benchmem