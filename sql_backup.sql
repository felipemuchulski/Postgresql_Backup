SELECT ' pg_dump -U postgres -w -d ' || datname ||' -C > /mnt/c/Desenv/Projetos-Estudos/Postgres_Backup/backup-'|| datname ||'-'|| current_date||'.sql'
FROM pg_stat_database
 WHERE datname IS NOT NULL
  and datname <> 'template0' and datname <> 'template1'