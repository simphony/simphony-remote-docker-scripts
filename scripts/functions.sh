function extract_key {
    # Function to extract a single key from a key-value file with
    # equal `=` as separator.
    # Result is returned in the RESULT variable
    kv_file=$1
    key=$2
    
    RESULT=`cat $kv_file | grep "^$2=" | cut -d'=' -f2`
    if test $? -ne 0; then
        RESULT=""
    fi
}

function b64encode {
    if test "`which uuencode`" != ""; then
        RESULT=`uuencode -m $1 $1 | sed '1d;$d'| tr -d '\n'`
    elif test "`which base64`" != ""; then
        RESULT=`base64 -w 0 $1`
    else
        echo "Cannot find base64 encoder utility"
        exit 1
    fi
}
