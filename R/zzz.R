find_system_python <- function() {
  print("Finding system Python...")
  home_dir <- normalizePath(Sys.getenv("HOME"), winslash = "/")

  potential_paths <- if (.Platform$OS.type == "windows") {
    c(paste0(home_dir, "/AppData/Local/Programs/Python/Python39/python.exe"),
      "C:/Python39/python.exe",
      "C:/Python38/python.exe",
      "C:/Python37/python.exe",
      "C:/Python36/python.exe",
      "C:/Python35/python.exe",
      "C:/Python27/python.exe")
  } else {
    c("/usr/bin/python")
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

  # Create the virtual environment if it doesn't exist
  if (!reticulate::virtualenv_exists(envname)) {
    reticulate::virtualenv_create(envname, python = python_path)
    if (!reticulate::virtualenv_exists(envname)) {
      stop("Failed to create virtual environment: ", envname)
    }
  }


  # Use the virtual environment
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

    message("RcGNF virtual environment is now installed and ready to use in: ", envname)
  }
}

.onLoad <- function(libname, pkgname) {
  # Define the virtual environment name
  envname <- "cgnf_env"

  # Path to the virtual environment
  venv_path <- if (.Platform$OS.type == "windows") {
    file.path(Sys.getenv("HOME"), ".virtualenvs", envname, "Scripts", "python.exe")
  } else {
    file.path(Sys.getenv("HOME"), ".virtualenvs", envname, "bin", "python")
  }

  # Check if the virtual environment already exists
  if (reticulate::virtualenv_exists(envname)) {
    message("RcGNF virtual environment found and ready for use")
    # Use the Python executable from the virtual environment
    reticulate::use_python(venv_path, required = TRUE)
  } else {
    # Find system Python if the virtual environment does not exist
    python_path <- find_system_python()
    if (is.null(python_path)) {
      python_path <- Sys.getenv("RCGNF_PYTHON_PATH")
      if (python_path == "") {
        stop("Python installation not found in common locations. Please set the RCGNF_PYTHON_PATH environment variable to your Python installation and reload the package.")
      } else if (!file.exists(python_path)) {
        stop("The path in RCGNF_PYTHON_PATH does not exist. Please correct the RCGNF_PYTHON_PATH environment variable.")
      }
    }

    # Set up the virtual environment and install cGNF
    setup_cgnf(python_path)
  }
}

