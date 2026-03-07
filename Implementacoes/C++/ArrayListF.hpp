#ifndef ARRAYLISTF_HPP
#define ARRAYLISTF_HPP
#include <stdexcept>

class ArrayListF {
private:
    int* list;
    int capacity;
    int size;
    void resize() {
        int newCapacity = (capacity == 0) ? 1 : capacity * 2;
        int* newList = new int[newCapacity];
        for (int i = 0; i < size; i++) newList[i] = list[i];
        delete[] list;
        list = newList;
        capacity = newCapacity;
    }
    void shiftRight(int idx) { for (int i = size; i > idx; i--) list[i] = list[i - 1]; }
    void shiftLeft(int idx) { for (int i = idx; i < size - 1; i++) list[i] = list[i + 1]; }

public:
    ArrayListF(int cap) : size(0), capacity(cap) { list = new int[capacity]; }
    ~ArrayListF() { delete[] list; }
    void add(int val) { if (size == capacity) resize(); list[size++] = val; }
    void addInicio(int val) { if (size == capacity) resize(); shiftRight(0); list[0] = val; size++; }
    int search(int val) { for (int i = 0; i < size; i++) if (list[i] == val) return i; return -1; }
    void removeByIndex(int idx) { if (idx >= 0 && idx < size) { shiftLeft(idx); size--; } }
    void removeByValue(int val) { int idx = search(val); if (idx != -1) removeByIndex(idx); }
};
#endif