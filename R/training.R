train <- function(path = "", dataset_name = "", model_name = "models",
                  trn_batch_size = 128, val_batch_size = 4096, learning_rate = 0.0001,
                  seed = NULL, nb_epoch = 50000, emb_net = c(100, 90, 80, 70, 60),
                  int_net = c(60, 50, 40, 30, 20), nb_estop = 50, val_freq = 1) {

  # Import the cGNF Python module
  cgnf <- reticulate::import("cGNF")

  # Explicitly convert number to integers
  trn_batch_size <- as.integer(trn_batch_size)
  val_batch_size <- as.integer(val_batch_size)
  seed <- as.integer(seed)
  nb_epoch <- as.integer(nb_epoch)
  nb_estop <- as.integer(nb_estop)
  val_freq <- as.integer(val_freq)
  emb_net <- as.integer(emb_net)
  int_net <- as.integer(int_net)

  # Call the train function from the cGNF Python module
  result_py <- cgnf$train(path, dataset_name, model_name,
                          trn_batch_size, val_batch_size, learning_rate, seed,
                          nb_epoch, emb_net, int_net, nb_estop, val_freq)

  return(result_py)
}
