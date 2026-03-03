import java.util.*;
import java.io.*;
//https://blog.formacao.dev/manipulacao-de-arquivos-csv-em-java-leitura-e-escrita/

// Testes Isolados com o pior caso.
public class Main {
    public static void main(String[] args) {
        int totalElementos = 50000;

        //Versão iterativa.
        ArrayListF listaFor = new ArrayListF(10);
        long startF = System.currentTimeMillis();
        
        for(int i = 0; i < totalElementos; i++) 
            listaFor.add(0, i);
        long endF = System.currentTimeMillis();

        // Versão com método nativo de java (arraycopy).
        ArrayListNM listaNM = new ArrayListNM(10);
        long startNM = System.currentTimeMillis();

        for(int i = 0; i < totalElementos; i++) 
            listaNM.add(0, i);
        long endNM = System.currentTimeMillis();

        // Versão build in do Java
        ArrayList<Integer> listaJava = new ArrayList<>();
        long startJ = System.currentTimeMillis();

        for(int i = 0; i < totalElementos; i++) 
            listaJava.add(0, i);
       
        long endJ = System.currentTimeMillis();

        // Saída resultados.
        System.out.println("Tempo com FOR: " + (endF - startF) + "ms");
        System.out.println("Tempo com NM (arraycopy): " + (endNM - startNM) + "ms");
        System.out.println("Tempo ArrayList Oficial: " + (endJ - startJ) + "ms");

       try (PrintWriter w = new PrintWriter("../../Resultados/Java/resultados.csv")) {
        w.println("Implementacao,TempoMS");
        w.println("Iterativa For," + (endF - startF));
        w.println("Nativa arraycopy," + (endNM - startNM));
        w.println("Java Oficial," + (endJ - startJ));
        System.out.println("Arquivo gerado em Resultados/Java!");
    } catch (Exception e) { 
        System.out.println("Erro: Verifique se a pasta existe."); 
    }
    }
}

