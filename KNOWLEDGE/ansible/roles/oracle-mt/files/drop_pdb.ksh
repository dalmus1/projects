#!/bin/ksh

# Script Name   : drop_pdb.ksh
# Usage         : drop_pdb.ksh <PDB_NAME>
#               : e.g. drop_pdb.ksh TT040DEV2

# get the pdb name and format it to UPPERCASE.
pdb_name_drop=`echo $1 | tr "[a-z]" "[A-Z]" | tr -d '\n'`

# Get the container database name
cdb_name=`sqlplus -s "/as sysdba" << EOF
        set pages 0
        set verify off
        set echo off
        set heading off
        set feedback off
        select name from v\\$database;
        exit
EOF
`

#Check if the PDB exists
pdbexists=`sqlplus -s "/as sysdba" << EOF
        set pages 0
        set feedback off
        set verify off
        set echo off
        set heading off
        select name from v\\$containers where name = '$pdb_name_drop';
EOF
`

if [[ -z $pdb_name_drop ]]; then
        echo "PDB name to be dropped must be specified"
        exit 1
elif [[ -z $pdbexists ]]; then
        echo "This PDB - $pdb_name_drop not found"
        exit 0
fi

sqlplus -s "/as sysdba" << EOF
        set echo on
        set pages 0
        alter pluggable database $pdb_name_drop close;
        drop pluggable database $pdb_name_drop including datafiles;
        exit
EOF

# Check PDB again
pdbexists=`sqlplus -s "/as sysdba" << EOF
        set pages 0
        set feedback off
        set verify off
        set echo off
        set heading off
        select name from v\\$containers where name = '$pdb_name_drop';
EOF
`

if [[ -z $pdbexists ]]; then
        echo "PDB was successfully dropped"
fi


        # Updating tnsnames to remove the dropped PDB

        # getting listener details
        listenerdetails=`sqlplus -s "/as sysdba" << EOF
        set echo off
        set pages 0
        set heading off
        set feedback off
        set verify off
        select substr(value,instr(value,'=')+1) from v\\$parameter where name = 'local_listener';
EOF
`
        tnsadd=`echo $listenerdetails |cut -c1-\`expr length $listenerdetails - 1\``

        # Getting list of available PDBs
        pdblist=`sqlplus -s "/as sysdba" << EOF
        set echo off
        set pages 0
        set heading off
        set feedback off
        set verify off
        select name from v\\$containers where name not in ('CDB\\$ROOT','PDB\\$SEED');
EOF
`
        if [[ -z $pdblist ]]; then
        echo "
CDXXXDEV =
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST=localhost)(PORT = 1521))
    (CONNECT_DATA =
      (SERVER = DEDICATED)
      (SERVICE_NAME = CDXXXDEV)
    )
  )

" > $ORACLE_HOME/network/admin/tnsnames.ora
sed -i --follow-symlinks "s/HOST=localhost/HOST=$HOSTNAME/" $ORACLE_HOME/network/admin/tnsnames.ora

        exit 0
        fi

        # Recreate a new tnsnames.ora
        echo "Recreating tnsnames.ora"
        echo "
CDXXXDEV =
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST=localhost)(PORT = 1521))
    (CONNECT_DATA =
      (SERVER = DEDICATED)
      (SERVICE_NAME = CDXXXDEV)
    )
  )

" > $ORACLE_HOME/network/admin/tnsnames.ora

        for i in $pdblist
        do
          echo "" >> $ORACLE_HOME/network/admin/tnsnames.ora
          echo "$i =" >> $ORACLE_HOME/network/admin/tnsnames.ora
          echo "   (DESCRIPTION =" >> $ORACLE_HOME/network/admin/tnsnames.ora
          echo "      (ADDRESS_LIST =" >> $ORACLE_HOME/network/admin/tnsnames.ora
          echo "         $tnsadd" >> $ORACLE_HOME/network/admin/tnsnames.ora
          echo "      )" >> $ORACLE_HOME/network/admin/tnsnames.ora
          echo "      (CONNECT_DATA =" >> $ORACLE_HOME/network/admin/tnsnames.ora
          echo "          (SERVICE_NAME = $i)" >> $ORACLE_HOME/network/admin/tnsnames.ora
          echo "      )" >> $ORACLE_HOME/network/admin/tnsnames.ora
          echo "   )" >> $ORACLE_HOME/network/admin/tnsnames.ora
          echo "" >> $ORACLE_HOME/network/admin/tnsnames.ora
        done

        sed -i --follow-symlinks "s/HOST=localhost/HOST=$HOSTNAME/" $ORACLE_HOME/network/admin/tnsnames.ora

        # test tnsping
        for i in $pdblist
        do
          tnsping $i
        done
        tnsping CDXXXDEV

