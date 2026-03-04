import java.util.*;
import java.io.*;

public class Runner {
  private int[] data;
//Classe auxiliar parao treinamento.
    public Runner(String path, int max) throws Exception{
      this.data = readData(path, max);
    }

    public int[] getData(){
      return this.data;
    }

  // Método para leitura de dados.
    private int[] readData(String path, int n) throws Exception{
        int[] data = new int[n];
        Scanner sc = new Scanner(new File(path));

        for (int i = 0; i < n && sc.hasNextInt(); i++) 
            data[i] = sc.nextInt();
        
        sc.close();
        return data;
    }


    //Métodos auxiliares para o treinamento (cada um retorna o tempo).
    
    //Inserção.
    public double measureAdd(ArrayListF list, int[] data) {
        long start = System.nanoTime();
        for (int i = 0; i < data.length; i++) 
            list.add(0, data[i]);
        return (System.nanoTime() - start) / 1_000_000.0;
    }

  
    public double measureAddNative(ArrayList<Integer> list, int[] data) {
        long start = System.nanoTime();
        for (int i = 0; i < data.length; i++) 
            list.add(0, data[i]);
        return (System.nanoTime() - start) / 1_000_000.0;
    }

  //Search.
    public double measureSearch(ArrayListF list, int target) {
        long start = System.nanoTime();
        list.search(target);
        return (System.nanoTime() - start) / 1_000_000.0;
    }


    public double measureSearchNative(ArrayList<Integer> list, int target) {
        long start = System.nanoTime();
        list.contains(target); 
        return (System.nanoTime() - start) / 1_000_000.0;
    }

    //Remoção.
    public double measureRemove(ArrayListF list, int n) {
        long start = System.nanoTime();
        for (int i = 0; i < n; i++) 
          list.remove(0);
        return (System.nanoTime() - start) / 1_000_000.0;
}
      

    public double measureRemoveNative(ArrayList<Integer> list, int n) {
        long start = System.nanoTime();
        for (int i = 0; i < n; i++) 
          list.remove(0);
        return (System.nanoTime() - start) / 1_000_000.0;
    }

    //Métodos auxiliares para medir consumo de memória.
    
    //Inserção. 
    public double measureAddMemory(ArrayListF list, int[] data){
        long beforeUsedMem = Runtime.getRuntime().totalMemory() -Runtime.getRuntime().freeMemory();
        for (int i = 0; i < data.length; i++) 
            list.add(0, data[i]);       
        long afterUsedMem = Runtime.getRuntime().totalMemory() - Runtime.getRuntime().freeMemory();
        return (afterUsedMem - beforeUsedMem);
    }
    
    public double measureAddNativeMemory(ArrayList<Integer> list, int[] data){
        long beforeUsedMem = Runtime.getRuntime().totalMemory() -Runtime.getRuntime().freeMemory();
        for (int i = 0; i < data.length; i++) 
            list.add(0, data[i]);
        long afterUsedMem = Runtime.getRuntime().totalMemory() - Runtime.getRuntime().freeMemory();
        return (afterUsedMem - beforeUsedMem);
    }

    //Search.
     public double measureSearchMemory(ArrayListF list, int target) {
        long beforeUsedMem = Runtime.getRuntime().totalMemory() -Runtime.getRuntime().freeMemory();
        list.search(target);
        long afterUsedMem = Runtime.getRuntime().totalMemory() - Runtime.getRuntime().freeMemory();
        return (afterUsedMem - beforeUsedMem);
    }


    public double measureSearchNativeMemory(ArrayList<Integer> list, int target) {
        long beforeUsedMem = Runtime.getRuntime().totalMemory() -Runtime.getRuntime().freeMemory();
        list.contains(target); 
        long afterUsedMem = Runtime.getRuntime().totalMemory() - Runtime.getRuntime().freeMemory();
        return (afterUsedMem - beforeUsedMem);
    }

    //Remoção.
    public double measureRemoveMemory(ArrayListF list, int n) {
        long beforeUsedMem = Runtime.getRuntime().totalMemory() -Runtime.getRuntime().freeMemory();
        for (int i = 0; i < n; i++) 
          list.remove(0);
        long afterUsedMem = Runtime.getRuntime().totalMemory() - Runtime.getRuntime().freeMemory();
        return (afterUsedMem - beforeUsedMem);
    }
      

    public double measureRemoveNativeMemory(ArrayList<Integer> list, int n) {
        long beforeUsedMem = Runtime.getRuntime().totalMemory() -Runtime.getRuntime().freeMemory();
        for (int i = 0; i < n; i++) 
          list.remove(0);
        long afterUsedMem = Runtime.getRuntime().totalMemory() - Runtime.getRuntime().freeMemory();
        return (afterUsedMem - beforeUsedMem);
    }
}