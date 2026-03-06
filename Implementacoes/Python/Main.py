import sys
import time
import tracemalloc
import os

from ArrayListManual import ArrayListManual
from ArrayListNativo import ArrayListNativo


# ----- LEITURA DOS DADOS ------
def read_data(filepath, max_n):
    data = []
    try:
        with open(filepath, "r") as f:
            for line in f:
                for word in line.split():
                    data.append(int(word))
                    if len(data) == max_n:
                        return data

    except FileNotFoundError:
        print("Erro: arquivo de entrada não encontrado.")
        sys.exit(1)
    return data


# ----- MEDIÇÃO DE TEMPO ------
def measure_time(func):
    start = time.perf_counter()
    func()
    end = time.perf_counter()
    return (end - start) * 1000


# ----- MEDIÇÃO DE MEMÓRIA -----
def measure_memory(func):
    tracemalloc.start()
    func()
    current, peak = tracemalloc.get_traced_memory()
    tracemalloc.stop()
    return peak


# ----- TESTES DOS MÉTODOS: ------
def main():
    input_file = sys.argv[1]
    path = sys.argv[2]
    sizes = [int(x) for x in sys.argv[3].split(",")]

    output_file = "PythonResults.csv"

    os.makedirs(path, exist_ok=True)
    output_path = os.path.join(path, output_file)
    max_size = max(sizes)

    data = read_data(input_file, max_size)

    # Elemento que não existe para testar métodos no pior caso:
    target = 7

    # Para inserção sem criação de lista extra na memória:
    def insert_manual(porIndice):
        for x in current_data:
            if (porIndice):
                list_manual.addNoindexElement(0, x) #add inicio.
            else:
                list_manual.addElement(x) #add final.

    def insert_native(porIndice):
        for x in current_data:
            if (porIndice):
                list_native.add_index_element(0, x) #add inicio.
            else:
                list_native.add_element(x) #add final.

    try:

        with open(output_path, "w") as w:

            w.write("Linguagem_Tipo, Operacao, Tempo(ms), Memoria(bytes)\n")

            for n in sizes:
                current_data = data[:n] # Fatiamento para testar código com diferentes sizes

                # ---------- INSERÇÃO ----------

                # adições por índice (adição + shiftRight) - inicio:
                list_manual = ArrayListManual(10)
                t_manual_add = measure_time(lambda: insert_manual(True))

                list_manual = ArrayListManual(10)
                m_manual_add = measure_memory(lambda: insert_manual(True))
                w.write(f"Python_ArrayManual,adicaoInicio,{t_manual_add},{m_manual_add}\n")

                list_native = ArrayListNativo(10)
                t_native_add = measure_time(lambda: insert_native(True))

                list_native = ArrayListNativo(10)
                m_native_add = measure_memory(lambda: insert_native(True))
                w.write(f"Python_ArrayNativo,adicaoInicio,{t_native_add},{m_native_add}\n")

                # adições sem índice - final:
                list_manual = ArrayListManual(10)
                t_manual_add = measure_time(lambda: insert_manual(False))

                list_manual = ArrayListManual(10)
                m_manual_add = measure_memory(lambda: insert_manual(False))
                w.write(f"Python_ArrayManual,adicaoFinal,{t_manual_add},{m_manual_add}\n")

                list_native = ArrayListNativo(10)
                t_native_add = measure_time(lambda: insert_native(False))

                list_native = ArrayListNativo(10)
                m_native_add = measure_memory(lambda: insert_native(False))
                w.write(f"Python_ArrayNativo,adicaoFinal,{t_native_add},{m_native_add}\n")

                
                # ------ BUSCA (PIOR CASO -> 7) ------
                list_manual = ArrayListManual(10)
                insert_manual(False)
                t_manual_search = measure_time(lambda: list_manual.search(target))
                m_manual_search = measure_memory(lambda: list_manual.search(target))
                w.write(f"Python_ArrayManual,busca,{t_manual_search},{m_manual_search}\n")

                list_native = ArrayListNativo(10)
                insert_native(False)
                t_native_search = measure_time(lambda: list_native.search(target))
                m_native_search = measure_memory(lambda: list_native.search(target))
                w.write(f"Python_ArrayNativo,busca,{t_native_search},{m_native_search}\n")


    
                # ---------- REMOÇÃO -----------

                # remoção no pior caso (elemento não está na lista)
                list_manual = ArrayListManual(10)
                insert_manual(False)
                t_manual_remove = measure_time(lambda: list_manual.removePorElement(target))
                m_manual_remove = measure_memory(lambda: list_manual.removePorElement(target))
                w.write(f"Python_ArrayManual,remocaoValor,{t_manual_remove},{m_manual_remove}\n")

                list_native = ArrayListNativo(10)
                insert_native(False)
                t_native_remove = measure_time(lambda: list_native.remove_Element(target))
                m_native_remove = measure_memory(lambda: list_native.remove_Element(target))
                w.write(f"Python_ArrayNativo,remocaoValor,{t_native_remove},{m_native_remove}\n")

                # remoção por índice qualquer (remoção + shiftLeft)
                list_manual = ArrayListManual(10)
                insert_manual(False)
                t_manual_remove = measure_time(lambda: list_manual.removePorindex(5))

                list_manual = ArrayListManual(10)
                insert_manual(False)
                m_manual_remove = measure_memory(lambda: list_manual.removePorindex(5))
                w.write(f"Python_ArrayManual,remocaoIndice,{t_manual_remove},{m_manual_remove}\n")

                list_native = ArrayListNativo(10)
                insert_native(False)
                t_native_remove = measure_time(lambda: list_native.remove_index(5))
            
                list_native = ArrayListNativo(10)
                insert_native(False)
                m_native_remove = measure_memory(lambda: list_native.remove_index(5))
                w.write(f"Python_ArrayNativo,remocaoIndice,{t_native_remove},{m_native_remove}\n")

    except Exception as e:
        print("Erro ao escrever CSV:", e)


if __name__ == "__main__":
    main()