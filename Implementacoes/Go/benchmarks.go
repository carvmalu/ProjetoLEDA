//Funções responsáveis pelo cálculo do tempo de execução e consumo de memória
package main

import "testing"

// Testes de AddIndice no pior caso (adicionar no índice 0)
func BenchmarkAddIndiceArray(b *testing.B) {

    b.ReportAllocs()
    b.ResetTimer()

    for i := 0; i < b.N; i++ {

        da.AddIndice(0, 824)

        b.StopTimer()
        da.RemoveIndice(0)
        b.StartTimer()
    }
}

func BenchmarkAddIndiceSlice(b *testing.B) {

    b.ReportAllocs()
    b.ResetTimer()

    for i := 0; i < b.N; i++ {

        ds.AddIndice(0, 824)

        b.StopTimer()
        ds.RemoveIndice(0)
        b.StartTimer()
    }
}

// Teste de Search no pior caso (elemento não existente no slice)
func BenchmarkSearchArray(b *testing.B) {

    b.ReportAllocs()
    b.ResetTimer()

    for i := 0; i < b.N; i++ {
        da.Search(7)
    }
}

func BenchmarkSearchSlice(b *testing.B) {

    b.ReportAllocs()
    b.ResetTimer()

    for i := 0; i < b.N; i++ {
        ds.Search(7)
    }
}

// Teste de RemoveElement no pior caso (elemento não existe no slice)
func BenchmarkRemoveElementArray(b *testing.B) {

    b.ReportAllocs()
    b.ResetTimer()

    for i := 0; i < b.N; i++ {
        da.RemoveElemento(-79545)
    }

}

func BenchmarkRemoveElementSlice(b *testing.B) {

    b.ReportAllocs()
    b.ResetTimer()

    for i := 0; i < b.N; i++ {
        ds.RemoveElemento(-79545)
    }

}

// Testes de RemoveIndice no pior caso (remover no indice 0)
func BenchmarkRemoveIndiceArray(b *testing.B) {

    b.ReportAllocs()
    b.ResetTimer()

    for i := 0; i < b.N; i++ {

        da.RemoveIndice(0)

        b.StopTimer()
        da.AddIndice(0, -79545)
        b.StartTimer()
    }
}

func BenchmarkRemoveIndiceSlice(b *testing.B) {

    b.ReportAllocs()
    b.ResetTimer()

    for i := 0; i < b.N; i++ {

        ds.RemoveIndice(0)

        b.StopTimer()
        ds.AddIndice(0, -79545)
        b.StartTimer()
    }
}