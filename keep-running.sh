if [ $(ps aux | grep USER | grep python | wc -l) -lt 2 ]
	then
		sleep $(ruby -e '1.upto(1){print "%.6f\n" % (rand * 60 + 0.0) }');
		/home/USER/anaconda2/bin/python /home/USER/Simulation-Linux.py >> "$(uname -n).runLog" 2>&1 &
fi