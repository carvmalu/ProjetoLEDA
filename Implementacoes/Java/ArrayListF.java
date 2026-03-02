/*
Implementação reduzida de uma lista dinâmica baseada em array com iteração manual.
Inspiração: 

*/

public class ArrayListF {

  private int[] list;
  private int size;

public ArrayListF(int capacity){
  this.list = new int[capacity];
  this.size = 0;
}

// Verifica se a lista está cheia.
private boolean isFull(){
  return (this.size == list.length);
}

// Dobra o tamanho da lista.
private void resize(){

  int[] newList = new int[size * 2];

  for(int i = 0; i < list.length; i++)
    newList[i] = this.list[i];

  this.list = newList;
}


// Verifica se o índice passado é válido.
private boolean isValid(int idx){
  return idx >= 0 && idx <= this.size;
}


// Move os elementos para a direita.
private void shiftRight(int idx){
  for (int i = size; i > idx; i--) 
    this.list[i] = this.list[i - 1];
}

// Adiciona elementos.
public void add (int element){
  if(isFull()) resize();

  this.list[this.size] = element;
  this.size++; 
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
  for (int i = idx; i < size - 1; i++) 
      this.list[i] = this.list[i + 1];
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
