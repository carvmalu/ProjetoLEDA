# Adicione a linha de código que executa a sua parte a partir da raiz do projeto
# Para rodar é só usar os seguintes comandos na raiz do projeto:
# chmod +x input/comandos.sh
# ./input/comandos.sh

cd Implementacoes/Go && go run . < ../../input/entrada.txt && cd ../..
java -cp Implementacoes/java Main input/entrada.txt Resultados/10000,30000,50000,100000
python Implementacoes/Python/Main.py input/entrada.txt Resultados/Python 10000,30000,50000,100000 1000000
