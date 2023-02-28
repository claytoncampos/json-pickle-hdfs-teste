#!/bin/bash
############################################
# Script: Clean HDFS
# Autor : Logicalis
# Data : 15/01/2023
# Recurso : Clayton Campos
# v1 - Faz o Backup e Limpeza do path da RAW do HDFS
#      Processo usado para uma carga full na tabela
############################################
#Variaveis
#. /data/framework/conf/framework_include.conf

DIR_RAIZ="/data/raw"
NOME_SIS_ORIG=$1
NOME_TBL=$2


# Gustavo Monteiro - 11/07/2018
# Alteração de diretório em que os arquivos serão movidos após o processo de File Watcher
# e serão consumidos pelo Put HDFS.
#DIR_OK="${DIR_RAIZ}/out"

LISTA=""
DAT_INI=$(date '+%Y%m%d%H%M%S')
DAT_REF=$(date '+%Y%m%d')
TMSTP_INI=$(date '+%Y-%m-%d %H:%M:%S')
PID_EXEC="$$"
ARQ_LOG="$DIR_LOG/FRAMEWORK_FILE_WATCHER_${PID_EXEC}_${DAT_INI}.txt"
ARQ_LS1="$DIR_TMP/FRAMEWORK_FILE_WATCHER_LS1_${PID_EXEC}_${DAT_INI}"
ARQ_SQL="$DIR_TMP/FRAMEWORK_FILE_WATCHER_INSRT_SQL_${PID_EXEC}_${DAT_INI}"
ARQ_MV="$DIR_TMP/FRAMEWORK_FILE_WATCHER_MOVE_FILES_${PID_EXEC}_${DAT_INI}"
DAT_PID=$(date '+%S')

TBL_PIP="pipeline_ingest"

#Funcoes
#Inicio exec
ini_exec()
{
  #dathr
  echo ----------------------------------------
  echo - Inicio execucao BACKUP_AND_CLEAN_HDFS
  echo - Horario inicio : $logdat
  echo ----------------------------------------
}

#Funcao fim exec
fim_exec()
{
  ABEND=1
 # dathr
  if [ $return_exec -eq 0 ]
  then
      RESULT_EXEC_STAT="OK"
  else
      RESULT_EXEC_STAT="NOK"

  fi

  echo ---------------------------------------
   echo Fim execucao BACKUP_AND_CLEAN_HDFS
   echo Return Code : $return_exec
   echo Horario Fim : $logdat
  echo ---------------------------------------
  exit $return_exec
}


#Funcao cronometro
countdown()
{
  date1=$((`date +%s` + $1));
  while [ "$date1" -ge `date +%s` ]
  do
    echo -ne "$logdat - INFO $(date -u --date @$(($date1 - `date +%s`)) +%H:%M:%S)\r"
    sleep 0.1
  done
}

#Funcao que valida retorno de comando anterior
valida()
{
    return_exec=$?
    if [ $return_exec -eq 0 ]
    then
      echo  INFO Comando executado com sucesso
    else
      echo  ERRO Comando executado com erro
      echo  return_exec.: $return_exec
        fim_exec
    fi
}

#Listagem de arquivos no diretorio origem
gera_lista()
{
    echo INFO Iniciada busca path HDFS da Tabela..:  $DIR_RAIZ/$NOME_SIS_ORIG/$NOME_TBL
    echo INFO Resultado da Busca no HDFS..: $(ls $DIR_RAIZ/$NOME_SIS_ORIG/ | grep $NOME_TBL | sort) 
    path_hdfs=$(ls $DIR_RAIZ/$NOME_SIS_ORIG/ | grep $NOME_TBL)

    if [ $path_hdfs==$NOME_TBL ]
    then
        echo INFO Diretorio da Tabela..: $NOME_TBL Localizado.
        return_exec=0
    else 
        echo INFO Diretorio da Tabela.: $NOME_TBL Nao Localizada.
        fim_exec
    fi
}

#####################
#Execucao do SCRIPT #
#####################

var_id_watcher=$(date '+%Y%m%d%H%M%S%4N')
ini_exec
gera_lista
valida
if [ $return_exec -eq 0 ]
then
    echo INFO Iniciando Movimentacao de Arquivos para backup
    echo INFO De....: $DIR_RAIZ/$NOME_SIS_ORIG/$NOME_TBL
    echo INFO Para..: $DIR_RAIZ/$NOME_SIS_ORIG/$NOME_TBL_BKP
    $(mv $DIR_RAIZ/$NOME_SIS_ORIG/$NOME_TBL $DIR_RAIZ/$NOME_SIS_ORIG/$NOME_TBL'_BKP')
else
    fim_exec
fi
echo INFO Processo de Movimentacao dos arquivos para BKP finalizada com Sucesso
echo INFO Path de backup:  $DIR_RAIZ/$NOME_SIS_ORIG/$NOME_TBL'_BKP'
return_exec=0
fim_exec
