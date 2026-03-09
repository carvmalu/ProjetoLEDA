#ifndef ARRAYLISTNM_HPP
#define ARRAYLISTNM_HPP
#include <algorithm>

class ArrayListNM {
private:
    int* list;
    int capacity;
    int size;
    void resize() {
        int newCapacity = (capacity == 0) ? 1 : capacity * 2;
        int* newList = new int[newCapacity];
        std::copy(list, list + size, newList);
        delete[] list;
        list = newList;
        capacity = newCapacity;
    }

public:
    ArrayListNM(int cap) : size(0), capacity(cap) { list = new int[capacity]; }
    ~ArrayListNM() { delete[] list; }
    void add(int val) { if (size == capacity) resize(); list[size++] = val; }
    void addInicio(int val) { if (size == capacity) resize(); std::move_backward(list, list + size, list + size + 1); list[0] = val; size++; }
    int search(int val) { int* it = std::find(list, list + size, val); return (it != list + size) ? std::distance(list, it) : -1; }
    void removeByIndex(int idx) { if (idx >= 0 && idx < size) { std::copy(list + idx + 1, list + size, list + idx); size--; } }
    void removeByValue(int val) { int idx = search(val); if (idx != -1) removeByIndex(idx); }
};
#endif