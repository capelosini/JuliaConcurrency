# ==============================================================================
# Parte 2: Modelo de Atores
# Julia NÃO aplica modelo de Atores nativamente (usa Canais, estilo Go).
# No entanto, bibliotecas como 'Actors.jl' implementam este modelo.
# Abaixo, um pseudocódigo exemplificando o uso caso instale o pacote Actors.jl
# ==============================================================================

# Pkg.add("Actors")
# using Actors

println("=== Demonstração Conceitual do Modelo de Atores em Julia ===")
println("Para executar, instale o pacote Actors.jl.")

#=
# 1. Definimos o comportamento do ator (como ele reage a mensagens)
function comportamento_contador(estado, mensagem)
    if mensagem == :incrementar
        novo_estado = estado + 1
        println("Estado atual: ", novo_estado)
        return novo_estado # Atualiza o estado para a próxima mensagem
    elseif mensagem == :zerar
        println("Zeradeira")
        return 0
    end
end

# 2. Instanciamos o Ator informando seu comportamento e estado inicial
# ator_ref = spawn(comportamento_contador, 0)

# 3. Enviamos mensagens ao Ator
# send(ator_ref, :incrementar)
# send(ator_ref, :incrementar)
# send(ator_ref, :zerar)
=#
