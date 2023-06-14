# Postgresql_Backup
Esse repositório tem como base gerar Backups diários do banco de dados PostgreSQL. O ideal é executar o arquivo no seu servidor ou sua máquina através de um cronjob, pois assim ele executara o horário que você definir

# Procedimento de Backup Lógico - pg_dump

> O que é Backup Lógico:

Também conhecido como dump, é a transcrição lógica da base de dados para um arquivo ou diretório (conforme o tipo do dump).
Um dump contém instruções SQL que devem ser processadas uma por uma tanto no processo de gerar dump, quanto no seu processo de restauração. Muito vantajoso para fazer migração para uma versão mais nova. No entanto devido ao processamento de cada instrução SQL, pode ser mais demorado que um Backup Fisíco.
Um dump pode ser de toda instância (com pg_dumpall), de apenas um database, de um schema ou somente de uma tabela.

> Comandos para gerar o pg_dump:
Acessado o terminal, iremos definir um diretório especifico para o backup. Por exemplo no WSL foi definido em:

/mnt/c/Desenv/Projeto-Estudos/Postgres_Backup

Para podermos gerar o backup de um database em especifico usaremos os seguintes comandos:

1- su - postgres;

2- pg_dump database_name > nomebackup.bkp;

> Exemplo:
su - postgres pg_dump muchulski > muchulski.bkp;

É possível também configurar o formato do backup como binário, para isso iremos utilizar as seguintes informações:

1- su - postgres;

2- pg_dump -Fc database_name > nomebackup.bin;

OBS: Os parâmetros utilizados foram para gerar o arquivo binário foram o F (responsável por definir o formato do backup) que contém parâmetros internos como por exemplo:

p <br />
plain

Saída de um texto sem formatação SQL arquivo de script ( o padrão ).

c <br />
custom

Saída de um arquivo de formato personalizado adequado para entrada em pg_restore. Juntamente com o formato de saída do diretório, este é o formato de saída mais flexível, pois permite a seleção manual e a reordenação de itens arquivados durante a restauração. Este formato também é compactado por padrão.

d <br />
directory

Saída de um arquivo de formato de diretório adequado para entrada em pg_restore. Isso criará um diretório com um arquivo para cada tabela e blob sendo despejado, além do chamado arquivo do Índice que descreve os objetos despejados em um formato legível por máquina que pg_restore pode ler. Um arquivo de formato de diretório pode ser manipulado com as ferramentas Unix padrão; por exemplo, arquivos em um arquivo não compactado podem ser compactados com o gzip ferramenta. Esse formato é compactado por padrão e também suporta despejos paralelos.

t <br />
tar

Saída a tar-format archive adequado para entrada em pg_restore. O formato tar é compatível com o formato de diretório: extrair um arquivo tar-format produz um arquivo de formato de diretório válido. No entanto, o formato tar não suporta compactação. Além disso, ao usar o formato tar, a ordem relativa dos itens de dados da tabela não pode ser alterada durante a restauração.

No caso do procedimento de conversão para binário foi utilizado o c (custom) para customizar a opção de bin.

# Procedimento de Backup Lógico - pg_dumpall

> Comandos para gerar o pg_dumpall:

Devemos estar no diretório configurado para os backups:

1- su - postgres;

2- pg_dumpall -U postgres > all.sql;

# Procedimento de Restauração do banco - tanto para pg_dump quanto para pg_dumpall

> Caso o banco de dados seja apagado, poderá ser feita a restauração do banco. Para isso seguir os seguintes passos: 

1- Dentro do usuário postgres executar o comando 'psql';

2- Deveremos criar novamente um novo database, pode ser o mesmo nome do antigo com o seguinte comando: 

CREATE DATABASE muchulski TEMPLATE template0;

----Observamos que ele foi criado baseado no template0, é importante que ele siga esse template.

3- Iremos dar um '\q' para sair do prompt psql e acessar novamente o usuário postgres;

4- Dentro do diretório onde temos o arquivo de backup, podemos executar o seguinte comando:

psql muchulski < muchulski.bkp  --- assim iremos restaurar todos os dados que tinhamos no banco antes dele ser apagado ou excluido

(Caso não esteja conectado com o usuário postgres, usar esse comando dentro do diretório):

sudo su -U postgres psql database < nomearquivo.bkp;

> Procedimento de restauração com pg_dumpall:

Para restaurar os bancos com um arquivo de backup all, deveremos acessar o diretório de onde foi criado o arquivo de backup, e executar o seguinte comando:

psql -U postgres -f all.sql;

SINTAXE: -U (define o usuário) / -f filename

> Qual é melhor PG_DUMP OU PG_DUMPALL:

Além do pg_dump o PostgreSQL também oferece a pg_dumpall que permite fazer backup de todos os bancos de dados de uma vez. No entanto, não é recomendável usar essa ferramenta pelos seguintes motivos:
O pg_dumpall exporta todos os bancos de dados, um após o outro, em um único arquivo de script, o que impede que você execute a restauração paralela. Se você fizer backup de todos os bancos de dados dessa maneira, o processo de restauração levará mais tempo.
O processamento de restore de todos os bancos de dados leva mais tempo do que cada um, portanto, você não sabe qual seria o restore de cada banco de dados está relacionado a um determinado momento.

Se quiser poupar tempo usar o pg_dump para cada database, caso contrário usar o pg_dumpall.

# Observações:

> REVOKE CONNECT:

Caso esteja sendo feito o prrocesso de drop database e exista algum usuário conectado, podemos usar o comando:

REVOKE CONNECT ON DATABASE muchulski FROM public;

Após isso não será possivél se conectar novamente ao banco, agora para remover as conexões ativas iremos rodar o seguinte comando:

SELECT pg_terminate_backend(pg_stat_activity.pid) <br>
FROM pg_stat_activity <br>
WHERE pg_stat_activity.datname = 'muchulski'; <br>

Depos de executar esse SELECT, pode ser efetuado o comando drop database.

# Documentação Relevante

Link documentação psql: https://www.postgresql.org/docs/current/app-psql.html <br>
Link documentação if-else Linux: https://www.shellscriptx.com/2016/12/estrutura-condicional-if-then-elif-else-fi.html <br>
Link exemplos com find Linux: https://www.certificacaolinux.com.br/comando-linux-find/ <br>
Link documentação do pg_dump: https://www.postgresql.org/docs/current/app-pgdump.html
