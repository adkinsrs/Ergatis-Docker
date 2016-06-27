for script in `cat /tmp/exec_scripts.txt`
    do sed 's/###SCRIPT_NAME###/${script}/g' /opt/scripts/wrapper_template.sh > /opt/ergatis/bin/${script}
done
