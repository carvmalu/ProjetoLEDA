cat > ~/ProjetoLEDA/ProjetoLEDA/rodar_testes_300x_final.sh << 'EOF'
#!/bin/bash

cd ~/ProjetoLEDA/ProjetoLEDA
mkdir -p Resultados/Haskell

soma_busca_10k=0
soma_add_inicio_10k=0
soma_rem_indice_10k=0
soma_rem_valor_10k=0

soma_busca_30k=0
soma_add_inicio_30k=0
soma_rem_indice_30k=0
soma_rem_valor_30k=0

soma_busca_50k=0
soma_add_inicio_50k=0
soma_rem_indice_50k=0
soma_rem_valor_50k=0

soma_busca_100k=0
soma_add_inicio_100k=0
soma_rem_indice_100k=0
soma_rem_valor_100k=0

echo "Rodando 300 testes para pegar a média"

for i in {1..300}; do
    if [ $((i % 30)) -eq 0 ]; then
        echo "Execução $i de 300..."
    fi
    
    ./main_haskell 2>/dev/null
    
    busca=$(grep "^Haskell_dataVector,10000,busca," Resultados/resultados_10k.csv | cut -d',' -f4)
    [ ! -z "$busca" ] && soma_busca_10k=$(echo "$soma_busca_10k + $busca" | bc)
    add=$(grep "^Haskell_dataVector,10000,adicaoInicio," Resultados/resultados_10k.csv | cut -d',' -f4)
    [ ! -z "$add" ] && soma_add_inicio_10k=$(echo "$soma_add_inicio_10k + $add" | bc)
    rem=$(grep "^Haskell_dataVector,10000,remocaoIndice," Resultados/resultados_10k.csv | cut -d',' -f4)
    [ ! -z "$rem" ] && soma_rem_indice_10k=$(echo "$soma_rem_indice_10k + $rem" | bc)
    rval=$(grep "^Haskell_dataVector,10000,remocaoValor," Resultados/resultados_10k.csv | cut -d',' -f4)
    [ ! -z "$rval" ] && soma_rem_valor_10k=$(echo "$soma_rem_valor_10k + $rval" | bc)
    
    busca=$(grep "^Haskell_dataVector,30000,busca," Resultados/resultados_30k.csv | cut -d',' -f4)
    [ ! -z "$busca" ] && soma_busca_30k=$(echo "$soma_busca_30k + $busca" | bc)
    add=$(grep "^Haskell_dataVector,30000,adicaoInicio," Resultados/resultados_30k.csv | cut -d',' -f4)
    [ ! -z "$add" ] && soma_add_inicio_30k=$(echo "$soma_add_inicio_30k + $add" | bc)
    rem=$(grep "^Haskell_dataVector,30000,remocaoIndice," Resultados/resultados_30k.csv | cut -d',' -f4)
    [ ! -z "$rem" ] && soma_rem_indice_30k=$(echo "$soma_rem_indice_30k + $rem" | bc)
    rval=$(grep "^Haskell_dataVector,30000,remocaoValor," Resultados/resultados_30k.csv | cut -d',' -f4)
    [ ! -z "$rval" ] && soma_rem_valor_30k=$(echo "$soma_rem_valor_30k + $rval" | bc)
    
    busca=$(grep "^Haskell_dataVector,50000,busca," Resultados/resultados_50k.csv | cut -d',' -f4)
    [ ! -z "$busca" ] && soma_busca_50k=$(echo "$soma_busca_50k + $busca" | bc)
    add=$(grep "^Haskell_dataVector,50000,adicaoInicio," Resultados/resultados_50k.csv | cut -d',' -f4)
    [ ! -z "$add" ] && soma_add_inicio_50k=$(echo "$soma_add_inicio_50k + $add" | bc)
    rem=$(grep "^Haskell_dataVector,50000,remocaoIndice," Resultados/resultados_50k.csv | cut -d',' -f4)
    [ ! -z "$rem" ] && soma_rem_indice_50k=$(echo "$soma_rem_indice_50k + $rem" | bc)
    rval=$(grep "^Haskell_dataVector,50000,remocaoValor," Resultados/resultados_50k.csv | cut -d',' -f4)
    [ ! -z "$rval" ] && soma_rem_valor_50k=$(echo "$soma_rem_valor_50k + $rval" | bc)
    
    busca=$(grep "^Haskell_dataVector,100000,busca," Resultados/resultados_100k.csv | cut -d',' -f4)
    [ ! -z "$busca" ] && soma_busca_100k=$(echo "$soma_busca_100k + $busca" | bc)
    add=$(grep "^Haskell_dataVector,100000,adicaoInicio," Resultados/resultados_100k.csv | cut -d',' -f4)
    [ ! -z "$add" ] && soma_add_inicio_100k=$(echo "$soma_add_inicio_100k + $add" | bc)
    rem=$(grep "^Haskell_dataVector,100000,remocaoIndice," Resultados/resultados_100k.csv | cut -d',' -f4)
    [ ! -z "$rem" ] && soma_rem_indice_100k=$(echo "$soma_rem_indice_100k + $rem" | bc)
    rval=$(grep "^Haskell_dataVector,100000,remocaoValor," Resultados/resultados_100k.csv | cut -d',' -f4)
    [ ! -z "$rval" ] && soma_rem_valor_100k=$(echo "$soma_rem_valor_100k + $rval" | bc)
done

echo "Finalizado a execução vamos calcular as médias..."

# Calcular médias com 2 casas decimais
media_busca_10k=$(echo "scale=2; $soma_busca_10k / 300" | bc)
media_add_inicio_10k=$(echo "scale=2; $soma_add_inicio_10k / 300" | bc)
media_rem_indice_10k=$(echo "scale=2; $soma_rem_indice_10k / 300" | bc)
media_rem_valor_10k=$(echo "scale=2; $soma_rem_valor_10k / 300" | bc)

media_busca_30k=$(echo "scale=2; $soma_busca_30k / 300" | bc)
media_add_inicio_30k=$(echo "scale=2; $soma_add_inicio_30k / 300" | bc)
media_rem_indice_30k=$(echo "scale=2; $soma_rem_indice_30k / 300" | bc)
media_rem_valor_30k=$(echo "scale=2; $soma_rem_valor_30k / 300" | bc)

media_busca_50k=$(echo "scale=2; $soma_busca_50k / 300" | bc)
media_add_inicio_50k=$(echo "scale=2; $soma_add_inicio_50k / 300" | bc)
media_rem_indice_50k=$(echo "scale=2; $soma_rem_indice_50k / 300" | bc)
media_rem_valor_50k=$(echo "scale=2; $soma_rem_valor_50k / 300" | bc)

media_busca_100k=$(echo "scale=2; $soma_busca_100k / 300" | bc)
media_add_inicio_100k=$(echo "scale=2; $soma_add_inicio_100k / 300" | bc)
media_rem_indice_100k=$(echo "scale=2; $soma_rem_indice_100k / 300" | bc)
media_rem_valor_100k=$(echo "scale=2; $soma_rem_valor_100k / 300" | bc)

# Função para formatar números (adicionar 0 antes de . se necessário)
format_number() {
    if [[ $1 == .* ]]; then
        echo "0$1"
    else
        echo "$1"
    fi
}

# Formatar números
media_busca_10k=$(format_number "$media_busca_10k")
media_busca_30k=$(format_number "$media_busca_30k")
media_busca_50k=$(format_number "$media_busca_50k")
media_busca_100k=$(format_number "$media_busca_100k")

echo "Salvando resultados em Resultados/Haskell/..."

# Salvar para 10k
cat > Resultados/Haskell/media_300x_10k.csv << CSV
Linguagem_Tipo,Tamanho,Operacao,Tempo_Media(ms),Memoria(bytes)
Haskell_dataVector,10000,busca,$media_busca_10k,80056
Haskell_dataVector,10000,adicaoInicio,$media_add_inicio_10k,80056
Haskell_dataVector,10000,remocaoIndice,$media_rem_indice_10k,80056
Haskell_dataVector,10000,remocaoValor,$media_rem_valor_10k,80056
CSV

# Salvar para 30k
cat > Resultados/Haskell/media_300x_30k.csv << CSV
Linguagem_Tipo,Tamanho,Operacao,Tempo_Media(ms),Memoria(bytes)
Haskell_dataVector,30000,busca,$media_busca_30k,240056
Haskell_dataVector,30000,adicaoInicio,$media_add_inicio_30k,240056
Haskell_dataVector,30000,remocaoIndice,$media_rem_indice_30k,240056
Haskell_dataVector,30000,remocaoValor,$media_rem_valor_30k,240056
CSV

# Salvar para 50k
cat > Resultados/Haskell/media_300x_50k.csv << CSV
Linguagem_Tipo,Tamanho,Operacao,Tempo_Media(ms),Memoria(bytes)
Haskell_dataVector,50000,busca,$media_busca_50k,400056
Haskell_dataVector,50000,adicaoInicio,$media_add_inicio_50k,400056
Haskell_dataVector,50000,remocaoIndice,$media_rem_indice_50k,400056
Haskell_dataVector,50000,remocaoValor,$media_rem_valor_50k,400056
CSV

# Salvar para 100k
cat > Resultados/Haskell/media_300x_100k.csv << CSV
Linguagem_Tipo,Tamanho,Operacao,Tempo_Media(ms),Memoria(bytes)
Haskell_dataVector,100000,busca,$media_busca_100k,800056
Haskell_dataVector,100000,adicaoInicio,$media_add_inicio_100k,800056
Haskell_dataVector,100000,remocaoIndice,$media_rem_indice_100k,800056
Haskell_dataVector,100000,remocaoValor,$media_rem_valor_100k,800056
CSV

echo ""
echo "Médias de 300 execuções foram salvas em Resultados/Haskell/"
echo ""
echo "10k:"
cat Resultados/Haskell/media_300x_10k.csv
echo ""
echo "30k:"
cat Resultados/Haskell/media_300x_30k.csv
echo ""
echo "50k:"
cat Resultados/Haskell/media_300x_50k.csv
echo ""
echo "100k:"
cat Resultados/Haskell/media_300x_100k.csv
EOF

chmod +x ~/ProjetoLEDA/ProjetoLEDA/rodar_testes_300x_final.sh

