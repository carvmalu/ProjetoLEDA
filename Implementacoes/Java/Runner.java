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
    
    // Lendo a String
    public int[] readString(String entrada){
        String[] parts = entrada.split(",");
        int[] sizes = new int[parts.length];
        for (int i = 0; i < parts.length; i++) {
            sizes[i] = Integer.parseInt(parts[i].trim());
        }
        return sizes;
    }


    private long getUsedMemory() {
        Runtime runtime = Runtime.getRuntime();
        return runtime.totalMemory() - runtime.freeMemory();
    }

    //Métodos auxiliares para o treinamento (cada um retorna o tempo).
    
    //Inserção.
    public double measureAdd(ArrayListF list, int element) {
        long start = System.nanoTime();
        list.add(0, element);
        return (System.nanoTime() - start) / 1_000_000.0;
    }

    public double measureAddNative(ArrayList<Integer> list, int element) {
        long start = System.nanoTime();
        list.add(0, element);
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
        list.remove(Integer.valueOf(n));
        return (System.nanoTime() - start) / 1_000_000.0;
    }

    public double measureRemoveNative(ArrayList<Integer> list, int n) {
        long start = System.nanoTime();
        list.remove(Integer.valueOf(n));
        return (System.nanoTime() - start) / 1_000_000.0;
    }

    //Métodos auxiliares para medir consumo de memória.

    //Inserção.
    public long measureAddMemory(ArrayListF list, int element){
        System.gc(); 
        long beforeUsedMem = getUsedMemory();
        list.add(0, element);
        long afterUsedMem = getUsedMemory();
        return (afterUsedMem - beforeUsedMem);
    }
    
    public long measureAddNativeMemory(ArrayList<Integer> list, int element){
        System.gc();
        long beforeUsedMem = getUsedMemory();
        list.add(0, element);
        long afterUsedMem = getUsedMemory();
        return (afterUsedMem - beforeUsedMem);
    }

    //Search.
    public long measureSearchMemory(ArrayListF list, int target) {
        System.gc();
        long beforeUsedMem = getUsedMemory();
        list.search(target);
        long afterUsedMem = getUsedMemory();
        return (afterUsedMem - beforeUsedMem);
    }

    public long measureSearchNativeMemory(ArrayList<Integer> list, int target) {
        System.gc();
        long beforeUsedMem = getUsedMemory();
        list.contains(target); 
        long afterUsedMem = getUsedMemory();
        return (afterUsedMem - beforeUsedMem);
    }

    //Remoção.
    public long measureRemoveMemory(ArrayListF list, int n) {
        System.gc();
        long beforeUsedMem = getUsedMemory();
        list.remove(Integer.valueOf(n));
        long afterUsedMem = getUsedMemory();
        return (afterUsedMem - beforeUsedMem);
    }

    public long measureRemoveNativeMemory(ArrayList<Integer> list, int n) {
        System.gc();
        long beforeUsedMem = getUsedMemory();
        list.remove(Integer.valueOf(n));
        long afterUsedMem = getUsedMemory();
        return (afterUsedMem - beforeUsedMem);
    }
}