#include <iostream>
#include <vector>
#include <chrono>
#include <fstream>
#include <sys/resource.h>
#include <map>
#include <string>
#include "ArrayListF.hpp"
#include "ArrayListNM.hpp"

using namespace std;
using namespace std::chrono;

// Estruturas para acumular estatísticas (médias)
struct Stats {
    double somaTempo = 0.0;
    long long somaMem = 0;
    long long count = 0;
};

struct Chave {
    string tipo;
    int n;
    string op;

    bool operator<(const Chave& other) const {
        if (tipo != other.tipo) return tipo < other.tipo;
        if (n != other.n) return n < other.n;
        return op < other.op;
    }
};

// Captura memória RSS em Bytes no Linux
long get_memory_usage() {
    struct rusage usage;
    getrusage(RUSAGE_SELF, &usage);
    return usage.ru_maxrss * 1024; 
}

void run_test(int n, ofstream& csv, string tipo, map<Chave, Stats>& estatisticas) {
    const int target = 7; // Valor que não existe para pior caso

    // Setup: Criar e popular a lista
    ArrayListF* listF = nullptr;
    ArrayListNM* listNM = nullptr;

    if (tipo == "CPP_ArrayManual") {
        listF = new ArrayListF(n + 1);
        for(int i = 1; i <= n; i++) listF->add(i);
    } else {
        listNM = new ArrayListNM(n + 1);
        for(int i = 1; i <= n; i++) listNM->add(i);
    }

    auto medir = [&](string op, auto func) {
        auto start = high_resolution_clock::now();
        func();
        auto end = high_resolution_clock::now();

        double tempo = duration<double, milli>(end - start).count();
        long long memoria = get_memory_usage();

        // REMOVA A LINHA ABAIXO (ela que cria as milhões de linhas)
        // csv << tipo << "," << n << "," << op << "," << tempo << "," << memoria << "\n";

        // Mantenha apenas o acúmulo das estatísticas
        Chave chave{tipo, n, op};
        auto& st = estatisticas[chave];
        st.somaTempo += tempo;
        st.somaMem += memoria;
        st.count += 1;
    };

    if (tipo == "CPP_ArrayManual") {
        medir("busca", [&](){ listF->search(target); });
        medir("adicaoInicio", [&](){ listF->addInicio(999); });
        medir("remocaoIndice", [&](){ listF->removeByIndex(0); });
        medir("remocaoValor", [&](){ listF->removeByValue(target); });
        delete listF;
    } else {
        medir("busca", [&](){ listNM->search(target); });
        medir("adicaoInicio", [&](){ listNM->addInicio(999); });
        medir("remocaoIndice", [&](){ listNM->removeByIndex(0); });
        medir("remocaoValor", [&](){ listNM->removeByValue(target); });
        delete listNM;
    }
}

int main() {
    ofstream csv("../../Resultados/Cpp/resultadosC++.csv");
    csv << "Linguagem_Tipo,Tamanho,Operacao,Tempo(ms),Memoria(bytes)\n";

    // mapa para acumular estatísticas e depois gerar médias
    map<Chave, Stats> estatisticas;

    auto start_global = system_clock::now();
    auto duration_limit = hours(8);

    cout << "Benchmark iniciado. Rodando por 8 horas..." << endl;

    while (system_clock::now() - start_global < duration_limit) {
        for (int n : {10000, 30000, 50000}) {
            run_test(n, csv, "CPP_ArrayManual", estatisticas);
            run_test(n, csv, "CPP_ArrayNativo", estatisticas);
            csv.flush(); // Garante gravação em caso de queda de energia
        }
    }

    csv.close();

    // Gera um segundo CSV apenas com as médias
    ofstream csvMedias("../../Resultados/Cpp/resultadosC++_medias.csv");
    csvMedias << "Linguagem_Tipo,Tamanho,Operacao,TempoMedio(ms),MemoriaMedia(bytes),Execucoes\n";

    for (const auto& par : estatisticas) {
        const Chave& chave = par.first;
        const Stats& st = par.second;
        if (st.count == 0) continue;

        double tempoMedio = st.somaTempo / st.count;
        long long memoriaMedia = st.somaMem / st.count;

        csvMedias << chave.tipo << ","
                  << chave.n << ","
                  << chave.op << ","
                  << tempoMedio << ","
                  << memoriaMedia << ","
                  << st.count << "\n";
    }

    csvMedias.close();

    cout << "Fim do teste. Resultados detalhados em resultadosC++.csv e médias em resultadosC++_medias.csv" << endl;
    return 0;
}