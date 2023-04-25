#!/bin/bash

#Declarar a variavél da hora que iniciou o banco de dados
INICIO=`date`

#Declarar as variáveis de ambiente.
DIRETORIO=/mnt/c/Desenv/Projetos-Estudos/Postgres_Backup
ARQUIVO=$DIRETORIO/executar_backup.sh
LOG_HOME=$DIRETORIO/logs
ARQLOG=$LOG_HOME/backup.log
BKP_ZIP=$DIRETORIO/bkp_zip



#Inicio do Backup
echo                                    >  $ARQLOG
echo "--------------------------------" >> $ARQLOG 
echo "--     INICIO DO BACKUP       --" >> $ARQLOG 
echo "--------------------------------" >> $ARQLOG 
echo "Data:                           " >> $ARQLOG 
date                                    >> $ARQLOG
echo                                    >> $ARQLOG


#Criação dos diretórios
echo "--------------------------------" >> $ARQLOG 
echo "--   CRIACAO DOS DIRETORIOS   --" >> $ARQLOG 
echo "--------------------------------" >> $ARQLOG 
cd $DIRETORIO
mkdir -p $LOG_HOME                      >> $ARQLOG  
mkdir -p $BKP_ZIP                       >> $ARQLOG 
echo 'Criado diretório de log' $LOG_HOME  >> $ARQLOG
echo 'Criado diretório de backup' $BKP_ZIP >> $ARQLOG
echo                                    >> $ARQLOG


#Criação de arquivo executar backup
: "
 Se o seu script não criar por conta o arquvio executar_backup.sh ao rodar os comandos, deixe essa linha fora de um comentário.

  if [ -e $ARQUIVO ]; then
    echo ' '
 else
    cd $DIRETORIO
    touch $ARQUIVO 
    chmod +x $ARQUIVO 
 fi
"

#Logica do codigo
echo "---------------------------------" >> $ARQLOG 
echo "--   ACESSANDO TERMINAL PSQL   --" >> $ARQLOG 
echo "---------------------------------" >> $ARQLOG 
date                                     >> $ARQLOG 
psql -V                                  >> $ARQLOG
echo 'Executando arquivo sql_backup.sql' >> $ARQLOG
echo 'cd $DIRETORIO' > $ARQUIVO 
psql  -U postgres -d postgres -t -c '\i /mnt/c/Desenv/Projetos-Estudos/Postgres_Backup/sql_backup.sql' >> $ARQUIVO

#Executado arquivo psql que ira gerar o pg_dump de todos os databases do seu servidor
$ARQUIVO 
echo                                     >> $ARQLOG

#Compactar os arquivos e mandar para o diretório de zip 
echo "---------------------------------" >> $ARQLOG 
echo "-- COMPACTA O BACKUP DO BANCO  --" >> $ARQLOG 
echo "---------------------------------" >> $ARQLOG 
echo 'Compactando arquivos de Backup:'   >> $ARQLOG
date                                     >> $ARQLOG
cd $DIRETORIO                            >> $ARQLOG
gzip -f -5 backup*.sql                   >> $ARQLOG
echo                                     >> $ARQLOG


#Mover o Backup para o diretorio zip
echo "--------------------------------------" >> $ARQLOG 
echo "-- MOVENDO ARQUIVOS PARA DIRETÓRIO  --" >> $ARQLOG 
echo "--------------------------------------" >> $ARQLOG 
date                                          >> $ARQLOG
echo "Movendo arquivos zipados para diretório" >> $ARQLOG
mv backup*.gz $BKP_ZIP                         >> $ARQLOG
echo 'Listando diretório e conteúdo zipados:'  >> $ARQLOG
ls -R $BKP_ZIP                                >> $ARQLOG
echo                                          >> $ARQLOG

#Remover os arquivos de backup do dia anterior
echo '---------------------------------------' >> $ARQLOG
echo '--  REMOVER LOGS DA SEMANA ANTERIOR  --' >> $ARQLOG
echo '---------------------------------------' >> $ARQLOG
cd $BKP_ZIP
find -name "backup*.sql.*" -mtime +1 -exec rm -rf {} \; >> $ARQLOG
echo 'Arquivos de log removidos'               >> $ARQLOG    
echo                                           >> $ARQLOG


echo "--------------------------------" >> $ARQLOG 
echo "-- INFORMACOES GERAIS BACKUP  --" >> $ARQLOG 
echo "--------------------------------" >> $ARQLOG 
echo 'Quantidade de arquivos no diretório de bkp' >> $ARQLOG
ls -t $BKP_ZIP                         >> $ARQLOG
echo                                    >> $ARQLOG
#exibir de quais bancos foram feitos os backups
#exibir o diretório dos backups


echo "--------------------" >> $ARQLOG 
echo "-- FIM DO BACKUP  --" >> $ARQLOG 
echo "--------------------" >> $ARQLOG
echo "Inicio do backup em:            " >> $ARQLOG 
echo $INICIO                            >> $ARQLOG 
echo "Termino do backup em:           " >> $ARQLOG 
date                                    >> $ARQLOG 
echo                                    >> $ARQLOG


