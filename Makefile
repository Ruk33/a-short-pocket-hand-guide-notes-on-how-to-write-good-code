PANDOC					= docker run --rm --volume "`pwd`:/data" --user `id -u`:`id -g` pandoc/latex
GIT_REMOVE_REPOSITORY	= origin
GIT_BRANCH				= HEAD

.PHONY : push clean

book.pdf : book.md
	@echo "📖 Building PDF from $<"
	@$(PANDOC) --from markdown --pdf-engine=xelatex $< -o $@

book.html : book.md
	@echo "📰 Building HTML from $<"
	@$(PANDOC) --standalone --from markdown --to html5 --highlight-style tango $< -o $@

push : book.pdf book.html
	@echo "🚀 Pushing generated PDF and HTML to GIT repository"
	@git add $^
	@git commit -m "Auto generate PDF and HTML from book"
	@git push $(GIT_REMOVE_REPOSITORY) $(GIT_BRANCH)

clean :
	@echo "🗑️ Remove generated PDF and HTML"
	@$(RM) book.pdf book.html