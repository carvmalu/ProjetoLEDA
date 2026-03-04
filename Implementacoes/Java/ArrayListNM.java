/*
Implementação reduzida de uma lista dinâmica baseada em array com métodos nativos.
Fonte: https://medium.com/@dieggocarrilho/um-array-é-uma-estrutura-de-dados-usada-para-armazenar-informações-de-um-mesmo-tipo-bd33aef7863a
*/
public class ArrayListNM {

  private int[] list;
  private int size;

public ArrayListNM(int capacity){
  this.list = new int[capacity];
  this.size = 0;
}

// Verifica se a lista está cheia.
private boolean isFull(){
  return (this.size == list.length);
}

// Dobra o tamanho da lista.
private void resize(){
  int[] newList = new int[this.size * 2];
  System.arraycopy(this.list, 0, newList, 0, this.size);
  this.list = newList;
}


// Verifica se o índice passado é válido.
private boolean isValid(int idx){
  return idx >= 0 && idx <= this.size;
}


// Move os elementos para a direita.
private void shiftRight(int idx){
  System.arraycopy(this.list, idx, this.list, idx + 1, this.size - idx);;
}

// Adiciona elementos.
public void add (int element){
  if(isFull()) resize();

  this.list[this.size] = element;
  this.size++; 
}

//Procura o elemento e retorna o índice, caso for encontrado.
public int search(int element){

  for(int i = 0; i < list.length; i++)
      if(list[i] == element)
          return i;
    
  return -1;
  }


public void add (int idx, int element){
  if(isValid(idx)){
  
  if(isFull()) resize();
  
  shiftRight(idx);
  this.list[idx] = element;
  this.size++; 
  }
}

// Move os elementos para a esquerda.
private void shiftLeft(int idx){
  System.arraycopy(this.list, idx + 1, this.list, idx, this.size - idx - 1);
}

// Remove elementos.
public void remove(){
  if(size >= 1) this.size--;
}

public void remove(int idx){
    if (isValid(idx) && idx < size) {
    shiftLeft(idx);
    this.size--;
    }
  }
  
}
