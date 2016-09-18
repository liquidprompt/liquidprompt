.DEFAULT: test

SHELL=/bin/bash

test:
	bats -p tests

test-all: test-zsh test-bash

test-zsh:
	TEST_SHELL=zsh make test

test-bash:
	TEST_SHELL=bash make test

watch:
	@echo 'watching for changes...' && \
	fswatch -x liquidprompt liquid.ps1 liquid.theme tests/*.{bats,bash} 2>/dev/null | \
		while read -r f attr; do \
			if ! [ -z "$$f" ] && [[ "$$attr" =~ Updated ]]; then \
				echo "file changed: $$f ($$attr)"; \
				make -s test-all; \
			fi; \
		done
