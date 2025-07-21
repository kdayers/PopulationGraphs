rm(list=ls())

library(seqinr)
library(tidyverse)
library(igraph)
library(EnvStats)

filenames = dir(pattern="*.csv")

edge_densities<-c()

indivs<-50
cutoff <- 0.135

#for(k in 1:length(filenames) ){
 # distancematrix<-read.csv(filenames[k],header=TRUE)
 # adjacent<-matrix(,nrow=indivs,ncol=indivs)
 # for (i in 1:indivs){
#    for (j in 1:indivs){
 #     if (i==j){
 #       adjacent[i,j]<-0
#      }
  #    else {
 #       if (distancematrix[i,j] < cutoff) { 
 #         adjacent[i,j] <- 1
 #       }
 #       else {
 #        adjacent[i,j] <- 0
 #       }
 #     }  
 #   }
 # }

 # edge_density<-sum(adjacent)/(2*(choose(indivs,2)))
#  edge_densities[k]<-edge_density
#}

#df <- data.frame(matrix(unlist(edge_densities), nrow=length(edge_densities), byrow=TRUE))


deg_variances<-c()

for(k in 1:length(filenames) ){
  distancematrix<-read.csv(filenames[k],header=TRUE)
  adjacent<-matrix(,nrow=indivs,ncol=indivs)
  for (i in 1:indivs){
    for (j in 1:indivs){
      if (i==j){
        adjacent[i,j]<-0
      }
      else {
        if (distancematrix[i,j] < cutoff) { 
          adjacent[i,j] <- 1
        }
        else {
          adjacent[i,j] <- 0
        }
      }  
    }
  }
  
  
  deg_variance<-var(rowSums(adjacent)/2)
  deg_variances[k]<-deg_variance
}

mean(deg_variances)


#g1 <- graph_from_adjacency_matrix(adjacent)
#plot(g1,edge.arrow.mode=0,vertex.color='#DA8F83',vertex.size=10,)
