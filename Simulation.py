import tellurium as te
import time
import matplotlib.pyplot as plt
import numpy
from roadrunner import Config
import os
import sys
import gc
import socket

antStr = '''
model feedback()
	// Reaction-Name: Reaction; Kinetics;
	R1: E + R -> H; N^(k1)*E*R/200;
	R2: H -> E + R; N^(k2)*H/200;
	R3: H -> E + P; N^(k3)*H/200;
	// Variable initialization:
	k1 = 1;
	k2 = 3;
	k3 = 2;
	N = 100;
	// Species initialization:
	E = 100;
	R = N;
	H = 0;
	P = 0;
	// Concentration definition, notice the :=
	Rn := R/N;
	Pn := P/N;
	Hn := H/100;
end'''

name='Simulation.csv' #Dateiname festlegen
path='W:\Sim\\' #Dateipfad festlegen
selectToPlot = ['time','Rn','Pn','Hn'] #welche Variablen sind von Interesse?
timePoints = [1.0, 2.0, 3.0] #zu welchen Zeitpunkten soll die Konfiguration gespeichert werden?
tStart = 0	#Start- und Endzeit der Simulation
tEnd = 3.01
doplot = True #plotten?
plotlegend = True #Legende plotten?
verbose = 2 #Verbose level: 0 = garnicht, 1 = Statistik 1x je outerLoop, 2 = Statistik nach jedem N, 3 = +Schleifenzaehler (sehen obs haengt)
Nscale=100
#Produkt der naechsten 3 Variablen ist die Anzahl der insg. simulierten Pfade
outerLoop = 1 #Anzahl wiederholungen festlegen (multipliziert sich mit population zur Anzahl der simulierten Pfade je N)
Nrange= range(3) #Bereich von N festlegen. range(5) ==  0,1,2,3,4. Daher Multiplikator N = (N+1)*Nscale
AnzahlPfade = 40 #Anzahl wiederholungen festlegen (multipliziert sich mit outerLoop). Fuer schoene Plots hier Wert 40-100. Fuer grosse N: doplot=False, hier 1, dafuer bei outerLoop gewuenschte Werte eintragen.
#----------------------------
r = te.loadAntimonyModel(antStr)
r.setIntegrator('gillespie')
r.getIntegrator().setValue('variable_step_size', True)
Config.setValue(Config.MAX_OUTPUT_ROWS,pow(10,7))  #bei 64-bit pow(10,11) oder weniger bei wenig Arbeitsspeicher
Reactions = 0
start_time = time.time()
selectToSave = ['N'] + selectToPlot
form=(1,len(selectToSave))
r.selections = selectToSave
simuliertePfade = 0
PfadeGesamt=outerLoop*AnzahlPfade*len(Nrange)
if os.path.isfile(path+name):  #Header in CSV-Datei automatisch erzeugen, falls Datei noch nicht existiert
	f=open(path+name,'ab')
else:
	f=open(path+name,'ab')
	head=",".join(selectToSave)
	f.write(head)
	f.write("\n")
def fmt(n):		#Formatierung der Zahlen nach Art des Hauses
	if type(n) == float:
		if n >= 1000000 : form ='{:<8.2e}'
		elif  n >= 1000 : form ='{:>6.0f}'
		elif n >= 0.01 : form = '{:>8.4f}'	
		else : form ='{:<8.2e}'
	if type(n) == int:
		if n >= 1000000 : form ='{:<8.2e}'
		elif n < 10000 : form ='{:>4.0f}'
		else : form ='{:>6.0f}'
	return form.format(n)
def ZeitFormat(t):
	return '{:>2.0f}'.format(int(t)/(3600))+time.strftime(":%M:%S", time.gmtime(t))
def info(n): #Erzeugen der Verbose-Informationen
	wallTime = time.time() - start_time
	if n > 1:
		timeTo = float(PfadeGesamt - simuliertePfade)*float(wallTime)/float(simuliertePfade)
		timeString = " remain="	
	else:
		timeTo = float(PfadeGesamt)*float(wallTime)/float(simuliertePfade)
		timeString = " finish="
	print(str(time.strftime("%H:%M:%S",time.localtime()))+" "+str(socket.gethostname())+" L="+fmt(count)+" N="+fmt(N)+" P="+fmt(simuliertePfade)+" R="+fmt(Reactions)+" t="+ZeitFormat(wallTime)+" R/P="+fmt(Reactions/simuliertePfade)+" R/t="+fmt(float(Reactions)/wallTime)+" t/P="+fmt(float(wallTime)/float(simuliertePfade))+timeString+ZeitFormat(timeTo))
	sys.stdout.flush()
for count in range(outerLoop): 
	if (verbose >=3): print("outerLoop="+str(count))
	for N in Nrange: 
		N = (N+1)*Nscale
		r.N=N; r.R=N; # r.k1=1; r.k2=3; r.k3=2 #Variablen im Modell anpassen
		if (verbose >=3): print("N="+str(N))
		for k in range(AnzahlPfade):
			if (verbose >=3): print("PfadNo. "+str(k))
			r.reset()
			s = r.simulate(tStart, tEnd) #Simulationszeit anpassen
			simuliertePfade += 1
			#numpy.savetxt(f,s,fmt='%15f',delimiter=",")  #Nur auskommentieren wenn gesamter Pfad gespeichert werden soll, frisst Festplattenspeicher
			for t in timePoints: #Speichert letzten Simulationsstand zur Zeit t
				numpy.savetxt(f,numpy.reshape(s[numpy.sum(numpy.less_equal(s['time'],t))-1],form),fmt='%15f',delimiter=",")
			if doplot:
				toplot = numpy.delete(s, numpy.s_[0:1],axis=1)
				r.selections=selectToPlot
				r.plot(toplot, show=False, loc=None ,alpha=1/float(AnzahlPfade), rasterized=False,title="N="+str(N)+", #Paths="+str(AnzahlPfade))
				if (k==0) and plotlegend:				
					#leg=plt.legend(selectToPlot[1:],loc=3,ncol=10,mode="expand",borderaxespad=0.,bbox_to_anchor=(0., 1.02, 1., .102)) #anderer Legenden-Stil
					leg=plt.legend(selectToPlot[1:]) #Stil fuer Legende					
					for l in leg.get_lines():
						l.set_alpha(1.)
				r.selections=selectToSave
			Reactions += int(s.shape[0])
		plt.show()
		if (verbose >=2): info(2)
		del s
		gc.collect()
	f.flush()
	if (verbose ==1): info(1)
f.close()