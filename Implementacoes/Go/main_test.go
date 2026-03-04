package main

import (
	"fmt"
	"os"
	"strings"
	"testing"
)

var numeros []int
var array DynamicArray
var slice DynamicSlice

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

func BenchmarkAddArray(b *testing.B) {
	inicialização()

	b.ReportAllocs()

	for i := 0; i < b.N; i++ {
		array = DynamicArray{Size: 0, Capacity: 0, Array: []int{}}

		for _, num := range numeros{
			array.Add(num)
		}
	}

}

func BenchmarkAddSlice(b *testing.B) {
	inicialização()

	b.ResetTimer()

	for i := 0; i < b.N; i++ {
		slice := DynamicSlice{Slice: []int{}}

		for _, num := range numeros{
			slice.Add(num)
		}
	}

}

func BenchmarkSearchArray(b *testing.B) {
	inicialização()

	b.ResetTimer()

	for i := 0; i < b.N; i++ {
		array.Search(7)
	}
}

func BenchmarkSearchSlice(b *testing.B) {
	inicialização()

	b.ResetTimer()

	for i := 0; i < b.N; i++ {
		slice.Search(7)
	}
}

func BenchmarkRemoveArray(b *testing.B) {
	inicialização()

	b.ResetTimer()

	for i := 0; i < b.N; i++ {
		array.Remove(7)
	}

}

func BenchmarkRemoveSlice(b *testing.B) {
	inicialização()

	b.ResetTimer()

	for i := 0; i < b.N; i++ {
			slice.Remove(7)
	}

}
func BenchmarkRemoveFirstArray(b *testing.B) {
	inicialização()

	b.ResetTimer()

	for i := 0; i < b.N; i++ {
		b.StopTimer()

        array = DynamicArray{Size: 0, Capacity: 0, Array: []int{}}
        for _, num := range numeros {
            array.Add(num)
        }

        b.StartTimer()

		array.Remove(-79545)
	}
}

func BenchmarkRemoveFirstSlice(b *testing.B) {
	inicialização()

	b.ResetTimer()

	for i := 0; i < b.N; i++ {
		b.StopTimer()

        slice := DynamicSlice{Slice: []int{}}
        for _, num := range numeros {
            slice.Add(num)
        }

        b.StartTimer()
		
		slice.Remove(-79545)
	}
}

//forma de rodar estes testes no terminal: go test -run=^$ -bench=. -benchmem



