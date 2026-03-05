package main

var defaultCapacity = 1000

type DynamicArray struct {
	Size     int
	Capacity int
	Array    []int
}

func (da *DynamicArray) AddIndice(indice int, element int) {
	if da.Size == da.Capacity {
		da.resize()
	}
	if (indice  >= 0 && indice <= da.Size) {
		if (indice == da.Size) {
			da.Add(element)
		} else {
			aux := da.Size - 1
			for aux >= indice {
				da.Array[aux + 1] = da.Array[aux]
				aux--
			}
			da.Array[indice] = element
			da.Size++
		}
	}
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

func (da *DynamicArray) RemoveIndice(index int) bool {
	if index >= 0 && index < da.Size {
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
