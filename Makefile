payloads/labelbox.zip: assets/* __init__.py custom_labelbox.py fiftyone.yml
	rm -rf $@
	zip -r $@ assets/* __init__.py custom_labelbox.py fiftyone.yml

.PHONY: check-fiftyone-api
check-fiftyone-api:
ifndef FIFTYONE_API_URI
	$(error Environment variable FIFTYONE_API_URI is undefined)
endif
ifndef FIFTYONE_API_KEY
	$(error Environment variable FIFTYONE_API_KEY is undefined)
endif

.PHONY: install-labelbox
install-labelbox: payloads/labelbox.zip check-fiftyone-api
	python -c "import fiftyone.management as fom; fom.upload_plugin('payloads/labelbox.zip', overwrite=True)"

.PHONY: clean-pycache
clean-pycache:
	find -name __pycache__ -type d -exec rm -rf {} \;
