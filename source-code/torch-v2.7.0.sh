

git clone https://github.com/pytorch/pytorch.git
cd pytorch

git checkout main
git branch -D master
git checkout v2.7.0 -b master
git remote set-url origin ssh://git@bitbucket.iluvatar.ai:7999/swte/pytorch-v2.7.0.git
git push origin master

rm -rf .bazelignore
rm -rf .bazelrc
rm -rf .bazelversion
rm -rf .buckconfig.oss
rm -rf .circleci/
rm -rf .clang-format
rm -rf .clang-tidy
rm -rf .cmakelintrc
rm -rf .coveragerc
rm -rf .ctags.d/
rm -rf .devcontainer/
rm -rf .dockerignore -> .gitignore
rm -rf .flake8
rm -rf .gdbinit
rm -rf .git-blame-ignore-revs
rm -rf .github/
rm -rf .lintrunner.toml
rm -rf .lldbinit
rm -rf .vscode/
rm -rf CITATION.cff
rm -rf CODEOWNERS
rm -rf CODE_OF_CONDUCT.md
rm -rf CONTRIBUTING.md
rm -rf Dockerfile
rm -rf GLOSSARY.md
rm -rf NOTICE
rm -rf RELEASE.md
rm -rf SECURITY.md
rm -rf WORKSPACE
rm -rf benchmarks/
rm -rf binaries/
rm -rf docker.Makefile
rm -rf docs/
rm -rf ios/
rm -rf mypy-strict.ini
rm -rf mypy.ini
rm -rf mypy_plugins/
rm -rf pt_ops.bzl
rm -rf pt_template_srcs.bzl
rm -rf pytest.ini
rm -rf test/
rm -rf ubsan.supp
rm -rf ufunc_defs.bzl

git add .
git commit -m "clean"
git push origin master
