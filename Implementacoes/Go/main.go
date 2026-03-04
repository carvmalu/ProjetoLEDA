package main

import (
	"fmt"
	"runtime"
	"time"
)

func main() {

	var numeros []int
	var temp int

	for {
    	_, err := fmt.Scan(&temp)
    	if err != nil {
        	break
    	}
    	numeros = append(numeros, temp)
	}

	array := DynamicArray{Size: 0, Capacity: 0, Array: []int{}}
	slice := DynamicSlice{Slice: []int{}}

	//Métodos de adição

		//Adição no array dinâmico
		startadd := time.Now()
		var ma runtime.MemStats
    	runtime.ReadMemStats(&ma)

		for _, num := range numeros{
			array.Add(num)
		}

		var m2 runtime.MemStats
    	runtime.ReadMemStats(&m2)
		elapsed := time.Since(startadd)

		fmt.Printf("Tempo de execução da adição no array dinâmico: %s\n", elapsed)
		fmt.Printf("Memória Alocada: %d KB\n", (m2.Alloc-ma.Alloc)/1024)

		//Adição no slice dinâmico
		startadd = time.Now()
		var mb runtime.MemStats
    	runtime.ReadMemStats(&mb)

		for _, num := range numeros{
			slice.Add(num)
		}

		elapsed = time.Since(startadd)
		runtime.ReadMemStats(&m2)
		elapsed = time.Since(startadd)

		fmt.Printf("Tempo de execução da adição no slice: %s\n", elapsed)
		fmt.Printf("Memória Alocada: %d KB\n", (m2.Alloc-mb.Alloc)/1024)

	//Métodos de busca no pior caso (elemento não existente no slice)
	
		//Busca no array dinâmico
		startadd = time.Now()
		var mc runtime.MemStats
    	runtime.ReadMemStats(&mc)
		
		array.Search(7)

		elapsed = time.Since(startadd)
		runtime.ReadMemStats(&m2)
		elapsed = time.Since(startadd)

		fmt.Printf("Tempo de execução da busca de um elemento inexistente no array: %s\n", elapsed)
		fmt.Printf("Memória Alocada: %d KB\n", (m2.Alloc-mc.Alloc)/1024)

		startadd = time.Now()
		var md runtime.MemStats
    	runtime.ReadMemStats(&md)

		//Busca no slice dinâmico
		slice.Search(7)

		elapsed = time.Since(startadd)
		runtime.ReadMemStats(&m2)
		elapsed = time.Since(startadd)

		fmt.Printf("Tempo de execução da busca de um elemento inexistente no slice: %s\n", elapsed)
		fmt.Printf("Memória Alocada: %d KB\n", (m2.Alloc-md.Alloc)/1024)

	//Métodos de remoção no pior caso (elemento não existe no slice)

		//Remoção no array dinâmico
		startadd = time.Now()
		var me runtime.MemStats
    	runtime.ReadMemStats(&me)
		
		array.Remove(7)

		elapsed = time.Since(startadd)
		runtime.ReadMemStats(&m2)
		elapsed = time.Since(startadd)

		fmt.Printf("Tempo de execução da remoção de um elemento inexistente no array (por shiftRight): %s\n", elapsed)
		fmt.Printf("Memória Alocada: %d KB\n", (m2.Alloc-me.Alloc)/1024)
		
		//Remoção no slice dinâmico
		startadd = time.Now()
		var mf runtime.MemStats
    	runtime.ReadMemStats(&mf)
		
		slice.Remove(7)

		elapsed = time.Since(startadd)
		runtime.ReadMemStats(&m2)
		elapsed = time.Since(startadd)

		fmt.Printf("Tempo de execução da remoção de um elemento inexistente no slice (por concatenação de slices): %s\n", elapsed)
		fmt.Printf("Memória Alocada: %d KB\n", (m2.Alloc-mf.Alloc)/1024)
	
	//Métodos de remoçao para o primeiro elemento

		//Remoção no array dinâmico
		//método utilizado: shiftRight
		startadd = time.Now()
		var mg runtime.MemStats
    	runtime.ReadMemStats(&mg)
		
		array.Remove(-79545)

		elapsed = time.Since(startadd)
		runtime.ReadMemStats(&m2)
		elapsed = time.Since(startadd)

		fmt.Printf("Tempo de execução da remoção do primeiro elemento do array: %s\n", elapsed)
		fmt.Printf("Memória Alocada: %d KB\n", (m2.Alloc-mg.Alloc)/1024)

		//Remoção no slice dinâmico
		//método utilizado: concatenação de slices
		startadd = time.Now()
		var mh runtime.MemStats
    	runtime.ReadMemStats(&mh)
		
		slice.Remove(-79545)

		elapsed = time.Since(startadd)
		runtime.ReadMemStats(&m2)
		elapsed = time.Since(startadd)

		fmt.Printf("Tempo de execução da remoção do primeiro elemento do slice: %s\n", elapsed)
		fmt.Printf("Memória Alocada: %d KB\n\n", (m2.Alloc-mh.Alloc)/1024)
}
