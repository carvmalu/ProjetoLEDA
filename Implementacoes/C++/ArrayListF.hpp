#include <iostream>

class ArrayListF {
private:
    int* list;
    int capacity;
    int size;

    bool isFull() { return size == capacity; }

    void resize() {
        int newCapacity = (capacity == 0) ? 1 : capacity * 2;
        int* newList = new int[newCapacity];
        for (int i = 0; i < size; i++) {
            newList[i] = list[i];
        }
        delete[] list; // Importante em C++ para evitar vazamento de memória
        list = newList;
        capacity = newCapacity;
    }

    void shiftRight(int idx) {
        for (int i = size; i > idx; i--) {
            list[i] = list[i - 1];
        }
    }

public:
    ArrayListF(int initialCapacity) {
        list = new int[initialCapacity];
        capacity = initialCapacity;
        size = 0;
    }

    ~ArrayListF() { delete[] list; } // Destrutor para limpar memória

    void add(int idx, int element) {
        if (idx >= 0 && idx <= size) {
            if (isFull()) resize();
            shiftRight(idx);
            list[idx] = element;
            size++;
        }
    }
};