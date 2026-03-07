import sys
import time
import tracemalloc
import os
import gc

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
def measure_time(func, runs=30, setup=None):
    total = 0
    for run in range(runs):
        gc.collect()
        if setup: setup()
        gc.disable()
        start = time.perf_counter()
        func()
        end = time.perf_counter()
        gc.enable()
        total += (end - start)
    return (total / runs) * 1000


# ----- MEDIÇÃO DE MEMÓRIA -----
def measure_memory(func, runs=30, setup=None):
    total = 0
    for run in range(runs):
        gc.collect()
        if setup: setup()
        gc.disable()
        tracemalloc.start()
        func()
        current, peak = tracemalloc.get_traced_memory()
        tracemalloc.stop()
        gc.enable()
        total += peak
    return int(total / runs)


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

    list_manual = None
    list_native = None

    # setup reconstroi a list antes dos runs nas remoções por índice ou adições.
    def setup_manual():
        nonlocal list_manual
        list_manual = ArrayListManual(10)
        insert_manual(False)

    def setup_native():
        nonlocal list_native
        list_native = ArrayListNativo(10)
        insert_native(False)

    def setup_manual_empty():
        nonlocal list_manual
        list_manual = ArrayListManual(10)

    def setup_native_empty():
        nonlocal list_native
        list_native = ArrayListNativo(10)

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

            w.write("Linguagem_Tipo, Tamanho, Operacao, Tempo(ms), Memoria(bytes)\n")

            for n in sizes:
                current_data = data[:n] # Fatiamento para testar código com diferentes sizes

                # ---------- INSERÇÃO ----------

                # adições por índice (adição + shiftRight) - inicio:
                t_manual_add = measure_time(lambda: insert_manual(True), setup=setup_manual_empty)
                m_manual_add = measure_memory(lambda: insert_manual(True), setup=setup_manual_empty)
                w.write(f"Python_ArrayManual,{n},adicaoInicio,{t_manual_add:.3f},{m_manual_add}\n")

                t_native_add = measure_time(lambda: insert_native(True), setup=setup_native_empty)
                m_native_add = measure_memory(lambda: insert_native(True), setup=setup_native_empty)
                w.write(f"Python_ArrayNativo,{n},adicaoInicio,{t_native_add:.3f},{m_native_add}\n")

                # adições sem índice - final:
                t_manual_add = measure_time(lambda: insert_manual(False), setup=setup_manual_empty)
                m_manual_add = measure_memory(lambda: insert_manual(False), setup=setup_manual_empty)
                w.write(f"Python_ArrayManual,{n},adicaoFinal,{t_manual_add:.3f},{m_manual_add}\n")

                t_native_add = measure_time(lambda: insert_native(False), setup=setup_native_empty)
                m_native_add = measure_memory(lambda: insert_native(False), setup=setup_native_empty)
                w.write(f"Python_ArrayNativo,{n},adicaoFinal,{t_native_add:.3f},{m_native_add}\n")

                
                # ------ BUSCA (PIOR CASO -> 7) ------
                setup_manual()
                t_manual_search = measure_time(lambda: list_manual.search(target))
                m_manual_search = measure_memory(lambda: list_manual.search(target))
                w.write(f"Python_ArrayManual,{n},busca,{t_manual_search:.3f},{m_manual_search}\n")

                setup_native()
                t_native_search = measure_time(lambda: list_native.search(target))
                m_native_search = measure_memory(lambda: list_native.search(target))
                w.write(f"Python_ArrayNativo,{n},busca,{t_native_search:.3f},{m_native_search}\n")


    
                # ---------- REMOÇÃO -----------

                # remoção no pior caso (elemento não está na lista)
                setup_manual()
                t_manual_remove = measure_time(lambda: list_manual.removePorElement(target))
                m_manual_remove = measure_memory(lambda: list_manual.removePorElement(target))
                w.write(f"Python_ArrayManual,{n},remocaoValor,{t_manual_remove:.3f},{m_manual_remove}\n")

                setup_native()
                t_native_remove = measure_time(lambda: list_native.remove_Element(target))
                m_native_remove = measure_memory(lambda: list_native.remove_Element(target))
                w.write(f"Python_ArrayNativo,{n},remocaoValor,{t_native_remove:.3f},{m_native_remove}\n")

                # remoção por índice 0 (remoção + shiftLeft)
                t_manual_remove = measure_time(lambda: list_manual.removePorindex(0), setup=setup_manual)
                m_manual_remove = measure_memory(lambda: list_manual.removePorindex(0), setup=setup_manual)
                w.write(f"Python_ArrayManual,{n},remocaoIndice,{t_manual_remove:.3f},{m_manual_remove}\n")

                t_native_remove = measure_time(lambda: list_native.remove_index(0), setup=setup_native)
                m_native_remove = measure_memory(lambda: list_native.remove_index(0), setup=setup_native)
                w.write(f"Python_ArrayNativo,{n},remocaoIndice,{t_native_remove:.3f},{m_native_remove}\n")

    except Exception as e:
        print("Erro ao escrever CSV:", e)


if __name__ == "__main__":
    main()