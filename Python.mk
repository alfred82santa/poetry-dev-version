# Author: Alfred

PACKAGE_COVERAGE=$(PACKAGE_DIR)

ISORT_PARAMS += -l 120 --reverse-relative

# Minimum coverage
COVER_MIN_PERCENTAGE=46


POETRY_EXECUTABLE?=poetry
POETRY_RUN?=${POETRY_EXECUTABLE} run

# Recipes ************************************************************************************
.PHONY: python-help requirements black beautify-imports beautify lint tests clean pull-request  publish  \
		flake autopep sort-imports

python-help:
	@echo "Python options"
	@echo "-----------------------------------------------------------------------"
	@echo "python-help:             This help"
	@echo "requirements:            Install package requirements"
	@echo "black:                   Reformat code using Black"
	@echo "beautify-imports:        Reformat and sort imports"
	@echo "beautify:                Reformat code (beautify-imports + black)"
	@echo "lint:                    Check code format"
	@echo "tests:                   Run tests with coverage"
	@echo "clean:                   Clean compiled files"
	@echo "pull-request:            Helper to run when a pull request is made"
	@echo "sort-imports:            Sort imports"
	@echo "build-doc-html:          Build documentation HTML files"

# Code recipes
requirements:
	poetry install --no-interaction --no-ansi


black:
	${POETRY_RUN} black .

beautify-imports:
	${POETRY_RUN} isort --profile black ${ISORT_PARAMS} ${PACKAGE_DIR}
	${POETRY_RUN} isort --profile black ${ISORT_PARAMS} ${PACKAGE_TESTS_DIR}
	${POETRY_RUN} absolufy-imports --never $(shell find ${PACKAGE_DIR} | grep .py$)
	${POETRY_RUN} absolufy-imports --never $(shell find ${PACKAGE_TESTS_DIR} | grep .py$)

beautify: beautify-imports black

lint:
	@echo "Running flake8 tests..."
	${POETRY_RUN} ruff ${PACKAGE_DIR} ${PACKAGE_TESTS_DIR}
	${POETRY_RUN} black ${PACKAGE_DIR} ${PACKAGE_TESTS_DIR} --check
	${POETRY_RUN} flake8 ${PACKAGE_COVERAGE}
	${POETRY_RUN} flake8 ${PACKAGE_TESTS_DIR}
	${POETRY_RUN} isort --profile black -c ${ISORT_PARAMS} ${PACKAGE_COVERAGE}
	${POETRY_RUN} isort --profile black -c ${ISORT_PARAMS} ${PACKAGE_TESTS_DIR}


tests:
	@echo "Running tests..."
	${POETRY_RUN} pytest -v --cov-report term-missing --cov-fail-under=${COVER_MIN_PERCENTAGE} --cov=${PACKAGE_COVERAGE} --exitfirst

clean:
	@echo "Cleaning compiled files..."
	find . | grep -E "(__pycache__|\.pyc|\.pyo)$ " | xargs rm -rf
	@echo "Cleaning distribution files..."
	rm -rf dist
	@echo "Cleaning build files..."
	rm -rf build
	@echo "Cleaning egg info files..."
	rm -rf ${PACKAGE_NAME}.egg-info
	@echo "Cleaning coverage files..."
	rm -f .coverage


pull-request: lint tests

build:
	${POETRY_EXECUTABLE} build

publish: build
	${POETRY_EXECUTABLE} publish
