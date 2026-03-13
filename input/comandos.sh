# Adicione a linha de código que executa a sua parte a partir da raiz do projeto
# Para rodar é só usar os seguintes comandos na raiz do projeto:
# chmod +x input/comandos.sh
# ./input/comandos.sh

set -e

go -C Implementacoes/Go run . input/entrada.txt Resultados/Go/ 10000,30000,50000,100000 10000
java -cp Implementacoes/Java Main input/entrada.txt Resultados/Java/ 10000,30000,50000,100000 10000
python Implementacoes/Python/Main.py input/entrada.txt Resultados/Python 10000,30000,50000,100000 10000
./main_haskell /input entrada.txt 10000 30000 50000 100000 10000
./benchmark "10000,30000,50000,100000" 1000000
