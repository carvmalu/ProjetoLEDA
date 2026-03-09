import java.util.*;
import java.io.*;

//https://blog.formacao.dev/manipulacao-de-arquivos-csv-em-java-leitura-e-escrita/
// Comando na raiz do projeto:  java -cp Implementacoes/Java Main input/entrada.txt Resultados/Java/ 10000,30000,50000,100000

public class Main {
    public static void main(String[] args) throws Exception {
        
        //Separando dados.
        String inputFile = args[0]; 
        String path = args[1];  
        String outputFile = "JavaResults.csv";
        int RUNS = 30;
        
        //Aquecimento.
        ArrayListF warmupF = new ArrayListF(10);
        ArrayList<Integer> warmupNative = new ArrayList<>();
        for (int i = 0; i < 1000; i++) { 
            warmupF.add(0, i); 
            warmupNative.add(0, i); }
        warmupF.search(500); warmupNative.contains(500);
        warmupF.remove(Integer.valueOf(500)); warmupNative.remove(Integer.valueOf(500));

        Runner r = new Runner(inputFile, 100000);
        int[] data = r.getData();
        int[] sizes = r.readString(args[2]);

        try (PrintWriter w = new PrintWriter(new FileWriter(path + "/" + outputFile))) {
            w.println("Linguagem_Tipo,Tamanho,Operacao,Tempo_Media(ms),Memoria(bytes)");

            for (int i = 0; i < sizes.length; i++) {
                int n = sizes[i]; int[] currentData = new int[n];
                for (int j = 0; j < n; j++)
                    currentData[j] = data[j];

                // Acumuladores.
                double sumTFAdd = 0, sumTNAdd = 0;
                long sumMFAdd = 0, sumMNAdd = 0;

                double sumTFSearch = 0, sumTNSearch = 0;
                long sumMFSearch = 0, sumMNSearch = 0;

                double sumTFRemIdx = 0, sumTNRemIdx = 0;
                long sumMFRemIdx = 0, sumMNRemIdx = 0;

                double sumTFRemVal = 0, sumTNRemVal = 0;
                long sumMFRemVal = 0, sumMNRemVal = 0;

                for (int run = 0; run < RUNS; run++) {

                    // Inserção.
                    ArrayListF listF = new ArrayListF(10);
                    sumTFAdd += r.measureAdd(listF, currentData);

                    ArrayList<Integer> listNative = new ArrayList<>();
                    sumTNAdd += r.measureAddNative(listNative, currentData);

                    listF = new ArrayListF(10);
                    sumMFAdd += r.measureAddMemory(listF, currentData);

                    listNative = new ArrayList<>();
                    sumMNAdd += r.measureAddNativeMemory(listNative, currentData);

                    // Search.
                    Integer num = Integer.valueOf(7);
                    sumTFSearch += r.measureSearch(listF, num);
                    sumTNSearch += r.measureSearchNative(listNative, num);
                    sumMFSearch += r.measureSearchMemory(listF, num);
                    sumMNSearch += r.measureSearchNativeMemory(listNative, num);

                    // RemocaoIndice.
                    sumTFRemIdx += r.measureRemove(listF, currentData[0]);
                    listF.add(0, (currentData[n - 1]));

                    sumTNRemIdx += r.measureRemoveNative(listNative, currentData[0]);
                    listNative.add(0, currentData[n - 1]);

                    sumMFRemIdx += r.measureRemoveMemory(listF, currentData[0]);
                    listF.add(0, (currentData[n - 1]));

                    sumMNRemIdx += r.measureRemoveNativeMemory(listNative, currentData[0]);
                    listNative.add(0, (currentData[n - 1]));

                    // RemocaoValor.
                    num = Integer.valueOf(currentData[n - 1]);
                    sumTFRemVal += r.measureRemove(listF, num);
                    listF.add(0, (currentData[n - 1]));

                    sumTNRemVal += r.measureRemoveNative(listNative, num);
                    listNative.add(0, currentData[n - 1]);

                    sumMFRemVal += r.measureRemoveMemory(listF, num);
                    listF.add(0, (currentData[n - 1]));

                    sumMNRemVal += r.measureRemoveNativeMemory(listNative, num);
                    listNative.add(0, (currentData[n - 1]));
                }

                // Escrevendo médias.
                w.println("Java_ArrayListManual," + n + ",adicaoInicio," + (sumTFAdd / RUNS) + "," + (sumMFAdd / RUNS));
                w.println("Java_ArrayListBuildIn," + n + ",adicaoInicio," + (sumTNAdd / RUNS) + "," + (sumMNAdd / RUNS));

                w.println("Java_ArrayListManual," + n + ",busca," + (sumTFSearch / RUNS) + "," + (sumMFSearch / RUNS));
                w.println("Java_ArrayListBuildIn," + n + ",busca," + (sumTNSearch / RUNS) + "," + (sumMNSearch / RUNS));

                w.println("Java_ArrayListManual," + n + ",remocaoIndice," + (sumTFRemIdx / RUNS) + "," + (sumMFRemIdx / RUNS));
                w.println("Java_ArrayListBuildIn," + n + ",remocaoIndice," + (sumTNRemIdx / RUNS) + "," + (sumMNRemIdx / RUNS));

                w.println("Java_ArrayListManual," + n + ",remocaoValor," + (sumTFRemVal / RUNS) + "," + (sumMFRemVal / RUNS));
                w.println("Java_ArrayListBuildIn," + n + ",remocaoValor," + (sumTNRemVal / RUNS) + "," + (sumMNRemVal / RUNS));
            }
        
        } catch (Exception e) {
            System.err.println("Erro " + e.getMessage());
            e.printStackTrace();
        }
    }
}