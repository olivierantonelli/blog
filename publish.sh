poetry run jupyter-book build blog
git add -A
git commit -m "$@"
git push
poetry run ghp-import -n -p -f blog/_build/html
