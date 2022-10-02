#!/bin/bash

ARGS=$@
ARGS_LEN=$#
FAILS=()
PASSED=()
OUTPUT_REPORT_PATH="/package/output_report.txt"
H_LINE="====================="
DATE=$(date)

main() {
    if [ $ARGS_LEN -eq 0 ]; then
        echo "No result. At least one package required. See documentation."
        exit
    else
        echo "Starting Python Lambda Layer Package Downloads"
        mkdir -p python
        for package in $ARGS; do
            install_python_package $package
        done
        if [ "${#PASSED[@]}" -gt 0 ]; then
            echo "Zipping Package..."
            OUTPUT_ZIP_NAME=$(join _ ${PASSED[@]})
            zip -qr /package/$OUTPUT_ZIP_NAME.zip python
        fi
        output_report
    fi
}
install_python_package() {
    if (python3 -m pip install -qqU --no-cache-dir $1 -t python && rm -f /package/$1.zip); then
        PASSED+=($1)
        return
    else
        FAILS+=($1)
    fi
}
output_report() {
    echo_write $H_LINE
    echo_write "Output Report"
    echo_write "Date: $DATE"
    echo_write "Input Args: $ARGS"
    if [ "${#PASSED[@]}" -gt 0 ]; then
        echo_write "Output Name: $OUTPUT_ZIP_NAME.zip"
        echo_write $H_LINE
        echo_write "Successful Installs:"
        for i in "${PASSED[@]}"; do
            echo_write $i
        done
    fi
    if [ "${#FAILS[@]}" -gt 0 ]; then
        echo_write $H_LINE
        echo_write "Failed Installs:"
        for i in "${FAILS[@]}"; do
            echo_write $i
        done
    fi
    echo_write $H_LINE
}
join() {
    local IFS="$1"
    shift
    echo "$*"
}
echo_write() {
    echo $1 | tee -a $OUTPUT_REPORT_PATH
}
main
