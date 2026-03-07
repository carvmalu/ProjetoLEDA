#include <iostream>
#include <vector>
#include <chrono>
#include <fstream>
#include <sys/resource.h>
#include <sys/stat.h> 
#include "ArrayListF.hpp"
#include "ArrayListNM.hpp"

using namespace std;
using namespace std::chrono;

// Medição de memória RSS em Bytes (Linux)
long get_mem() { 
    struct rusage u; 
    getrusage(RUSAGE_SELF, &u); 
    return u.ru_maxrss * 1024; 
}

void rodar_teste_rapido(int n, ofstream& f, string tipo) {
    const int target = 7; 

    for (int r = 0; r < 30; r++) {
        if (tipo == "CPP_ArrayManual") {
            ArrayListF l(n + 5); 
            for(int i = 0; i < n; i++) l.add(i);

            auto s1 = high_resolution_clock::now(); l.addInicio(999); auto e1 = high_resolution_clock::now();
            f << tipo << "," << n << ",adicaoInicio," << duration<double, milli>(e1-s1).count() << "," << get_mem() << "\n";

            auto s2 = high_resolution_clock::now(); l.add(888); auto e2 = high_resolution_clock::now();
            f << tipo << "," << n << ",adicaoFinal," << duration<double, milli>(e2-s2).count() << "," << get_mem() << "\n";

            auto s3 = high_resolution_clock::now(); l.search(target); auto e3 = high_resolution_clock::now();
            f << tipo << "," << n << ",busca," << duration<double, milli>(e3-s3).count() << "," << get_mem() << "\n";

            auto s4 = high_resolution_clock::now(); l.removeByValue(target); auto e4 = high_resolution_clock::now();
            f << tipo << "," << n << ",remocaoValor," << duration<double, milli>(e4-s4).count() << "," << get_mem() << "\n";

            auto s5 = high_resolution_clock::now(); l.removeByIndex(0); auto e5 = high_resolution_clock::now();
            f << tipo << "," << n << ",remocaoIndice," << duration<double, milli>(e5-s5).count() << "," << get_mem() << "\n";

        } else {
            ArrayListNM l(n + 5); 
            for(int i = 0; i < n; i++) l.add(i);

            auto s1 = high_resolution_clock::now(); l.addInicio(999); auto e1 = high_resolution_clock::now();
            f << tipo << "," << n << ",adicaoInicio," << duration<double, milli>(e1-s1).count() << "," << get_mem() << "\n";

            auto s2 = high_resolution_clock::now(); l.add(888); auto e2 = high_resolution_clock::now();
            f << tipo << "," << n << ",adicaoFinal," << duration<double, milli>(e2-s2).count() << "," << get_mem() << "\n";

            auto s3 = high_resolution_clock::now(); l.search(target); auto e3 = high_resolution_clock::now();
            f << tipo << "," << n << ",busca," << duration<double, milli>(e3-s3).count() << "," << get_mem() << "\n";

            auto s4 = high_resolution_clock::now(); l.removeByValue(target); auto e4 = high_resolution_clock::now();
            f << tipo << "," << n << ",remocaoValor," << duration<double, milli>(e4-s4).count() << "," << get_mem() << "\n";

            auto s5 = high_resolution_clock::now(); l.removeByIndex(0); auto e5 = high_resolution_clock::now();
            f << tipo << "," << n << ",remocaoIndice," << duration<double, milli>(e5-s5).count() << "," << get_mem() << "\n";
        }
    }
}

int main() {
    // Caminho ajustado para o nome correto
    ofstream f("../../Resultados/Java/resultadosC++.csv");
    
    if (!f.is_open()) {
        cerr << "Erro fatal: Nao foi possivel criar 'Resultados/resultadosC++.csv'" << endl;
        cerr << "Certifique-se de que voce tem permissao de escrita na pasta atual." << endl;
        return 1;
    }

    f << "Linguagem_Tipo,Tamanho,Operacao,Tempo(ms),Memoria(bytes)\n";

    vector<int> tamanhos = {10000, 30000, 50000};

    for (int n : tamanhos) {
        cout << "Executando teste rapido para n = " << n << "..." << endl;
        rodar_teste_rapido(n, f, "CPP_ArrayManual");
        rodar_teste_rapido(n, f, "CPP_ArrayNativo");
    }

    f.close();
    cout << "Teste finalizado! Verifique: Resultados/resultadosC++.csv" << endl;
    return 0;
}