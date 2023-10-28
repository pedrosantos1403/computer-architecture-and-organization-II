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



Testes:

1) Testar valores dos registradores.



Relatório:

1) Tabela mostrando os estágios de cada instrução (T1, T2, ...)


Problemas:

1) Caso a primeira instrução despachada tenha o mesmo registrador como registrador de destino e como um dos operandos (ADD R1, R1, R2)
   a RS vai salvar que R1 está esperando um valor novo e a instrução nunca será executada. Poderiamos implementar um sinal que controla
   se a instrução em questão é a primeira instrução despachada ou não.

2) Checar blocking e non blocking assignments

3) Registradores estão perdendo o valor no segundo posedge


