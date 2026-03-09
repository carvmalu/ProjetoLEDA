#include <iostream>
#include <vector>
#include <chrono>
#include <fstream>
#include <numeric>
#include <map>
#include <string>
#include <sys/resource.h>
#include "ArrayListF.hpp"
#include "ArrayListNM.hpp"

using namespace std;
using namespace std::chrono;

// --- ESTRUTURAS DE DADOS ---

struct Stats {
    double somaTempo = 0.0;
    long long somaMem = 0;
    long long count = 0;
};

struct Chave {
    string tipo;
    int n;
    string op;

    // Necessário para usar como chave no std::map
    bool operator<(const Chave& other) const {
        if (tipo != other.tipo) return tipo < other.tipo;
        if (n != other.n) return n < other.n;
        return op < other.op;
    }
};

struct Medias {
    double adicaoIndice, busca, remocaoValor, remocaoIndice;
};

// --- UTILITÁRIOS ---

long get_memory_usage() {
    struct rusage usage;
    getrusage(RUSAGE_SELF, &usage);
    return usage.ru_maxrss * 1024; // Bytes
}

// --- LÓGICA DE BENCHMARK (1 MILHÃO DE EXECUÇÕES) ---

template <typename T>
Medias calcular_medias_bloco(int n) {
    const int target = 7;
    const int remove_target = -7;
    const int runs = 1000000; // Alterado para 1 milhão
    
    vector<double> t_addI, t_search, t_remV, t_remI;
    t_addI.reserve(runs); t_search.reserve(runs);
    t_remV.reserve(runs); t_remI.reserve(runs);

    for(int i = 0; i < runs; i++) {
        T lista(n + 10);
        for(int j = 0; j < n; j++) lista.add(j);

        // 1. adicaoIndice
        auto s = high_resolution_clock::now();
        lista.addInicio(824);
        t_addI.push_back(duration<double, milli>(high_resolution_clock::now() - s).count());

        // 2. busca
        s = high_resolution_clock::now();
        lista.search(target);
        t_search.push_back(duration<double, milli>(high_resolution_clock::now() - s).count());

        // 3. remocaoValor
        lista.addInicio(remove_target);
        s = high_resolution_clock::now();
        lista.removeByValue(remove_target);
        t_remV.push_back(duration<double, milli>(high_resolution_clock::now() - s).count());

        // 4. remocaoIndice
        lista.addInicio(remove_target);
        s = high_resolution_clock::now();
        lista.removeByIndex(0);
        t_remI.push_back(duration<double, milli>(high_resolution_clock::now() - s).count());
    }

    auto calc = [](const vector<double>& v) {
        return accumulate(v.begin(), v.end(), 0.0) / v.size();
    };

    return {calc(t_addI), calc(t_search), calc(t_remV), calc(t_remI)};
}

// --- FUNÇÃO DE REGISTRO ---

void registrar(ofstream& csv, map<Chave, Stats>& est, string tipo, int n, Medias m) {
    auto gravar = [&](string op, double tempo) {
        long mem = get_memory_usage();
        csv << tipo << "," << n << "," << op << "," << tempo << "," << mem << "\n";
        
        Chave c{tipo, n, op};
        est[c].somaTempo += tempo;
        est[c].somaMem += mem;
        est[c].count++;
    };

    gravar("adicaoIndice", m.adicaoIndice);
    gravar("busca", m.busca);
    gravar("remocaoValor", m.remocaoValor);
    gravar("remocaoIndice", m.remocaoIndice);
    csv.flush();
}

// --- MAIN (CONTROLE) ---

int main() {
    // Certifique-se que as pastas existem: mkdir -p ../../Resultados/Cpp/
    ofstream csv("../../Resultados/Cpp/resultadosC++.csv");
    csv << "Linguagem_Tipo,Tamanho,Operacao,Tempo(ms),Memoria(bytes)\n";

    map<Chave, Stats> estatisticas;
    auto start_global = system_clock::now();
    auto limit_8h = hours(8);

    cout << "Benchmark C++ Iniciado (8h | 1 milhão runs por bloco)..." << endl;

    while (system_clock::now() - start_global < limit_8h) {
        for (int n : {10000, 30000, 50000, 100000}) {
            registrar(csv, estatisticas, "CPP_ArrayManual", n, calcular_medias_bloco<ArrayListF>(n));
            registrar(csv, estatisticas, "CPP_ArrayNativo", n, calcular_medias_bloco<ArrayListNM>(n));
        }
    }

    csv.close();

    // Gravação das Médias Finais
    ofstream csvMedias("../../Resultados/Cpp/resultadosC++_medias.csv");
    csvMedias << "Linguagem_Tipo,Tamanho,Operacao,TempoMedio(ms),MemoriaMedia(bytes),TotalBlocos\n";

    for (auto const& [chave, st] : estatisticas) {
        csvMedias << chave.tipo << "," << chave.n << "," << chave.op << ","
                  << (st.somaTempo / st.count) << "," << (st.somaMem / st.count) << "," << st.count << "\n";
    }

    cout << "Fim. Resultados em ../../Resultados/Cpp/" << endl;
    return 0;
}