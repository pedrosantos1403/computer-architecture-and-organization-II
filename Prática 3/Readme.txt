Prática 3 - Tomasulo


Ciclos de Execução Soma/Subtração:

CICLO 1) Instrução é despachada da Instruction Queu
CICLO 2) Instrução é inserida na RS e é despachada da RS (se possuir os operandos prontos)
CICLO 3) ULA realiza a execução da instrução e escrita no cdb
CICLO 4) cdb atualiza a RS


Tarefas Código:

1) Inicializar a memória de instruções com as instruções a seram testadas.
2) Criar LPM para memória de dados.
3) Adicionar lógica para SD.
4) O sinal de ula free pode ser controlado pelo cdb arbiter.
5) Acesso a memória de dados.
6) Implementar um unidade de controle para sequenciar execucoes.
7) Acessar a memoria dentro da RS usando a coluna Address.
8) cdb como fila de prioridade.


Testes Iniciais:

a) Checar os valores que saem da IQ (OK)
b) Checar os valores que entram na RS (OK)
c) Checar os valores que entram na ULA (OK)
d) Checar os valores que são mandados para o CDB ()
   d.1) O cdb não pode ter seu valor resetado (OK)
   d.2) Encontrar um jeito de garantir que o cdb só considera a saída da ULA quando for uma instrução nova
e) Checar os valores que são salvos no BR
f) Checar os valores que são atualizados na RS
g) Checar se as variáveis não são reinicializadas de forma errada


Testes Finais:

a) Dependência de dados verdadeira ou RAW (Read After Write) -> Soma/Sub
b) Dependência de saída ou WAW (Write After Write) -> Soma/Sub
c) Antidependência ou WAR (Write After Read) -> Soma/Load
d) Dependência/hazard estrutural (STALL - unidade funcional cheia) -> Soma e Sub com os mesmos operandos
e) Conflito no CDB -> Soma e Load mostrando que os sinais "Ula_can_write" e "Ula_ldsd_can_write" sao setados para 1 ao mesmo tempo
	              porém a Ula de Soma/Sub tem prioridade para escrever no CDB
f) Adiantamento na estação de reserva -> Mostrar o sinal de stall igual a 1 na IQ, mostrando que nenhuma instrucao é despachada
g) Renomeação de registradores


Relatório:

1) Tabela mostrando os estágios de cada instrução (T1, T2, ...)


Problemas:

1) Caso a primeira instrução despachada tenha o mesmo registrador como registrador de destino e como um dos operandos (ADD R1, R1, R2)
   a RS vai salvar que R1 está esperando um valor novo e a instrução nunca será executada. Poderiamos implementar um sinal que controla
   se a instrução em questão é a primeira instrução despachada ou não.

2) Checar blocking e non blocking assignments

3) Registradores estão perdendo o valor no segundo posedge


