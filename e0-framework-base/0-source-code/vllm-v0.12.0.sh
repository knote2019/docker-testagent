

git clone https://github.com/vllm-project/vllm.git
cd vllm

git checkout v0.12.0 -b master
git remote set-url origin git@github.com:knote2019/vllm-v0.12.0.git
git push origin master

rm -rf .buildkite
rm -rf .gemini
rm -rf .github
rm -rf benchmarks
rm -rf docker
rm -rf docs
rm -rf examples
rm -rf tests
rm -rf tools
rm -rf .clang-format
rm -rf .coveragerc
rm -rf .dockerignore
rm -rf .git-blame-ignore-revs
rm -rf .markdownlint.yaml
rm -rf .pre-commit-config.yaml
rm -rf .readthedocs.yaml
rm -rf .shellcheckrc
rm -rf .yapfignore
rm -rf CODE_OF_CONDUCT.md
rm -rf CONTRIBUTING.md
rm -rf DCO
rm -rf RELEASE.md
rm -rf SECURITY.md
rm -rf codecov.yml
rm -rf mkdocs.yaml
python use_existing_torch.py
rm -rf use_existing_torch.py

git add .
git commit -m "clean"
git push origin master
