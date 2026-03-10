// Funções responsáveis pelo cálculo do tempo de execução e consumo de memória
package main

import (
	"runtime"
	"time"
)

var runs int

// Testes de AddIndice no pior caso (adicionar no índice 0)
func adicaoIndiceArray() (float64, float64) {
	var tempo float64
	var memoria float64

	for i := 0; i < runs; i++ {

		runtime.GC()
		var memBefore, memAfter runtime.MemStats
		runtime.ReadMemStats(&memBefore)
		start := time.Now()

		da.AddIndice(0, 824)

		tempo += float64(time.Since(start).Microseconds())
		runtime.ReadMemStats(&memAfter)
		memoria += float64(memAfter.TotalAlloc - memBefore.TotalAlloc)

		da.RemoveIndice(0)
	}
	return memoria / float64(runs), tempo / float64(runs)
}

func adicaoIndiceSlice() (float64, float64) {
	var tempo float64
	var memoria float64

	for i := 0; i < runs; i++ {

		runtime.GC()
		var memBefore, memAfter runtime.MemStats
		runtime.ReadMemStats(&memBefore)
		start := time.Now()

		ds.AddIndice(0, 824)

		tempo += float64(time.Since(start).Microseconds())
		runtime.ReadMemStats(&memAfter)
		memoria += float64(memAfter.TotalAlloc - memBefore.TotalAlloc)

		ds.RemoveIndice(0)
	}
	return memoria / float64(runs), tempo / float64(runs)
}

// Teste de Search no pior caso (elemento não existente no slice)
func buscaArray() (float64, float64) {
	var tempo float64
	var memoria float64

	for i := 0; i < runs; i++ {
		runtime.GC()
		var memBefore, memAfter runtime.MemStats
		runtime.ReadMemStats(&memBefore)
		start := time.Now()

		da.Search(7)

		tempo += float64(time.Since(start).Microseconds())
		runtime.ReadMemStats(&memAfter)
		memoria += float64(memAfter.TotalAlloc - memBefore.TotalAlloc)
	}
	return memoria / float64(runs), tempo / float64(runs)
}

func buscaSlice() (float64, float64) {
	var tempo float64
	var memoria float64

	for i := 0; i < runs; i++ {
		runtime.GC()
		var memBefore, memAfter runtime.MemStats
		runtime.ReadMemStats(&memBefore)
		start := time.Now()

		ds.Search(7)

		tempo += float64(time.Since(start).Microseconds())
		runtime.ReadMemStats(&memAfter)
		memoria += float64(memAfter.TotalAlloc - memBefore.TotalAlloc)
	}
	return memoria / float64(runs), tempo / float64(runs)
}

// Teste de RemoveElement no pior caso (elemento não existe no slice)
func remocaoValorArray() (float64, float64) {
	var tempo float64
	var memoria float64

	for i := 0; i < runs; i++ {
		runtime.GC()
		var memBefore, memAfter runtime.MemStats
		runtime.ReadMemStats(&memBefore)
		start := time.Now()

		da.RemoveElemento(-79545)

		tempo += float64(time.Since(start).Microseconds())
		runtime.ReadMemStats(&memAfter)
		memoria += float64(memAfter.TotalAlloc - memBefore.TotalAlloc)

		da.AddIndice(0, -79545)
	}
	return memoria / float64(runs), tempo / float64(runs)
}

func remocaoValorSlice() (float64, float64) {
	var tempo float64
	var memoria float64

	for i := 0; i < runs; i++ {
		runtime.GC()
		var memBefore, memAfter runtime.MemStats
		runtime.ReadMemStats(&memBefore)
		start := time.Now()

		ds.RemoveElemento(-79545)

		tempo += float64(time.Since(start).Microseconds())
		runtime.ReadMemStats(&memAfter)
		memoria += float64(memAfter.TotalAlloc - memBefore.TotalAlloc)

		ds.AddIndice(0, -79545)
	}
	return memoria / float64(runs), tempo / float64(runs)
}

// Testes de RemoveIndice no pior caso (remover no indice 0)
func remocaoIndiceArray() (float64, float64) {
	var tempo float64
	var memoria float64

	for i := 0; i < runs; i++ {
		runtime.GC()
		var memBefore, memAfter runtime.MemStats
		runtime.ReadMemStats(&memBefore)
		start := time.Now()

		da.RemoveIndice(0)

		tempo += float64(time.Since(start).Microseconds())
		runtime.ReadMemStats(&memAfter)
		memoria += float64(memAfter.TotalAlloc - memBefore.TotalAlloc)

		da.AddIndice(0, -79545)
	}
	return memoria / float64(runs), tempo / float64(runs)
}

func remocaoIndiceSlice() (float64, float64) {
	var tempo float64
	var memoria float64

	for i := 0; i < runs; i++ {
		runtime.GC()
		var memBefore, memAfter runtime.MemStats
		runtime.ReadMemStats(&memBefore)
		start := time.Now()

		ds.RemoveIndice(0)

		tempo += float64(time.Since(start).Microseconds())
		runtime.ReadMemStats(&memAfter)
		memoria += float64(memAfter.TotalAlloc - memBefore.TotalAlloc)

		ds.AddIndice(0, -79545)
	}
	return memoria / float64(runs), tempo / float64(runs)
}
