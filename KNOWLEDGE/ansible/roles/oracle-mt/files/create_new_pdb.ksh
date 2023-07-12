#!/bin/ksh

# Script Name   : create_new_pdb.ksh
# Usage         : create_new_pdb.ksh <PDB_NAME>
#               : e.g. create_new_pdb.ksh TT040DEV2

# get the pdb name and format it to UPPERCASE.
pdb_name_new=`echo $1 | tr "[a-z]" "[A-Z]" | tr -d '\n'`

datapath='/u02/oradata'

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
        select name from v\\$containers where name = '$pdb_name_new';
EOF
`

if [[ -z $pdb_name_new ]]; then
        echo "PDB name must be specified"
        exit 1
elif [[ $pdbexists == $pdb_name_new ]]; then
        echo "This PDB $pdb_name_new already exists in this container database"
        exit 0
elif [[ `expr length $pdb_name_new` -ge 10 ]]; then
        echo "PDB name needs to be 9 characters or less"
        exit 1
fi

# Check of available space in /opt/oracle/oradata/cdb_name

fsfree=`df -k $datapath/$cdb_name | tail -1 |awk '{ freemb=$4/1024; print freemb}'`

if [[ $fsfree -le 1024 ]]; then
        echo "Not enough free space in $datapath/$cdb_name"
        exit 1
fi

sqlplus -s "/as sysdba" << EOF
        set echo on
        set pages 0
        create pluggable database $pdb_name_new admin user pdbadmin identified by devinstall file_name_convert=('$datapath/$cdb_name/pdbseed/','$datapath/$cdb_name/$pdb_name_new/') default tablespace users datafile '$datapath/$cdb_name/$pdb_name_new/users01.dbf' size 5M autoextend on next 1280K storage (maxsize unlimited max_shared_temp_size unlimited);
        alter pluggable database $pdb_name_new open;
        alter pluggable database $pdb_name_new save state;
        alter session set container=$pdb_name_new;
        grant pdb_dba to pdbadmin;
        grant resource to pdbadmin;
        grant unlimited tablespace to pdbadmin;
        exit
EOF

# Check PDB again
pdbexists=`sqlplus -s "/as sysdba" << EOF
        set pages 0
        set feedback off
        set verify off
        set echo off
        set heading off
        select name from v\\$containers where name = '$pdb_name_new';
EOF
`

if [[ $pdbexists = $pdb_name_new ]]; then
        echo "PDB was successfully created"
        sqlplus -s "/as sysdba" << EOF
        set heading on
        set lines 200
        col name format a20
        col open_mode format a30
        select name, open_mode from v\$containers where name = '$pdbexists';
        exit
EOF

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

        # Add entry into tnsnames.ora
        echo "" >> $ORACLE_HOME/network/admin/tnsnames.ora
        echo "$pdb_name_new =" >> $ORACLE_HOME/network/admin/tnsnames.ora
        echo "   (DESCRIPTION =" >> $ORACLE_HOME/network/admin/tnsnames.ora
        echo "      (ADDRESS_LIST =" >> $ORACLE_HOME/network/admin/tnsnames.ora
        echo "         $tnsadd" >> $ORACLE_HOME/network/admin/tnsnames.ora
        echo "      )" >> $ORACLE_HOME/network/admin/tnsnames.ora
        echo "      (CONNECT_DATA =" >> $ORACLE_HOME/network/admin/tnsnames.ora
        echo "          (SERVICE_NAME = $pdb_name_new)" >> $ORACLE_HOME/network/admin/tnsnames.ora
        echo "      )" >> $ORACLE_HOME/network/admin/tnsnames.ora
        echo "   )" >> $ORACLE_HOME/network/admin/tnsnames.ora

	sed -i --follow-symlinks "s/HOST=localhost/HOST=$HOSTNAME/" $ORACLE_HOME/network/admin/tnsnames.ora
        tnsping $pdb_name_new

        # test connect
        connection=`sqlplus -s pdbadmin/devinstall@$pdb_name_new << EOF
        set pages 0
        set heading off
        set feedback off
        set echo off
        set verify off
        select 'PASSED' from dual;
        exit
EOF
`
        if [[ $connection = "PASSED" ]]; then
                echo "PDB $pdb_new_name connection successful"
        fi
else
        echo "PDB creation failed"
        exit 1
fi

