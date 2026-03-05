package main

import (
	"slices"
)

type DynamicSlice struct {
	Slice []int
}

func (ds *DynamicSlice) AddIndice(indice int, element int) {
	ds.Slice = slices.Insert(ds.Slice, indice, element)
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
		ds.Slice = slices.Delete(ds.Slice, index, index+1)
		return true
	}
	return false
}

func (ds *DynamicSlice) RemoveIndice(index int) bool {
	if index >= 0 && index < len(ds.Slice) {
		ds.Slice = slices.Delete(ds.Slice, index, index+1)
		return true
	}
	return false
}
