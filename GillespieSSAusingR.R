for(N in 1:17*100){
	print(N);
	flush.console();
	x0 <- c(E=100,R=N,H=0,P=0)
	a <- c("E*R*N/200","H*N^3/200","H*N^2/200")
	nu <- matrix(c(-1,-1,1,0,1,1,-1,0,1,0,-1,1),nrow=4,byrow=FALSE)
	print(ssa(x0=x0,a=a,nu=nu,tf=3.01)$stats$elapsedWallTime)
}
[1] 100
elapsed 
   2.01 
[1] 200
elapsed 
   9.55 
[1] 300
elapsed 
  34.97 
[1] 400
elapsed 
  94.27 
[1] 500
elapsed 
 226.23 
[1] 600
elapsed 
 457.39 
[1] 700
elapsed 
  801.3 
[1] 800
elapsed 
1384.66 
[1] 900
elapsed 
1895.06 
[1] 1000
elapsed 
3038.78 
[1] 1100