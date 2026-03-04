package main

var defaultCapacity = 10000

type DynamicArray struct {
	Size     int
	Capacity int
	Array    []int
}

func (da *DynamicArray) AddSlice(numeros []int) {
	da.Array = append(da.Array, numeros...)
	da.Size += len(numeros)
	da.Capacity = da.Size * 2
}

func (da *DynamicArray) Add(element int) {
	if da.Size == da.Capacity {
		da.resize()
	}

	da.Array[da.Size] = element
	da.Size++
}

func (da *DynamicArray) Search(element int) int {
	for i := 0; i < da.Size; i++ {
		if da.Array[i] == element {
			return i
		}
	}
	return -1
}

func (da *DynamicArray) Remove(element int) bool {
	index := da.Search(element)
	if index != -1 {
		for index < da.Size-1 {
			da.Array[index] = da.Array[index+1]
			index = index + 1
		}
		da.Size--
		return true
	}
	return false
}

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
