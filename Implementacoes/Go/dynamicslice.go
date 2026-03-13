// Implementação de uma lista dinâmica utilizando slices.
package main

import (
	"slices"
)

type DynamicSlice struct {
	Slice []int
}

// Verifica se o índice passado é válido.
func (ds *DynamicSlice) isValid(indice int) bool {
	return indice >= 0 && indice < len(ds.Slice)
}

// Adiciona elementos no final da lista.
func (ds *DynamicSlice) Add(element int) {
	ds.Slice = append(ds.Slice, element)
}

// Adiciona elementos no indice indicado.
func (ds *DynamicSlice) AddIndice(indice int, element int) {
	if indice == len(ds.Slice) {
		ds.Add(element)
	} else if ds.isValid(indice) {
		ds.Slice = slices.Insert(ds.Slice, indice, element)
	}
}

// Remove o elemento passado como parâmetro.
func (ds *DynamicSlice) RemoveElemento(element int) bool {
	indice := ds.Search(element)
	if indice != -1 {
		ds.Slice = slices.Delete(ds.Slice, indice, indice+1)
		return true
	}
	return false
}

// Remove o elemento do índice passado como parâmetro.
func (ds *DynamicSlice) RemoveIndice(indice int) bool {
	if ds.isValid(indice) {
		ds.Slice = slices.Delete(ds.Slice, indice, indice+1)
		return true
	}
	return false
}

// Retorna o índice do elemento passado como parâmetro.
func (ds *DynamicSlice) Search(element int) int {
	return slices.Index(ds.Slice, element)
}
