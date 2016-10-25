# The purpose of this script is to create a wrapper shell script to call each executable script
for script in `cat /tmp/exec_scripts.txt`
    do sed "s/###SCRIPT_NAME###/${script}/g" /opt/scripts/wrapper_template.sh > /opt/ergatis/bin/${script}
	# Give the proper permissions
	chmod 755 /opt/ergatis/bin/${script}
done
