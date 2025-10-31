# tradedash Development Setup

## Prerequisites
- R >= 4.1.0
- RStudio (recommended)
- Git

## Setup

```r
# Install devtools if not already installed
install.packages("devtools")

# Install dependencies
devtools::install_deps()

# Load package for development
devtools::load_all()

# Run tests
devtools::test()

# Check package
devtools::check()
```

## Development Workflow

### Running Dashboard in Dev Mode

```r
# Load package
devtools::load_all()

# Launch dashboard
launch_dashboard()

# Make changes to R files
# Reload package
devtools::load_all()

# Test changes immediately
```

### Adding New Features

1. Create new R file in `R/` directory
2. Write functions with roxygen2 documentation
3. Update NAMESPACE: `devtools::document()`
4. Test locally: `devtools::load_all()`
5. Write tests in `tests/testthat/`
6. Run tests: `devtools::test()`

### Testing

```r
# Run all tests
devtools::test()

# Run specific test file
testthat::test_file("tests/testthat/test-dashboard.R")

# Interactive testing
testthat::test_local()
```

## Project Structure

```
tradedash/
├── R/
│   ├── dashboard.R          # Main dashboard app
│   ├── modules.R            # Shiny modules
│   ├── utils.R              # Utility functions
│   └── tradedash-package.R  # Package documentation
├── inst/
│   ├── config_template.yaml # Default config
│   └── www/                 # Static assets (CSS, JS, images)
├── tests/
│   └── testthat/            # Test files
├── examples/                # Example scripts
├── man/                     # Documentation (generated)
├── vignettes/               # Long-form documentation
├── DESCRIPTION              # Package metadata
├── NAMESPACE                # Package exports (generated)
└── README.md                # Package README
```

## Code Style

Follow tidyverse style guide:
```r
# Install styler
install.packages("styler")

# Style package
styler::style_pkg()
```

## Documentation

### Function Documentation

Use roxygen2 comments:
```r
#' Function Title
#'
#' @description Detailed description
#'
#' @param param1 Description of param1
#' @param param2 Description of param2
#'
#' @return Description of return value
#' @export
#'
#' @examples
#' \dontrun{
#' example_code()
#' }
my_function <- function(param1, param2) {
  # Function body
}
```

Generate documentation:
```r
devtools::document()
```

### Vignettes

Create vignettes for tutorials:
```r
usethis::use_vignette("tutorial-name")
```

Build vignettes:
```r
devtools::build_vignettes()
```

## Releasing

### Version Bump

```r
# Update version in DESCRIPTION
usethis::use_version("minor")  # or "major", "patch"
```

### Build and Check

```r
# Check package
devtools::check()

# Build package
devtools::build()

# Install locally
devtools::install()
```

### Git Workflow

```bash
# Create feature branch
git checkout -b feature/my-feature

# Make changes and commit
git add .
git commit -m "Add new feature"

# Push to GitHub
git push origin feature/my-feature

# Create pull request on GitHub
```

## Troubleshooting

### Shiny Issues

```r
# Enable reactlog for debugging
options(shiny.reactlog = TRUE)

# Launch with debugging
options(shiny.error = browser)
launch_dashboard()
```

### Package Issues

```r
# Clean and rebuild
devtools::clean_dll()
devtools::load_all()

# Check dependencies
devtools::missing_deps()

# Update dependencies
devtools::update_packages()
```

## Resources

- [R Packages Book](https://r-pkgs.org/)
- [Shiny Documentation](https://shiny.rstudio.com/)
- [tidyverse Style Guide](https://style.tidyverse.org/)
- [roxygen2 Documentation](https://roxygen2.r-lib.org/)
