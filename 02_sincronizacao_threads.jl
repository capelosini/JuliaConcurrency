# ==============================================================================
# Parte 1: Compartilhamento de Memória e Sincronização
# Mostra o perigo da condição de corrida e como resolver
# ==============================================================================

using Base.Threads

# 1. O Problema (Data Race)
function sem_sincronizacao()
    contador = 0
    @threads for i in 1:10000
        # Múltiplas threads acessando e modificando a variável global
        # Vai gerar perda de incrementos devido a acessos simultâneos
        contador += 1
    end
    println("Contador sem sync (esperado 10000): ", contador)
end

# 2. Solução A: ReentrantLock
function com_lock()
    contador = 0
    lk = ReentrantLock() # Cria uma trava

    @threads for i in 1:10000
        lock(lk) do # Garante que só 1 thread acesse esse bloco por vez
            contador += 1
        end
    end
    println("Contador com Lock (esperado 10000): ", contador)
end

# 3. Solução B: Operações Atômicas (Mais rápido para contadores simples)
function com_atomic()
    # Cria variável com garantia de atomicidade no hardware
    contador = Threads.Atomic{Int}(0)

    @threads for i in 1:10000
        Threads.atomic_add!(contador, 1) # Incremento seguro sem lock
    end
    println("Contador Atômico  (esperado 10000): ", contador[])
end

sem_sincronizacao()
com_lock()
com_atomic()
