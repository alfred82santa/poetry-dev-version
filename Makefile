
include Config.mk

.EXPORT_ALL_VARIABLES:

help:
	@echo "Recipes for ${PACKAGE_NAME} package"
	@echo
	@echo "General options"
	@echo "-----------------------------------------------------------------------"
	@echo "help:                    This help"
	@echo
	@make --quiet python-help
	@echo
	@make --quiet HELP_PREFIX="docs." docs.help


include Python.mk

docs.%:
	@make -C docs/ HELP_PREFIX="docs." $(*)
