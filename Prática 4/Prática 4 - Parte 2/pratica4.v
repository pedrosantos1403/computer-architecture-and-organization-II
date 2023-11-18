// PROJETO
// 1) Implementar uma Cache (Diretamente Mapeada ou Totalmente Associativa) usando matriz;
// 2) A Cache contem informações de 16 bits, dentre esses bits estarão contidos o número do bloco, estado do bloco, a tag do endereço, e o dado salvo no endereço;
// 3) O módulo principal recebe uma instrução (Read ou Write), essa instrução é executada na Cache, ou seja, a Cache será percorrida para checar se a instrução pode
//    ser executada. Após isso os estados dos blocos das caches serão atualizados baseado na Máquina de Estados MESI;
// 4) A instrução a ser executada tem 16 bits, e terá as informações de qual processador vai executar a instrução, opcode, tag, dado;
// 5) Instruções de Read não utilizaram os bits de dado;
// 6) Instrução de Read retorna o valor presente na tag em questão para o processador. Uma variável de saída deve receber esse sinal caso o read seja executado;
// 7) Criar um módulo de cache para cada processador, para que cada um seja inicializado de forma diferente;
// 8) Instanciar um bus que conversa com todos os processadores. O bus tem que indicar a mensagem e a tag;
// 9) Quem controla o sinal send de mem_inst é o mesi, quando um estado final for atingido o sinal send receberá 1;
// 10) Criar um módulo para simular a memória de dados com todas as tags necessárias;
// 11) Criar uma cache (matriz) dentro de cada módulo de processador;
// 12) Todos os processadores terão uma saída "send", que será setado pra 1 sempre que aquele processador finalizar a execução da instrução em questão.
//     No módulo principal será checado quando os 3 sinais de send forem 1, sendo assim, quando os 3 forem 1 significa que a instrução foi finalizada e uma próxima
//     pode ser enviada.
// 13) done será usado para resetar o bus, assim q todos os processadores finalizarem a execução o bus deve ser resetado;



module pratica4 ();

// Instanciar Memória de Instruções
// Instanciar Processadores


// Checar done de cada processador a cada clock, quando os 3 done forem 1 resetar o bus
endmodule
