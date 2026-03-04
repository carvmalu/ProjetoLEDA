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
}