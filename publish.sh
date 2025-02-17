poetry run jupyter-book build firstbook
git add -A
git commit -m "publish"
git push
poetry run ghp-import -n -p -f firstbook/_build/html