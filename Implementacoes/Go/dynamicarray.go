// Implementação de uma lista dinâmica com lógica de array.
package main

var defaultCapacity = 1000

type DynamicArray struct {
	Size     int
	Capacity int
	Array    []int
}

// Verifica se a lista está cheia.
func (da *DynamicArray) isFull() bool {
	return da.Size == da.Capacity
}

// Verifica se o índice passado é válido.
func (da *DynamicArray) isValid(indice int) bool {
	return indice >= 0 && indice < da.Size
}

// Adiciona elementos no final da lista.
func (da *DynamicArray) Add(element int) {
	if da.isFull() {
		da.resize()
	}

	da.Array[da.Size] = element
	da.Size++
}

// Adiciona elementos no indice indicado.
func (da *DynamicArray) AddIndice(indice int, element int) {
	if da.isFull() {
		da.resize()
	}
	if indice == da.Size {
		da.Add(element)
	} else if da.isValid(indice) {
		array.shiftRight(indice)
		da.Array[indice] = element
		da.Size++
	}
}

// Move os elementos para a direita.
func (da *DynamicArray) shiftRight(indice int) {
	if da.isValid(indice) {
		aux := da.Size - 1
		for aux >= indice {
			da.Array[aux+1] = da.Array[aux]
			aux--
		}
	}
}

// Move os elementos para a esquerda.
func (da *DynamicArray) shiftLeft(indice int) {
	if da.isValid(indice) {
		for indice < da.Size-1 {
			da.Array[indice] = da.Array[indice+1]
			indice++
		}
	}
}

// Remove o elemento passado como parâmetro.
func (da *DynamicArray) RemoveElemento(element int) bool {
	indice := da.Search(element)
	if indice != -1 {
		da.shiftLeft(indice)
		da.Size--
		return true
	}
	return false
}

// Remove o elemento do índice passado como parâmetro.
func (da *DynamicArray) RemoveIndice(indice int) bool {
	if da.isValid(indice) {
		da.shiftLeft(indice)
		da.Size--
		return true
	}
	return false
}

// Retorna o índice do elemento passado como parâmetro.
func (da *DynamicArray) Search(element int) int {
	for i := 0; i < da.Size; i++ {
		if da.Array[i] == element {
			return i
		}
	}
	return -1
}

// Dobra o tamanho da lista.
func (da *DynamicArray) resize() {
	if da.Capacity == 0 {
		da.Capacity = defaultCapacity
	} else {
		da.Capacity = da.Capacity * 2
	}

	newArray := make([]int, da.Capacity)

	copy(newArray, da.Array)

	da.Array = newArray
}
