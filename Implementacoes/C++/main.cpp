#include <iostream>
#include <vector>
#include <chrono>
#include <fstream>
#include <sys/resource.h>
#include "ArrayListF.hpp"
#include "ArrayListNM.hpp"

using namespace std;
using namespace std::chrono;

long get_mem() { struct rusage u; getrusage(RUSAGE_SELF, &u); return u.ru_maxrss * 1024; }

void rodar(int n, ofstream& f, string tipo) {
    for (int r = 0; r < 30; r++) {
        if (tipo == "CPP_Manual") {
            ArrayListF l(n + 1); for(int i=0; i<n; i++) l.add(i);
            auto s = high_resolution_clock::now(); l.search(7); auto e = high_resolution_clock::now();
            f << tipo << "," << n << ",busca," << duration<double, milli>(e-s).count() << "," << get_mem() << "\n";
            // Adicione as outras operações aqui seguindo o mesmo padrão...
        } else {
            ArrayListNM l(n + 1); for(int i=0; i<n; i++) l.add(i);
            auto s = high_resolution_clock::now(); l.search(7); auto e = high_resolution_clock::now();
            f << tipo << "," << n << ",busca," << duration<double, milli>(e-s).count() << "," << get_mem() << "\n";
        }
    }
}

int main() {
    ofstream f("../../Resultados/Java/resultadosC++.csv");
    f << "Linguagem_Tipo,Tamanho,Operacao,Tempo(ms),Memoria(bytes)\n";
    for (int n : {10000, 30000, 50000}) {
        cout << "Testando tamanho: " << n << endl;
        rodar(n, f, "CPP_Manual");
        rodar(n, f, "CPP_Nativo");
    }
    f.close();
    cout << "Teste concluído! Verifique o arquivo teste_resultados.csv" << endl;
    return 0;
}