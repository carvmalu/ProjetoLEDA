# Implementação manual baseada em Array dinâmico

class ArrayListManual:
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
    
    # Retorna quantidade de elementos inseridos
    def getSize(self):
        return self.size
    
    # Verifica se o índice passado é válido
    def isValid(self, index):
        return index >= 0 and index <= self.size
    
    # Move elementos para a direita.
    def shiftRight(self, index):
        for i in range (self.size, index, -1):
            self.arraylist[i] = self.arraylist[i - 1]

    # Move elementos para a esquerda
    def shiftLeft(self, index):
        for i in range (index, self.size-1):
            self.arraylist[i] = self.arraylist[i + 1]

    # Dobra tamanho da lista e realoca elementos para lista de novo tamanho
    def resize(self):
        newArray = [None] * (len(self.arraylist) * 2)
        for i in range (0, self.size):
            newArray[i] = self.arraylist[i]
        self.arraylist = newArray


     # ------ MÉTODOS QUE SERÃO USADOS NOS TESTES -----

    # Insere elementos no final da lista (sem índice)
    def addElement(self, element):
        if (self.isFull()):
            self.resize()
        self.arraylist[self.size] = element
        self.size += 1

    # Insere elemento no índice passado como parâmetro
    def addNoindexElement(self, index, element):
        if (self.isValid(index)):
            if (self.isFull()):
                self.resize()
            self.shiftRight(index)
            self.arraylist[index] = element
            self.size += 1

    # Remove elemento do final da lista (sem índice)
    def removeFinal(self):
        if (self.size >= 1):
            self.size -= 1
    
    # Remove elemento no índice passado como parâmetro
    def removePorindex(self, index):
        if (self.isValid(index) and index < self.size):
            self.shiftLeft(index)
            self.size -= 1

    # Remove elemento passado como parâmetro
    def removePorElement(self, element):
        index = self.search(element)
        if (index != -1):
            self.shiftLeft(index)
            self.size -= 1

    # Busca por elemento e retorna a posição em que ele está
    def search(self, element):
        for i in range (0, self.size):
            if (self.arraylist[i] == element):
                return i
        return -1
            