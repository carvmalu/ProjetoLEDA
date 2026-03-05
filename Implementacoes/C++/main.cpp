#include <iostream>
#include <chrono>
#include <vector>
#include <fstream>
#include "ArrayListF.hpp"
#include "ArrayListNM.hpp"

using namespace std;
using namespace std::chrono;

int main() {
    int totalElementos = 50000;

    // 1. Versão Iterativa (FOR)
    ArrayListF listaFor(10);
    auto startF = high_resolution_clock::now();
    for(int i = 0; i < totalElementos; i++) listaFor.add(0, i);
    auto endF = high_resolution_clock::now();

    // 2. Versão Nativa (std::move/copy)
    ArrayListNM listaNM(10);
    auto startNM = high_resolution_clock::now();
    for(int i = 0; i < totalElementos; i++) listaNM.add(0, i);
    auto endNM = high_resolution_clock::now();

    // 3. Versão Build-in (std::vector)
    vector<int> listaCpp;
    auto startCpp = high_resolution_clock::now();
    for(int i = 0; i < totalElementos; i++) listaCpp.insert(listaCpp.begin(), i);
    auto endCpp = high_resolution_clock::now();

    // Cálculos de tempo em ms
    auto durF = duration_cast<milliseconds>(endF - startF).count();
    auto durNM = duration_cast<milliseconds>(endNM - startNM).count();
    auto durCpp = duration_cast<milliseconds>(endCpp - startCpp).count();

    cout << "Tempo com FOR: " << durF << "ms" << endl;
    cout << "Tempo com NM (std::copy): " << durNM << "ms" << endl;
    cout << "Tempo std::vector: " << durCpp << "ms" << endl;

    // Gerar CSV
    ofstream file("../../Resultados/Java/resultadosC++.csv");
    if (file.is_open()) {
        file << "Implementacao,TempoMS\n";
        file << "Iterativa For," << durF << "\n";
        file << "Nativa copy," << durNM << "\n";
        file << "C++ Oficial (vector)," << durCpp << "\n";
        file.close();
        cout << "Arquivo gerado com sucesso!" << endl;
    }

    return 0;
}