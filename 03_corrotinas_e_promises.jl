# ==============================================================================
# Parte 2: Modelos de Concorrência - Corrotinas (Tasks), Event Loop e Promises
# A execução paralela aqui é concorrente mas cooperativa.
# ==============================================================================

# Criação de Corrotinas (Tasks) com @async
function testar_corrotinas()
    println("1. Iniciando processamento")

    # @async cria uma corrotina leve (Task) no event loop da linguagem
    task1 = @async begin
        sleep(2) # Operação de I/O não bloqueante (cede a execução)
        println("4. Corrotina 1 finalizada")
        return "Sucesso Corrotina 1"
    end

    task2 = @async begin
        sleep(1)
        println("3. Corrotina 2 finalizada antes da 1")
    end

    println("2. Tasks lançadas. Aguardando...")

    # O conceito de "Promise" em Julia é implementado via 'fetch' ou 'wait' sobre uma Task.
    # fetch() bloqueia até que a Task termine e retorna seu valor.
    resultado = fetch(task1)

    println("5. Resultado recuperado (como Promise): ", resultado)
end

# Uso de yield para escalonamento cooperativo
function produtora(c::Channel)
    for i in 1:3
        put!(c, i)
        println("Produziu ", i)
        yield() # Cede controle voluntariamente para outras tarefas
    end
    close(c)
end

function consumidor(c::Channel)
    for item in c
        println("Consumiu ", item)
    end
end

function testar_canais()
    println("\n--- Testando Canais (Comunicação entre corrotinas) ---")
    canal = Channel{Int}(3)
    @async produtora(canal)
    consumidor(canal) # Executa na thread principal
end

testar_corrotinas()
testar_canais()
