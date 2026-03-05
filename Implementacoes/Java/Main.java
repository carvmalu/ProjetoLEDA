import java.util.*;
import java.io.*;

//https://blog.formacao.dev/manipulacao-de-arquivos-csv-em-java-leitura-e-escrita/
// Comando na raiz do projeto: java -cp Implementacoes/Java Main input/entrada.txt Resultados/ 10000,30000,50000,100000

public class Main {
    public static void main(String[] args) throws Exception {
        
        //Aqui seria os dados/formas padronizadas.
        String inputFile = args[0]; 
        String path = args[1];  
        String outputFile = "JavaResults.csv";

     
        Runner r = new Runner(inputFile, 100000);
        int[] data = r.getData();
        int[] sizes = r.readString(args[2]);

        try (PrintWriter w = new PrintWriter(new FileWriter(path + "/" + outputFile))) {
            w.println("Language,Implementation,Operation,Metric,N,TimeMS/Bytes");

            for (int i = 0; i < sizes.length; i++) {
                //
                int n = sizes[i]; int[] currentData = new int[n];
                for (int j = 0; j < n; j++)
                    currentData[j] = data[j];
              
                // Inserção.
                ArrayListF listF = new ArrayListF(10);
                double tF = r.measureAdd(listF, currentData);
                w.println("Java,ArrayListFor,Insercao,Tempo," + n + "," + tF);
        
                ArrayList<Integer> listNative = new ArrayList<>();
                double tNative = r.measureAddNative(listNative, currentData);
                w.println("Java,ArrayListBuildIn,Insercao,Tempo," + n + "," + tNative);


                listF = new ArrayListF(10);
                long tFM = r.measureAddMemory(listF, currentData);
                w.println("Java,ArrayListFor,Insercao,Memoria," + n + "," + tFM);

                listNative = new ArrayList<>();
                long tNativeM = r.measureAddNativeMemory(listNative, currentData);
                w.println("Java,ArrayListBuildIn,Insercao,Memoria," + n + "," + tNativeM);


                //Verificando busca.
                double tFSearch = r.measureSearch(listF,-5);
                w.println("Java,ArrayListFor,Search,Tempo," + n + "," + tFSearch);

                double tNativeSearch =  r.measureSearchNative(listNative, -5);
                w.println("Java,ArrayListBuildIn,Search,Tempo," + n + "," + tNativeSearch);

                long tFSearchM = r.measureSearchMemory(listF, -5);
                w.println("Java,ArrayListFor,Search,Memoria," + n + "," + tFSearchM);

                long tNativeSearchM =  r.measureSearchNativeMemory(listNative, -5);
                w.println("Java,ArrayListBuildIn,Search,Memoria," + n + "," + tNativeSearchM);


                //Remoção.
                double tFRemove = r.measureRemove(listF,currentData[0]);
                w.println("Java,ArrayListFor,Remocao,Tempo," + n + "," + tFRemove);
                listF.add(listF.size(),(currentData[0]));
                

                double tNativeRemove =  r.measureRemoveNative(listNative, currentData[0]);
                w.println("Java,ArrayListBuildIn,Remocao,Tempo," + n + "," + tNativeRemove);
                listNative.add(listNative.size(), currentData[0]);

                long tFRemoveM = r.measureRemoveMemory(listF,currentData[0]);
                w.println("Java,ArrayListFor,Remocao,Memoria," + n + "," + tFRemoveM);
                listF.add(listF.size(),(currentData[0]));

                long tNativeRemoveM =  r.measureRemoveNativeMemory(listNative, currentData[0]);
                w.println("Java,ArrayListBuildIn,Remocao,Memoria," + n + "," + tNativeRemoveM);
                listNative.add(listNative.size(),(currentData[0]));
            }
        
        } catch (Exception e) {
            System.err.println("Erro " + e.getMessage());
            e.printStackTrace();
        }
    }
}
