# JuliaConcurrency

Exemplos práticos de **concorrência e paralelismo em Julia**, organizados como material de apoio para uma apresentação sobre o tema. Os scripts cobrem desde a criação básica de threads até sincronização, corrotinas, canais, atores e computação distribuída.

## Estrutura

| Arquivo | Tema | Modelo |
| --- | --- | --- |
| [`01_threads.jl`](01_threads.jl) | Criação e uso de threads (`@threads`, `@spawn`, `fetch`) | Memória compartilhada |
| [`02_sincronizacao_threads.jl`](02_sincronizacao_threads.jl) | Condição de corrida, `ReentrantLock` e operações atômicas | Memória compartilhada |
| [`03_corrotinas_e_promises.jl`](03_corrotinas_e_promises.jl) | Corrotinas (`@async`), event loop, `fetch` como *promise* e `Channel` | Concorrência cooperativa |
| [`04_atores_conceitual.jl`](04_atores_conceitual.jl) | Modelo de atores (exemplo conceitual com `Actors.jl`) | Atores (via pacote) |
| [`05_distribuido.jl`](05_distribuido.jl) | Processos remotos com `Distributed`, `@everywhere` e `@spawnat` | Memória distribuída (RPC) |

## Pré-requisitos

- [Julia](https://julialang.org/downloads/) 1.9 ou superior (testado com 1.13.3)
- Nenhum pacote externo é necessário para os scripts 01, 02, 03 e 05
- O script 04 é apenas conceitual; para executá-lo de fato é preciso instalar o pacote [`Actors.jl`](https://github.com/JuliaActors/Actors.jl)

Verifique a instalação com:

```bash
julia --version
```

## Como executar

### Threads

Os scripts 01 e 02 dependem do número de threads disponível. Inicie o Julia com a flag `-t`:

```bash
julia -t auto 01_threads.jl
julia -t auto 02_sincronizacao_threads.jl
```

- `-t auto` usa todos os núcleos lógicos da máquina.
- `-t 4` fixa o uso em 4 threads de trabalho.
- Sem a flag, o Julia inicia com apenas 1 thread e o paralelismo não acontece. A variável de ambiente `JULIA_NUM_THREADS` também define esse valor.

> **Nota (Julia 1.12+):** a thread 1 é reservada para o pool interativo. Com `-t 4`, `nthreads()` retorna 4 (pool `:default`), mas `threadid()` dentro de `@threads` varia de **2 a 5**. Para obter os ids 1–4, use `julia -t 4,0` (quatro threads de trabalho e nenhuma interativa).

### Corrotinas e canais

```bash
julia 03_corrotinas_e_promises.jl
```

### Atores (conceitual)

```bash
julia 04_atores_conceitual.jl
```

Para uma versão funcional, descomente as linhas indicadas no arquivo e instale o pacote:

```julia
using Pkg
Pkg.add("Actors")
```

### Computação distribuída

```bash
julia 05_distribuido.jl
```

O script cria 2 workers locais via `addprocs(2)`. Em um cluster real, os processos podem ser adicionados em outras máquinas com `addprocs` e flags de SSH.

## O que cada script demonstra

### 01 — Threads

- `nthreads()`: quantas threads estão disponíveis.
- `@threads`: distribui automaticamente as iterações de um `for` pelo pool de threads.
- `threadid()`: identifica qual thread executou cada iteração (com `-t 4`, os ids vão de 2 a 5; veja a nota acima).
- `@spawn`: cria uma `Task` agendada em outra thread.
- `fetch`: bloqueia até a tarefa terminar e devolve seu resultado.

### 02 — Sincronização

- **Data race**: `contador += 1` executado por várias threads perde incrementos porque a leitura e a escrita não são atômicas. O resultado tende a ser menor que 10000.
- **`ReentrantLock`**: `lock(lk) do ... end` garante exclusão mútua, ao custo de serializar o acesso.
- **`Threads.Atomic`**: `Threads.atomic_add!` faz o incremento direto no hardware, sem lock — mais rápido para contadores simples.

> O valor exibido em `sem_sincronizacao` varia entre execuções; a corrida pode não se manifestar em todas elas.

### 03 — Corrotinas, event loop e promises

- `@async` cria corrotinas leves executadas cooperativamente no event loop.
- `sleep` cede a execução, permitindo que outra tarefa avance.
- `fetch(task)` funciona como uma *promise*: espera o resultado e o retorna.
- `Channel` permite comunicação entre corrotinas (produtor/consumidor), no estilo Go.
- `yield()` cede o controle voluntariamente.

### 04 — Atores

Julia não possui modelo de atores nativo. O arquivo mostra, em pseudocódigo, como `Actors.jl` implementa o padrão: um ator com estado interno que reage a mensagens (`spawn`, `send`).

### 05 — Computação distribuída

- `addprocs(2)` inicia processos isolados.
- `@everywhere` define código em todos os processos.
- `@spawnat` envia o cálculo para um worker específico e retorna um `Future`.
- `fetch(futuro)` traz o resultado pela rede.
- Não há memória compartilhada: os dados são serializados e copiados.

> O cálculo `matriz ^ 2` em uma matriz 200×200 é uma potenciação de matrizes (custo cúbico). O tamanho foi reduzido de 500×500 para 200×200 para deixar a demonstração mais rápida; aumente em `rand(200, 200)` se quiser um cálculo mais pesado.

## Referências

- [Documentação oficial — Parallel Computing](https://docs.julialang.org/en/v1/manual/parallel-computing/)
- [Documentação oficial — Multi-Threading](https://docs.julialang.org/en/v1/manual/multi-threading/)
- [Documentação oficial — Asynchronous Programming](https://docs.julialang.org/en/v1/manual/asynchronous-programming/)
- [Actors.jl](https://github.com/JuliaActors/Actors.jl)
