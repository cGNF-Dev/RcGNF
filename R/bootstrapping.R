# Helper function to recursively convert numeric values to integers and handle sens_corr
convert_to_int <- function(x) {
  if (is.numeric(x) && all(x == floor(x))) {
    return(as.integer(x))
  } else if (is.list(x)) {
    # Check if sens_corr is in the list and convert it to a Python dictionary
    if (!is.null(x$sens_corr)) {
      x$sens_corr <- reticulate::dict(x$sens_corr)
    }
    return(lapply(x, convert_to_int))
  }
  return(x)
}

bootstrap <- function(n_iterations = NULL, num_cores_reserve = '2', base_path = NULL,
                      folder_name = 'bootstrap', dataset_name = NULL, dag_name = NULL,
                      process_args = NULL, train_args = NULL, skip_process = FALSE,
                      skip_train = FALSE, sim_args_list = NULL) {

  # Import the cGNF Python module
  cgnf <- reticulate::import("cGNF")

  # Convert R arguments to Python compatible types
  num_cores_reserve <- as.integer(num_cores_reserve)
  n_iterations <- as.integer(n_iterations)

  process_args <- convert_to_int(process_args)
  train_args <- convert_to_int(train_args)
  sim_args_list <- lapply(sim_args_list, convert_to_int)

  # Call the bootstrap function from the cGNF Python module
  result_py <- cgnf$bootstrap(n_iterations, num_cores_reserve, base_path,
                              folder_name, dataset_name, dag_name, process_args,
                              train_args, skip_process, skip_train, sim_args_list)

  return(result_py)
}
