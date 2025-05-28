

git clone https://github.com/vllm-project/flash-attention.git
cd flash-attention

git checkout main
git branch -D master
git checkout 013f0c4fc47e6574060879d9734c1df8c5c273bd -b master
git remote set-url origin git@github.com:knote2019/vllm-flash-attention-v0.6.3.git
git push origin master

rm -rf assets/
rm -rf AUTHORS
rm -rf benchmarks/
rm -rf examples/
rm -rf .github/
rm -rf LICENSE
rm -rf MANIFEST.in
rm -rf tests/
rm -rf training/
rm -rf usage.md

git add .
git commit -m "clean"
git push origin master
