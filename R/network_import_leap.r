#' @title Output Parser for LEAP
#' @description This function parses the standard output generated by the BEELINE tool LEAP.
#' @param file_path a file path to the LEAP output file generated by BEELINE.
#' @author Sergio Vasquez and Hajk-Georg Drost
#' @examples
#' # path to LEAP output file
#' leap_output <- system.file('beeline_examples/LEAP/outFile0.txt', package = 'edgynode')
#' # import LEAP specific output
#' leap_parsed <- leap(leap_output)
#' # look at output
#' head(leap_parsed)
#' @export

leap <- function(file_path) {
  
  if (!file.exists(file_path))
    stop("Please specify a valid file path to ", file_path, "...", .call = FALSE)
  
  leap_output <- suppressMessages(suppressWarnings(readr::read_delim(file = file_path, col_names = TRUE, delim = "\t")))
  
  ngenes <- length(unique(leap_output$Gene1))
  res <- matrix(NA_real_, ngenes, ngenes)
  gene_names <- unique(leap_output$Gene1)
  
  colnames(res) <- gene_names
  res <- dplyr::bind_cols(X = gene_names, as.data.frame(res))
  
  res <- as.data.frame(res)
  
  
  for (k in 1:length(leap_output$Score)) {
    
    res[match(leap_output[k, 1], gene_names),
        match(leap_output[k, 2], gene_names) + 1] <- leap_output[k, 3]
    
  }
  
  colnames(res)[1] <- "Gene"
  
  result <- data.matrix(res[,2:ncol(res)])
  
  row.names(result) <- res[,1]
  
  diag(result) <- 0
  
  return(result)
}
