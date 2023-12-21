find_system_python <- function() {
  print("Finding system Python...")
  potential_paths <- if (.Platform$OS.type == "windows") {
    c("C:/Python39/python.exe", "C:/Python38/python.exe",
      "C:/Python37/python.exe", "C:/Python36/python.exe",
      "C:/Python35/python.exe", "C:/Python27/python.exe")
  } else {
    c("/usr/bin/python", "/usr/local/bin/python",
      "/opt/homebrew/bin/python", "/usr/bin/python3",
      "/usr/local/bin/python3")
  }

  for (path in potential_paths) {
    if (file.exists(path)) {
      print(paste("Python found at:", path))
      return(path)
    }
  }
  print("No Python found in common locations.")
  return(NULL)
}

setup_cgnf <- function(python_path) {
  envname <- "cgnf_env"
  venv_path <- if (.Platform$OS.type == "windows") {
    file.path(Sys.getenv("HOME"), ".virtualenvs", envname)
  } else {
    file.path(Sys.getenv("HOME"), ".virtualenvs", envname)
  }

  reticulate::use_virtualenv(envname, required = TRUE)

  # Check if cGNF is already installed
  installed_packages <- reticulate::py_list_packages(envname)
  if (!"cGNF" %in% installed_packages$package) {
    # Installation from test PyPI
    index_url <- "https://test.pypi.org/simple/"
    extra_index_url <- "https://pypi.org/simple"
    reticulate::py_install(packages = "cGNF",
                           envname = envname,
                           method = "auto",
                           pip_options = c(sprintf("--index-url %s", index_url),
                                           sprintf("--extra-index-url %s", extra_index_url)))

    message("cGNF is successfully installed in the virtual environment: ", envname)
  } else {
    message("cGNF is already installed in the virtual environment: ", envname)
  }
}

.onLoad <- function(libname, pkgname) {
  python_path <- find_system_python()

  if (is.null(python_path)) {
    message("Python installation not found in common locations.")
    python_path <- readline(prompt = "Please enter the path to your Python installation: ")

    if (python_path == "") {
      stop("No Python path provided. Exiting.")
    } else if (!file.exists(python_path)) {
      stop("The specified Python path does not exist. Exiting.")
    }
  }

  # Construct the path to the Python executable in the virtual environment
  venv_python <- if (.Platform$OS.type == "windows") {
    file.path(Sys.getenv("HOME"), ".virtualenvs", "cgnf_env", "Scripts", "python.exe")
  } else {
    file.path(Sys.getenv("HOME"), ".virtualenvs", "cgnf_env", "bin", "python")
  }

  # Set RETICULATE_PYTHON to the virtual environment Python path
  Sys.setenv(RETICULATE_PYTHON = venv_python)

  setup_cgnf(python_path)
}



