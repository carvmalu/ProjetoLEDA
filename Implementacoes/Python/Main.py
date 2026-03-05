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

    try:

        with open(output_path, "w") as w:

            w.write("Language,Implementation,Operation,Metric,N,TimeMS/Bytes")

            for n in sizes:
                current_data = data[:n]

                # ----- INSERÇÃO -----
                list_manual = ArrayListManual(10)
                t_manual_add = measure_time(
                    lambda: [list_manual.addNoindexElement(0, x) for x in current_data])
                w.write(f"Python,ArrayListManual,Insercao,Tempo,{n},{t_manual_add}\n")

                list_native = ArrayListNativo(10)
                t_native_add = measure_time(
                    lambda: [list_native.add_index_element(0, x) for x in current_data])
                w.write(f"Python,ArrayListNativo,Insercao,Tempo,{n},{t_native_add}\n")

                list_manual_mem = ArrayListManual(10)
                m_manual_add = measure_memory(
                    lambda: [list_manual_mem.addNoindexElement(0, x) for x in current_data])
                w.write(f"Python,ArrayListManual,Insercao,Memoria,{n},{m_manual_add}\n")

                list_native_mem = ArrayListNativo(10)
                m_native_add = measure_memory(
                    lambda: [list_native_mem.add_index_element(0, x) for x in current_data])
                w.write(f"Python,ArrayListNativo,Insercao,Memoria,{n},{m_native_add}\n")

                
                # ------ BUSCA (PIOR CASO -> 7) ------
                t_manual_search = measure_time(lambda: list_manual.search(target))
                w.write(f"Python,ArrayListManual,Search,Tempo,{n},{t_manual_search}\n")

                t_native_search = measure_time(lambda: list_native.search(target))
                w.write(f"Python,ArrayListNativo,Search,Tempo,{n},{t_native_search}\n")

                m_manual_search = measure_memory(lambda: list_manual_mem.search(target))
                w.write(f"Python,ArrayListManual,Search,Memoria,{n},{m_manual_search}\n")

                m_native_search = measure_memory(lambda: list_native_mem.search(target))
                w.write(f"Python,ArrayListNativo,Search,Memoria,{n},{m_native_search}\n")


    
                # ----- REMOÇÃO (PIOR CASO -> 7) ------
                t_manual_remove = measure_time(lambda: list_manual.removePorElement(target))
                w.write(f"Python,ArrayListManual,Remocao,Tempo,{n},{t_manual_remove}\n")

                t_native_remove = measure_time(
                    lambda: list_native.remove_index(list_native.search(target)))
                w.write(f"Python,ArrayListNativo,Remocao,Tempo,{n},{t_native_remove}\n")

                m_manual_remove = measure_memory(
                    lambda: list_manual_mem.removePorElement(target))
                w.write(f"Python,ArrayListManual,Remocao,Memoria,{n},{m_manual_remove}\n")
                
                m_native_remove = measure_memory(
                    lambda: list_native_mem.remove_index(list_native_mem.search(target)))
                w.write(f"Python,ArrayListNativo,Remocao,Memoria,{n},{m_native_remove}\n")

    except Exception as e:
        print("Erro ao escrever CSV:", e)


if __name__ == "__main__":
    main()