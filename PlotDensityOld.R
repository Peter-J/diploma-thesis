PlotDensityOld <- function(filenames,range,t=c(1),spalte=c(2),epsilon=1/200,fitto=c(),xlim=c(),ylim=c(),lwdoffset=1,saveas=NA){
	x <- c()
	X <- c()
	Y <- c()
	k <- 0
	info <- c()
	col <- 0
	file <- 0
	specieslegend <- c()
	for (name in filenames){
		file <- file + 1
		speciesname <- paste("Datei-",file,", Spalte: ",spalte,sep="")
		specieslegend <- c(specieslegend,speciesname)
		abgewiesen <- array(dim=c(length(range),length(t),length(spalte)),dimnames=list(paste("N=",range),paste("t=",t),paste("Spalte=",spalte)))
		for (species in spalte){
			col <- col + 1
			lwd <- lwdoffset
			for (time in t){ 
				lwd <- lwd + 1
				k <- k+1
				info[k] <- paste(file,species,time,sep=",")
				data <- c()
				labels <- c()
				ymax <- c()
				xmax <- c()
				xmin <- c()
				for(N in range){
					filename <- paste("W:/Sim/",name,"-N=",N,"result",time,".csv",sep="")
					import <- read.csv(filename,header=FALSE, sep=";")
					abgewiesen[range==N,t==time,spalte==species] <- sum(time-import[,1] >= epsilon)
					import <- import[,species][time-import[,1]<epsilon]
					print(paste("Sample size for N=",N,", t=",time," and Species=",species," is ",length(import),sep=""))
					dens <- density(import)
					ymax <- max(ymax,dens$y)
					xmax <- max(xmax,dens$x)
					xmin <- min(xmin,dens$x)
					data <- append(data,import)
					labels <- append(labels,rep(N,length(import)))
				}
				x[k] <- xmin
				X[k] <- xmax
				Y[k] <- ymax
				if (!is.null(fitto)){
					dens <- density(data[labels==fitto])
				} else {
					dens <- list(x=c(xmin,xmax),y=c(0,ymax))
				}
				if (is.null(xlim)){
					xlim <- c(min(dens$x),max(dens$x))
				}
				if (is.null(ylim)){
					ylim <- c(0,max(dens$y))
				}
				if (time == t[1] && species == spalte[1] && file == 1){
					plot(1:2,1:2,type="n",xlim=xlim,ylim=ylim,xlab="",ylab="",main="")
					legend(xlim[1],ylim[2],legend=paste("N=",range,sep=""),lty=1:25,lwd=lwdoffset+1)
				}
				for (i in 1:length(range)){
					lines(density(data[labels==range[i]]),type="l",lty=i,col=col,lwd=lwd)
				}
				#sm.density.compare(data,labels,lty=1:25,col=rep("black",length(range)))
			}
		}
	}
	if(length(specieslegend)>1){legend(locator(1),legend=c("urspruenglich","reduziert"),fill=1:length(specieslegend))}
	if(length(t)>1){legend(locator(1),legend=paste("t=",t,sep=""),lwd=1:length(t)+lwdoffset)}
	title(main="",xlab="",ylab="")
	print("Plot-Size Information nach Schema: Datei,Spalte,Zeit")
	print(info)
	print("x min=")
	print(x)
	print("x max=")
	print(X)
	print("y max=")
	print(Y)
	invisible(list(data=data,N=labels))
	print("Wegen Zeitabweichung > epsilon verworfene Daten")
	print(abgewiesen)
	if (!is.na(saveas)){dev.copy(pdf,paste('Diplomarbeit/Simulation/',saveas,'.pdf',sep=""));dev.off()	}
}