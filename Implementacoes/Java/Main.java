import java.util.*;
import java.io.*;

//https://blog.formacao.dev/manipulacao-de-arquivos-csv-em-java-leitura-e-escrita/

public class Main {
    public static void main(String[] args) throws Exception {
        
        //Aqui seria os dados/formas padronizadas.
        String inputFile = "dados.txt";
        String outputFile = "JavaResults.csv";
        String path = "../../Resultados/Java/"; ;
        int[] sizes = {10000, 30000, 50000, 100000};

     
        Runner r = new Runner(inputFile, sizes[3]);
        int[] data = r.getData();

        try (PrintWriter w = new PrintWriter(new FileWriter(outputFile + path))) {
            w.println("Language,Implementation,Operation,N,TimeMS");

            for (int i = 0; i < sizes.length; i++) {
                //
                int n = sizes[i]; int[] currentData = new int[n];
                for (int j = 0; j < n; j++)
                    currentData[j] = data[j];
              
                // Inserção.
                ArrayListF listF = new ArrayListF(10);
                double tF = r.measureAdd(listF, currentData);
                w.println("Java,ArrayListFor,AddInicio," + n + "," + tF);



                ArrayList<Integer> listNative = new ArrayList<>();
                double tNative = r.measureAddNative(listNative, currentData);
                w.println("Java,ArrayListBuildIn,AddInicio," + n + "," + tNative);



                //Verificando busca.
                double tFSearch = r.measureSearch(listF, currentData[0]);
                w.println("Java,ArrayListFor,Search," + n + "," + tFSearch);

              
                double tNativeSearch =  r.measureSearchNative(listNative, currentData[0]);
                w.println("Java,ArrayListBuildIn,Search," + n + "," + tNativeSearch);

            }
        
        } catch (Exception e) {
            System.err.println("Erro " + e.getMessage());
        }
    }
}
