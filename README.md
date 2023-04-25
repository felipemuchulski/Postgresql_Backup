# Postgresql_Backup
Esse repositório tem como base gerar Backups diários do banco de dados PostgreSQL. O ideal é executar o arquivo no seu servidor ou sua máquina através de um cronjob, pois assim ele executara o horário que você definir

# Observações
Dentro do script temos a parte de criação de diretórios:

mkdir -p $LOG_HOME                      >> $ARQLOG  
mkdir -p $BKP_ZIP                       >> $ARQLOG

Não executei o script sem ter criado eles antes, eu adicionei essa parte no fim do arquivo, caso não funcione, pode ser criado os diretórios por fora com os seguintes comandos na linha e terminal.

mkdir bkp_zip
mkdir logs

(25/04/23) Mas a ideia principal é fazer funcionar com o o script. Trago atualizações em breve.

# Documentação Relevante

Link documentação psql: https://www.postgresql.org/docs/current/app-psql.html

Link documentação if-else Linux: https://www.shellscriptx.com/2016/12/estrutura-condicional-if-then-elif-else-fi.html

Link exemplos com find Linux: https://www.certificacaolinux.com.br/comando-linux-find/
