



#' Print method for kpi objects
#'
#' @param x kpi object
#' @param table logical, whether to add a table stats by grouping variable(s) to the output
#' @param outlier logical, whether to add a table of outliers to the output
#' @param ... not currently used
#'
#' @return
#' @export
#'
#' @examples
print.kpi <- function(x, table = TRUE, outlier = TRUE, ...){


  cat("Study level:\n")
  print(as.data.frame(x[[2]]$calc), row.names = FALSE)
  cat("\n")

  if(any(!is.na(x[[1]]$by))){
    n <- length(x[[1]]$by)

    invisible(lapply(seq(3, 2 + n, 1),
           function(y){
             cat(paste0("Grouped by ", names(x)[y], ":\n"))
             if(table){
               print(as.data.frame(x[[y]]$calc), row.names = FALSE)
               cat("\n")
             }
             if(outlier){
               if(nrow(x[[y]]$outlier) == 0){
                 cat("No outliers")
               } else {
                 print(as.data.frame(x[[y]]$outlier), row.names = FALSE)
               }
             }
             cat("\n")
             return(NULL)
           }))

  }



}
