#### Prepare a function to format the output (lists) from the function kpi

### for the moment the function would work only if the risk is present, otherwise the colors would not make sense (?)


kpi_format <- function(kpilist){


  ### get the length of the list
  l <- length(kpilist)

  ## get the length of the risk table selected (from any of the lists, by default 1)
  l_risk <- length(table(kpilist[[1]]$risk))
  name_risk <- names(table(kpilist[[1]]$risk))

  if (l_risk==2){
    color_table <- c("green","red")
  }else if(l_risk==3){
    color_table <- c("green","yellow","red")
  }else if(l_risk==4){
    color_table <- c("green","yellow","orange","red")
  }else{
    color_table <- c("green","yellow","orange","red","violet")
  }


  for (i in 1:l){

    tab <- as.data.frame(kpilist[[i]])

    ### format and prepare the color to export in excel

  }

  return(list(color_table,name_risk))


}

#kpi_format(k)
