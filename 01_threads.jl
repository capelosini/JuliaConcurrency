# ==============================================================================
# Parte 1: Criação e uso de Threads em Julia
# Como rodar: inicie a linguagem com `julia -t auto` ou `julia -t 4`
# ==============================================================================

using Base.Threads

println("Número de threads disponíveis: ", nthreads())

# Exemplo 1: Uso da macro @threads para paralelizar um laço for
function operacao_vetorial()
    dados = zeros(Int, 10)

    # A macro distribui automaticamente as iterações pelo pool de threads
    @threads for i in 1:10
        # threadid() retorna qual thread está processando a iteração atual.
        # No Julia 1.12+, com `-t 4`, os ids vão de 2 a 5 (a thread 1 é
        # reservada para o pool interativo); use `-t 4,0` para obter 1..4.
        dados[i] = threadid()
        sleep(0.1) # Simulando trabalho
    end

    println("Resultado das iterações distribuídas: ", dados)
end

# Exemplo 2: Uso da macro @spawn para criar tarefas paralelas dinâmicas
function operacao_dinamica()
    println("Delegando tarefa pesada para o background...")

    tarefa = @spawn begin
        soma = 0
        for i in 1:10^6
            soma += i
        end
        return soma
    end

    println("Fazendo outra coisa na thread principal...")

    # fetch aguarda o término da tarefa delegada e recupera o retorno
    resultado = fetch(tarefa)
    println("Resultado da tarefa em background: ", resultado)
end

operacao_vetorial()
operacao_dinamica()
