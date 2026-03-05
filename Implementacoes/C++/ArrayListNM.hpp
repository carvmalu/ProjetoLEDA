#include <algorithm> // Para std::copy e std::move

class ArrayListNM {
private:
    int* list;
    int capacity;
    int size;

    bool isFull() { return size == capacity; }

    void resize() {
        int newCapacity = (capacity == 0) ? 1 : capacity * 2;
        int* newList = new int[newCapacity];
        std::copy(list, list + size, newList);
        delete[] list;
        list = newList;
        capacity = newCapacity;
    }

    void shiftRight(int idx) {
        // std::move_backward é ideal para deslocar elementos para a direita
        std::move_backward(list + idx, list + size, list + size + 1);
    }

public:
    ArrayListNM(int initialCapacity) {
        list = new int[initialCapacity];
        capacity = initialCapacity;
        size = 0;
    }

    ~ArrayListNM() { delete[] list; }

    void add(int idx, int element) {
        if (idx >= 0 && idx <= size) {
            if (isFull()) resize();
            shiftRight(idx);
            list[idx] = element;
            size++;
        }
    }
};