for script in `cat /tmp/exec_scripts.txt`
    do sed 's/###SCRIPT_NAME###/${script}/g' wrapper_template.sh > /opt/ergatis/bin/${script}
done
