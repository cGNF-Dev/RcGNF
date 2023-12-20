sim <- function(path = "", dataset_name = "", model_name = "models", n_mce_samples = 10000,
                       treatment = '', cat_list = c(0, 1), moderator = NULL, quant_mod = 4,
                       mediator = NULL, outcome = NULL, inv_datafile_name = 'potential_outcome') {

  # Import the cGNF Python module
  cgnf <- reticulate::import("cGNF")

  # Convert R arguments to Python compatible types
  cat_list <- as.integer(cat_list)
  quant_mod <- as.integer(quant_mod)
  n_mce_samples <- as.integer(n_mce_samples)

  result_py <- cgnf$sim(path, dataset_name, model_name, n_mce_samples,
                        treatment, cat_list, moderator, quant_mod,
                        mediator, outcome, inv_datafile_name)

  return(result_py)
}
