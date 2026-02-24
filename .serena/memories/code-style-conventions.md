# Code Style & Conventions

## Python (API, Worker) - Ruff

### Configuration: `ruff.toml`

| Setting | Value |
|---------|-------|
| Line length | 88 |
| Target version | Python 3.12 |
| Quote style | double |
| Indent style | space |

### Rule Sets
- `E/W`: pycodestyle (errors/warnings)
- `F`: Pyflakes
- `I`: isort (import sorting)
- `B`: flake8-bugbear
- `UP`: pyupgrade
- `ASYNC`: flake8-async
- `S`: bandit (security)
- `SIM`: flake8-simplify
- `RUF`: Ruff-specific

### Ignored Rules
- `B008`: Function call in argument defaults (for FastAPI Depends)
- `S101`: Use of assert (allowed in tests)

### Type Checking
- mypy with strict mode
- Pydantic plugin enabled

## Dart/Flutter (Mobile)

### Configuration: `analysis_options.yaml` + `very_good_analysis`

- Strict mode enabled
- All recommended lints
- Flutter-specific lints
- `dart format` for formatting

## Terraform

- `terraform fmt` for formatting
- `terraform validate` for validation

## General Conventions

### Naming
- Python: snake_case for functions/variables, PascalCase for classes
- Dart: camelCase for functions/variables, PascalCase for classes

### Documentation
- Python: Docstrings (Google style recommended)
- Dart: Dartdoc comments

### Type Safety
- **ALWAYS** use type hints in Python
- **ALWAYS** use strict types in Dart
