import sys
import time
import tracemalloc
import os
import gc

from ArrayListManual import ArrayListManual
from ArrayListNativo import ArrayListNativo


# ---------- LEITURA DOS DADOS ----------
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


# ---------- MEDIÇÃO DE TEMPO ----------
def measure_time(func, runs, restore=None):

    total = 0
    gc.disable()
    for run in range(runs):
        gc.collect()
        start = time.perf_counter()
        func()
        end = time.perf_counter()
        
        if restore: restore()
        total += (end - start)
    gc.enable()
    return (total / runs) * 1000


# ---------- MEDIÇÃO DE MEMÓRIA ----------
def measure_memory(func, runs, restore=None):

    total = 0
    tracemalloc.start()
    gc.disable()
    for run in range(runs):
        gc.collect()
        tracemalloc.reset_peak()
        func()
        _, peak = tracemalloc.get_traced_memory()
        if restore: restore()
        total += peak
    gc.enable()
    tracemalloc.stop()
    return int(total / runs)


# ---------- MAIN ----------
def main():

    input_file = sys.argv[1]
    path = sys.argv[2]
    sizes = [int(x) for x in sys.argv[3].split(",")]
    runs = int(sys.argv[4])

    os.makedirs(path, exist_ok=True)
    output_path = os.path.join(path, "resultados.csv")
    max_size = max(sizes)
    data = read_data(input_file, max_size)

    # Valor para testes de busca, remoção e inserção.
    search_target = 7
    remove_target = -7
    insert_value = 824

    try:

        with open(output_path, "w") as w:
            w.write("Linguagem_Tipo,Tamanho,Operacao,Tempo(ms),Memoria(bytes)\n")

            for n in sizes:
                current_data = data[:n]

                # Criação de lista com capacidade 10...
                list_manual = ArrayListManual(10)
                list_native = ArrayListNativo(10)

                # ... Preenchimento da lista com valores de entrada até n.
                for x in current_data:
                    list_manual.addElement(x)
                    list_native.add_element(x)

                
                # inserção de valor + remoção de valor para prox teste de inserção na lista previamente cheia.
                def insert_manual():
                    list_manual.addNoindexElement(0, insert_value)
                def restore_manual_add():
                    list_manual.removePorindex(0)

                def insert_native():
                    list_native.add_index_element(0, insert_value)
                def restore_native_add():
                    list_native.remove_index(0)
                

                 # ---------- INSERÇÃO ----------
                t_manual_add = measure_time(insert_manual, runs, restore=restore_manual_add)
                m_manual_add = measure_memory(insert_manual, runs, restore=restore_manual_add)
                w.write(f"Python_ArrayManual,{n},adicaoIndice,{t_manual_add:.3f},{m_manual_add}\n")

                t_native_add = measure_time(insert_native, runs, restore=restore_native_add)
                m_native_add = measure_memory(insert_native, runs, restore=restore_native_add)
                w.write(f"Python_ArrayNativo,{n},adicaoIndice,{t_native_add:.3f},{m_native_add}\n")


                # ---------- BUSCA (pior caso -> valor não existe na lista)  ----------
                t_manual_search = measure_time(lambda: list_manual.search(search_target), runs,)
                m_manual_search = measure_memory(lambda: list_manual.search(search_target), runs,)
                w.write(f"Python_ArrayManual,{n},busca,{t_manual_search:.3f},{m_manual_search}\n")

                t_native_search = measure_time(lambda: list_native.search(search_target), runs,)
                m_native_search = measure_memory(lambda: list_native.search(search_target), runs,)
                w.write(f"Python_ArrayNativo,{n},busca,{t_native_search:.3f},{m_native_search}\n")


                # ---------- REMOÇÃO ----------

                # realocação apenas do valor removido para medições de tempo e memória.
                def restore_manual():
                    list_manual.addNoindexElement(0, remove_target)

                def restore_native():
                    list_native.add_index_element(0, remove_target)
                
                #Valores definidos para limitar quem tá sendo removido (por valor ou indice) e readicionado para próximo run.
                list_manual.addNoindexElement(0, remove_target) 
                list_native.add_index_element(0, remove_target)

                # Remoção por valor (search + shiftLeft em teste - ciclo de adiicona target -> remove -> recomeça)
                t_manual_remove = measure_time(lambda: list_manual.removePorElement(remove_target), runs, restore=restore_manual)
                m_manual_remove = measure_memory(lambda: list_manual.removePorElement(remove_target), runs, restore=restore_manual)
                w.write(f"Python_ArrayManual,{n},remocaoValor,{t_manual_remove:.3f},{m_manual_remove}\n")

                t_native_remove = measure_time(lambda: list_native.remove_Element(remove_target), runs, restore=restore_native)
                m_native_remove = measure_memory(lambda: list_native.remove_Element(remove_target), runs, restore=restore_native)
                w.write(f"Python_ArrayNativo,{n},remocaoValor,{t_native_remove:.3f},{m_native_remove}\n")


                # Remoção por índice (shiftLeft em teste - ciclo de adiicona target -> remove -> recomeça)
                t_manual_remove = measure_time(lambda: list_manual.removePorindex(0), runs, restore=restore_manual)
                m_manual_remove = measure_memory(lambda: list_manual.removePorindex(0), runs, restore=restore_manual)
                w.write(f"Python_ArrayManual,{n},remocaoIndice,{t_manual_remove:.3f},{m_manual_remove}\n")

                t_native_remove = measure_time(lambda: list_native.remove_index(0), runs, restore=restore_native)
                m_native_remove = measure_memory(lambda: list_native.remove_index(0), runs, restore=restore_native)
                w.write(f"Python_ArrayNativo,{n},remocaoIndice,{t_native_remove:.3f},{m_native_remove}\n")


    except Exception as e:
        print("Erro ao escrever CSV:", e)


if __name__ == "__main__":
    main()