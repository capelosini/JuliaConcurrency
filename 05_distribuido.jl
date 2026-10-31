# ==============================================================================
# Parte 2: Outros modelos - Computação Distribuída
# Permite rodar código em múltiplos processos físicos ou em rede (clusters).
# Memória não é compartilhada. Comunicação feita via RPC (Remote Procedure Call).
# ==============================================================================

using Distributed

println("Iniciando workers...")
# Adiciona 2 processos paralelos isolados
addprocs(2)

println("Processos ativos: ", procs())

# @everywhere garante que a função/código exista em todos os processos (workers)
@everywhere function computacao_lenta_isolada(matriz)
    println("Executando no processo: ", myid())
    # Simula cálculo pesado
    return sum(matriz ^ 2)
end

function executar_distribuido()
    dados = rand(500, 500)

    # @spawnat envia o cálculo para um worker específico.
    # Retorna um 'Future' (Promessa inter-processo)
    println("Delegando para worker 2...")
    futuro = @spawnat 2 computacao_lenta_isolada(dados)

    println("Fazendo trabalho local no processo principal (", myid(), ")...")

    # Recupera o valor via rede
    resultado = fetch(futuro)
    println("Cálculo finalizado. Valor: ", resultado)
end

executar_distribuido()
