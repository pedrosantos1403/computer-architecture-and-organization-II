Prática 3 - Tomasulo

Tarefas Código:

1) Adicionar lógica para SD.

Testes Intermediários:

a) Checar se é possível atualizar a Fila de Prioridade no início do clock
b) Testar se com dois dados da ULA entrando no mesmo ciclo as posições da Fila são ajustadas corrretamente


Problemas:

1) Caso a primeira instrução despachada tenha o mesmo registrador como registrador de destino e como um dos operandos (ADD R1, R1, R2)
   a RS vai salvar que R1 está esperando um valor novo e a instrução nunca será executada. Poderiamos implementar um sinal que controla
   se a instrução em questão é a primeira instrução despachada ou não.

2) Checar blocking e non blocking assignments

3) Registradores estão perdendo o valor no segundo posedge


