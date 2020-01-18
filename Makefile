# Minimal makefile for Sphinx documentation
#


# You can set these variables from the command line.
SPHINXOPTS  =
SPHINXBUILD = sphinx-build
SPHINXPROJ  = CasADi
SOURCEDIR   = source
BUILDDIR    = build
DOCSDIR     = $(shell git rev-parse --abbrev-ref HEAD | sed -e 's/\.//g')

# Put it first so that "make" without argument is like "make help".
help:
	@$(SPHINXBUILD) -M help "$(SOURCEDIR)" "$(BUILDDIR)" $(SPHINXOPTS) $(O)

.PHONY: clean help Makefile html_body html_toc html_index html pdf

# Catch-all target: route all unknown targets to Sphinx using the new
# "make mode" option.  $(O) is meant as a shortcut for $(SPHINXOPTS).
%: Makefile
	@$(SPHINXBUILD) -M $@ "$(SOURCEDIR)" "$(BUILDDIR)" $(SPHINXOPTS) $(O)

.DEFAULT_GOAL := pdf

clean:
	rm -rf $(BUILDDIR) snippets *.in $(DOCSDIR) *.pdf

html_body:
	make singlehtml SPHINXOPTS="-D html_theme=bare_body"
	# sed -i 's/{{</{\&lbrace;</g' build/singlehtml/index.html
	# sed -i 's/>}}/>}\&rbrace;/g' build/singlehtml/index.html

html_toc:
	make singlehtml SPHINXOPTS="-D html_theme=bare_body -D 'html_theme_options.mode=toc'"
	# sed -i 's/index\.html//g' build/singlehtml/index.html

html_index:
	python -c "from scripts.util import *; create_index_md('$(BUILDDIR)/$(DOCSDIR)/_index.md', 'config.yaml')"

html: clean
	mkdir -p $(BUILDDIR)/$(DOCSDIR)
	$(MAKE) html_body
	mv $(BUILDDIR)/singlehtml/index.html $(BUILDDIR)/$(DOCSDIR)/content.html
	$(MAKE) html_toc
	mv $(BUILDDIR)/singlehtml/index.html $(BUILDDIR)/$(DOCSDIR)/sidebar.html
	rm -rf $(BUILDDIR)/doctrees $(BUILDDIR)/singlehtml
	$(MAKE) html_index

pdf: clean
	make latexpdf
	cp $(BUILDDIR)/latex/CasADi.pdf users_guide.pdf
