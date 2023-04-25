cd $DIRETORIO
  pg_dump -U postgres -w -d postgres -C > /mnt/c/Desenv/Projetos-Estudos/Postgres_Backup/backup-postgres-2023-04-25.sql
  pg_dump -U postgres -w -d muchulski -C > /mnt/c/Desenv/Projetos-Estudos/Postgres_Backup/backup-muchulski-2023-04-25.sql

