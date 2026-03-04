package main

import (
	"slices"
)

type DynamicSlice struct {
	Slice []int
}

func (ds *DynamicSlice) AddSlice(numeros []int){
	ds.Slice = append(ds.Slice, numeros...)
}

func (ds *DynamicSlice) Add(element int) {
	ds.Slice = append(ds.Slice, element)
}

func (ds *DynamicSlice) Search(element int) int {
	index := slices.Index(ds.Slice, element)
	return index
}

func (ds *DynamicSlice) Remove(element int) bool {
	index := ds.Search(element)
	if index != -1 {
		ds.Slice = append(ds.Slice[:index], ds.Slice[index+1:]...)
		return true
	}
	return false
}
