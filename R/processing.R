process <- function(path = "", dataset_name = "", dag_name = "DAG",
                         sens_corr = NULL, test_size = 0.2,
                         cat_var = NULL, seed = NULL) {

  # Import the cGNF Python module
  cgnf <- reticulate::import("cGNF")

  # Handle the seed parameter
  if (!is.null(seed)) {
    seed <- as.integer(seed)
  } else {
    seed <- reticulate::py$None  # Explicitly set to Python's None
  }

  # If sens_corr is provided, convert it to a Python dictionary
  if (!is.null(sens_corr)) {
    sens_corr_py <- reticulate::dict(sens_corr)
  } else {
    sens_corr_py <- NULL
  }

  # Call the process function from the cGNF Python module
  result_py <- cgnf$process(path, dataset_name, dag_name,
                            sens_corr_py, test_size, cat_var, seed)

  return(result_py)
}
