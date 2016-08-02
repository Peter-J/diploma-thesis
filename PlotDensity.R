PlotDensity <- function(filenames,N,dir="W:/sim/",time=c(1),species=c(3),divPerOne=200,fitTo=c(),xlim=c(),ylim=c(),verbose=TRUE,printLegend=TRUE,zoomEnable=FALSE,zoomCount=1,zoomList=NA,lwdOffset=1,saveAs=NA){
	xDown <- c() #Initialisierung von Variablen
	xUp <- c()
	yUp <- c()
	count <- 0
	info <- c()
	col <- 0
	fileCount <- 0
	specieslegend <- c()
	for (name in filenames){ #Schleife zum Abarbeiten der Dateien
		fileCount <- fileCount + 1
		speciesname <- paste(name,species)
		specieslegend <- c(specieslegend,speciesname)
		data <- read.csv(paste(dir,name,".csv",sep="")) #Dateinamen zusammensetzen und Datei einlesen
		labels <- data$N
		tmax <- max(data$time)
		data$time <- as.numeric(as.vector(cut(data$time,0:(tmax*divPerOne+1)/divPerOne,1:(tmax*divPerOne+1)/divPerOne))) #Unterteilen der Zeit in "Klassen" der Groesse divPerOne, obere Intervallgrenze = Name
		if(verbose){ separator <- "---------------------------"
			print("Time table"); print(table(data$time))
			print("check if divPerOne is suitable to reject (time) faulty data")
			print("check if your selection of timepoints is valid"); print(separator)
			print("N table"); print(table(data$N))
			print("check if your selection of N values is valid"); print(separator)
			print("List of table-names"); print(labels(data)[[2]])
			print("check if your selection of species is valid"); print(separator)
			flush.console()
		}
		for (speci in species){ #Schleife zum Abarbeiten der Substanzen
			col <- col + 1
			lwd <- lwdOffset #Liniendicke anheben
			for (t in time){ #Schleife zum Abarbeiten der Zeitpunkte
				lwd <- lwd + 1
				count <- count+1
				info[count] <- paste(fileCount,speci,t,sep=",")
				ymax <- c()
				xmax <- c()
				xmin <- c()
				if (verbose || (t == time[1] && speci == species[1] && fileCount == 1 && zoomCount == 1 && is.null(fitTo) && (is.null(xlim) || is.null(ylim)))){
					for(nn in N){ #Automatische Bestimmung der Plot-Groesse, auch fuer Verbose Informationen
						selection <- data[[speci]][data$N==nn & data$time==t]
						if(verbose) print(paste("Sample size for N=",nn,", t=",t," and Species=",speci," is ",length(selection),sep=""))
						dens <- density(selection)
						ymax <- max(ymax,dens$y)
						xmax <- max(xmax,dens$x)
						xmin <- min(xmin,dens$x)
					}
					xDown[count] <- xmin
					xUp[count] <- xmax
					yUp[count] <- ymax
					dens <- list(x=c(xmin,xmax),y=c(0,ymax))
				}
				if (!is.null(fitTo)) {dens <- density(data[[speci]][data$N==fitTo & data$time==t])} #nur an fitTo anpassen
				if (is.null(xlim)) {xlim <- c(min(dens$x),max(dens$x))} #xlim bestimmen, falls nicht definiert
				if (is.null(ylim)) {ylim <- c(0,max(dens$y))} #ylim bestimmen, falls nicht definiert
				if (t == time[1] && speci == species[1] && fileCount == 1){ #Erzeugen eines leeren Plots von geeigneter Groesse
					plot(1:2,1:2,type="n",xlim=xlim,ylim=ylim,xlab="",ylab="",main="")
				} #Eigentliche Plot-Funktion, Schleife zum Abarbeiten der N
				for (i in 1:length(N)) {lines(density(data[[speci]][data$N==N[i] & data$time==t]),type="l",lty=i,col=col,lwd=lwd)}
			}
		}
	} #Legenden anzeigen
	if (printLegend && length(N)>1){
		print("click position for scaling legend")
		flush.console()
		legend(locator(1),legend=paste("N=",N,sep=""),lty=1:25,lwd=lwdOffset+1)
	}
	if(printLegend && length(specieslegend)>1){
		print("click position for species legend")
		flush.console()
		legend(locator(1),legend=specieslegend,fill=1:length(specieslegend))
	}
	if(printLegend && length(time)>1){
		print("click position for time legend")
		flush.console()
		legend(locator(1),legend=paste("t=",time,sep=""),lwd=1:length(time)+lwdOffset)
	}
	title(main="",xlab="",ylab="")
	if(verbose){
		print("Plot size information, pattern: filenumber,species,time")
		print(info)
		print("x min=")
		print(xDown)
		print("x max=")
		print(xUp)
		print("y max=")
		print(yUp)
	} 
	if(zoomEnable){ #Zoom-Funktion
		if(all(is.na(zoomList))){zoomList <- list(xlow=xlim[1],xhigh=xlim[2],ylow=ylim[1],yhigh=ylim[2])}
		print("Now click 2 points to define zoom box. Left - Right = zoom in, Right - Left = zoom out, Doubleclick = END")
		flush.console()
		a<- locator(2)
		zoomList$xlow[zoomCount+1] <- a$x[1]
		zoomList$xhigh[zoomCount+1] <- a$x[2]
		zoomList$ylow[zoomCount+1] <- a$y[1]
		zoomList$yhigh[zoomCount+1] <- a$y[2]
		if(a$x[1]>a$x[2]) {zoomCount <- zoomCount - 1} #Raus-zoomen
		else{zoomCount <- zoomCount + 1} #Rein-zoomen
		if(a$x[1]!=a$x[2] & zoomCount != 0){ # Nur zoomen wenn Abbruch-Kriterien nicht erfuellt
			PlotDensity(filenames=filenames,N=N,dir=dir,time=time,species=species,divPerOne=divPerOne,fitTo=c(),xlim=c(zoomList$xlow[zoomCount],zoomList$xhigh[zoomCount]),ylim=c(zoomList$ylow[zoomCount],zoomList$yhigh[zoomCount]),printLegend=printLegend,zoomEnable=TRUE,zoomCount=zoomCount,zoomList=zoomList,verbose=verbose)
		}
	} 
	if (!is.na(saveAs)){dev.copy(pdf,paste(dir,saveAs,'.pdf',sep=""));dev.off()	} #letzten Plot speichern als
	invisible(data) #Daten aus der zuletzt eingelesenen Datei unsichtbar zurueck geben
}