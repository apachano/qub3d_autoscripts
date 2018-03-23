
function check {
	if [ $(dpkg-query -W -f='${Status}' $1 2>/dev/null | grep -c "ok installed") -eq 0 ];
	then
	    echo "package not installed"
	else
		echo "package is installed"
	fi
}

check asdf