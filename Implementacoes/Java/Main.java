import java.util.*;
import java.io.*;

//https://blog.formacao.dev/manipulacao-de-arquivos-csv-em-java-leitura-e-escrita/
// Comando na raiz do projeto:  java -cp Implementacoes/Java Main input/entrada.txt Resultados/Java/ 10000,30000,50000,100000 30

public class Main {
    public static void main(String[] args) throws Exception {
        
        //Separando dados.
        String inputFile = args[0]; 
        String path = args[1];  
        String outputFile = "JavaResults.csv";
        
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
        int RUNS = Integer.parseInt(args[3]);

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
                
                // Criando as Listas.
                ArrayListF listF = new ArrayListF(10);
                    for (int k = 0; k < n; k++) listF.add(k, currentData[k]);
 
                ArrayList<Integer> listNative = new ArrayList<>();
                    for (int k = 0; k < n; k++) listNative.add(k, currentData[k]);

                for (int run = 0; run < RUNS; run++) {
                    //Log para acompanhar o progresso.
                    if(run % (Math.max(1, RUNS / 10)) == 0)
                        System.out.printf("  [N=%6d] %5.1f%% concluido (run %d/%d)%n", 
                            n, (run * 100.0 / RUNS), run, RUNS);
                    // Inserção.
                    sumTFAdd += r.measureAdd(listF, currentData[0]);
                    listF.remove(0);

                   
                    sumTNAdd += r.measureAddNative(listNative, currentData[0]);
                    listNative.remove(0);

                    sumMFAdd += r.measureAddMemory(listF, currentData[0]);
                    listF.remove(0);

                    sumMNAdd += r.measureAddNativeMemory(listNative, currentData[0]);
                    listNative.remove(0);

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

                } // fecha for RUNS

                // Escrevendo médias.
                w.println("Java_ArrayListManual," + n + ",adicaoInicio," + String.format("%.3f", (sumTFAdd / RUNS)) + "," + (sumMFAdd / RUNS));
                w.println("Java_ArrayListBuildIn," + n + ",adicaoInicio," + String.format("%.3f", (sumTNAdd / RUNS)) + "," + (sumMNAdd / RUNS));
                w.println("Java_ArrayListManual," + n + ",busca," + String.format("%.3f", (sumTFSearch / RUNS)) + "," + (sumMFSearch / RUNS));
                w.println("Java_ArrayListBuildIn," + n + ",busca," + String.format("%.3f", (sumTNSearch / RUNS)) + "," + (sumMNSearch / RUNS));
                w.println("Java_ArrayListManual," + n + ",remocaoIndice," + String.format("%.3f", (sumTFRemIdx / RUNS)) + "," + (sumMFRemIdx / RUNS));
                w.println("Java_ArrayListBuildIn," + n + ",remocaoIndice," + String.format("%.3f", (sumTNRemIdx / RUNS)) + "," + (sumMNRemIdx / RUNS));
                w.println("Java_ArrayListManual," + n + ",remocaoValor," + String.format("%.3f", (sumTFRemVal / RUNS)) + "," + (sumMFRemVal / RUNS));
                w.println("Java_ArrayListBuildIn," + n + ",remocaoValor," + String.format("%.3f", (sumTNRemVal / RUNS)) + "," + (sumMNRemVal / RUNS));

            } // fecha for sizes

        } catch (Exception e) {
            System.err.println("Erro " + e.getMessage());
            e.printStackTrace();
        }
        
    }
}
