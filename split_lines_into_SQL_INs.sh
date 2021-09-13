#!/bin/bash

INPUTFILE=20210913-email_addresses_to_export-SQL_INs.csv
BATCH_SIZE=49

OUTPUTFILE=20210913-email_addresses_to_export-SQL_INs.sql
rm ${OUTPUTFILE}

LINE_NUMBER=1
unset CUR_OUTPUT_LINE
while read LINE
do
    
    MODULO=$(( LINE_NUMBER % BATCH_SIZE ))
    
    if [[ ${MODULO} -eq 0 ]]
    then
        echo 'We have read '${LINE_NUMBER}' lines ...'
        
        #We have read BATCH_SIZE lines => writing current line:
        echo ${CUR_OUTPUT_LINE}')' >> ${OUTPUTFILE}
        
        #We have read BATCH_SIZE lines => new line
        CUR_OUTPUT_LINE='  OR du.login IN ( '"'"${LINE}"'"
    else
        if [[ ${LINE_NUMBER} -ne 1 ]]
        then
            #We have NOT read BATCH_SIZE lines => filling current line
            CUR_OUTPUT_LINE=${CUR_OUTPUT_LINE}",'"${LINE}"'"
        else
            #This is the first line:
            CUR_OUTPUT_LINE='     du.login IN ('"'"${LINE}"'"
        fi
    fi
    
    # Next line:
    (( LINE_NUMBER += 1 ))
    
done < ${INPUTFILE}

#Eventually, we write the last current line:
echo ${CUR_OUTPUT_LINE}')' >> ${OUTPUTFILE}

echo 'See OUTPUTFILE: '${OUTPUTFILE}
