DSTIL Git Hooks
===============

For use with [overcommit]().

```
cd my-repo
git submodule add https://github.com/dstil/git-hooks .git-hooks
curl https://raw.githubusercontent.com/dstil/git-hooks/master/.overcommit.yml -o .overcommit.yml
overcommit --install
git add -A
git commit -m "QUALITY: Install DSTIL Git hooks"
# Overcommit will ask you to check and sign some things
```

[overcommit]: https://github.com/brigade/overcommit
