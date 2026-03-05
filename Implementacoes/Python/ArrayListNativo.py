# Implementação nativa baseada em Array dinâmico

class ArrayListNativo:
    def __init__(self, capacity):
        self.arraylist = [None] * max(1, capacity)
        self.size = 0

    # ----- MÉTODOS AUXILIARES ------

    # Verifica se a lista está vazia
    def isEmpty(self):
        return self.size == 0

    # Verifica se a lista está cheia
    def isFull(self):
        return self.size == len(self.arraylist)
    
    # Verifica se o índice passado é válido
    def isValid(self, index):
        return index >= 0 and index <= self.size
    
    # Move elementos para a direita utilizando slicing (fatiamento)
    def shiftRight(self, index):
        self.arraylist[index+1:self.size+1] = self.arraylist[index:self.size]

    # Move elementos para a esquerda
    def shiftLeft(self, index):
        self.arraylist[index:self.size-1] = self.arraylist[index+1:self.size]

    # Dobra tamanho da lista e realoca elementos para lista de novo tamanho
    def resize(self):
        newArray = [None] * (len(self.arraylist) * 2)
        newArray[:self.size] = self.arraylist[:self.size]
        self.arraylist = newArray



    # ------ MÉTODOS QUE SERÃO USADOS NOS TESTES -----

    # Insere elementos no final da lista (sem índice)
    def add_element(self, element):
        if (self.isFull()):
            self.resize()
        self.arraylist[self.size] = element
        self.size += 1

    # Insere elemento no índice passado como parâmetro
    def add_index_element(self, index, element):
        if (self.isValid(index)):
            if (self.isFull()):
                self.resize()
            self.shiftRight(index)
            self.arraylist[index] = element
            self.size += 1

    # Remove elemento do final da lista (sem índice)
    def remove_final(self):
        if (self.size >= 1):
            self.size -= 1
    
    # Remove elemento no índice passado como parâmetro
    def remove_index(self, index):
        if (self.isValid(index) and index < self.size):
            self.shiftLeft(index)
            self.size -= 1

    # Busca por elemento e retorna a posição em que ele está
    def search(self, element):
        for i in range (0, self.size):
            if (self.arraylist[i] == element):
                return i
        return -1
            