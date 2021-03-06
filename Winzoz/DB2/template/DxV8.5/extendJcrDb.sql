#------------------------------------------------
# this script create DX Db via streaming command
# Author: AF - 2016-03-26
# Owner: Net2Action
#------------------------------------------------ 
if [ "$DEBUG" == "True" ] ; then
   echo " db: ${DBName} USER ${db2Admin} USING ${db2Pwd}"
fi
db2 -t -x -z sql.out +p <<-eof
CONNECT TO ${DBName} USER ${db2Admin} USING ${db2Pwd};
CREATE BUFFERPOOL ICMLSFREQBP4 SIZE 1000 AUTOMATIC PAGESIZE 4K;
CREATE BUFFERPOOL ICMLSVOLATILEBP4 SIZE 16000 AUTOMATIC PAGESIZE 4K;
CREATE BUFFERPOOL ICMLSMAINBP32 SIZE 16000 AUTOMATIC PAGESIZE 32K;
CREATE BUFFERPOOL CMBMAIN4 SIZE 1000 AUTOMATIC PAGESIZE 4K;
CREATE REGULAR TABLESPACE ICMLFQ32 PAGESIZE 32K BUFFERPOOL ICMLSMAINBP32;
CREATE REGULAR TABLESPACE ICMLNF32 PAGESIZE 32K BUFFERPOOL ICMLSMAINBP32;
CREATE REGULAR TABLESPACE ICMVFQ04 PAGESIZE 4K BUFFERPOOL ICMLSVOLATILEBP4;
CREATE REGULAR TABLESPACE ICMSFQ04 PAGESIZE 4K BUFFERPOOL ICMLSFREQBP4;
CREATE REGULAR TABLESPACE CMBINV04 PAGESIZE 4K BUFFERPOOL CMBMAIN4;
CREATE SYSTEM TEMPORARY TABLESPACE ICMLSSYSTSPACE32 PAGESIZE 32K BUFFERPOOL ICMLSMAINBP32;
CREATE SYSTEM TEMPORARY TABLESPACE ICMLSSYSTSPACE4 PAGESIZE 4K BUFFERPOOL ICMLSVOLATILEBP4;
CREATE USER TEMPORARY TABLESPACE ICMLSUSRTSPACE4 PAGESIZE 4K BUFFERPOOL ICMLSVOLATILEBP4;
DISCONNECT ${DBName};
TERMINATE;
UPDATE DB CFG FOR ${DBName} USING logfilsiz 16000;
UPDATE DB CFG FOR ${DBName} USING logprimary 20;
UPDATE DB CFG FOR ${DBName} USING logsecond 50;
UPDATE DB CFG FOR ${DBName} USING logbufsz 500;
UPDATE DB CFG FOR ${DBName} USING DFT_QUERYOPT 2;
TERMINATE;
eof
