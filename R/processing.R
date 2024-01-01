process <- function(path = "", dataset_name = "", dag_name = "DAG",
                         sens_corr = NULL, test_size = 0.2,
                         cat_var = NULL, seed = NULL) {

  # Import the cGNF Python module
  cgnf <- reticulate::import("cGNF")

  # Handle the seed parameter
  if (!is.null(seed)) {
    seed <- as.integer(seed)
  } else {
    seed <- NULL 
  }

  # Call the process function from the cGNF Python module
  output <- capture.output(result_py <- cgnf$process(path, dataset_name, dag_name,
                            sens_corr, test_size, cat_var, seed))

  return(output)
}
