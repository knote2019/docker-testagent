

git clone https://github.com/Dao-AILab/flash-attention.git
cd flash-attention

git checkout main
git branch -D master
git checkout v2.6.3 -b master
git remote set-url origin git@github.com:knote2019/flash-attention-v2.6.3.git
git push origin master

rm -rf assets/
rm -rf AUTHORS
rm -rf benchmarks/
rm -rf examples/
rm -rf .github/
rm -rf LICENSE
rm -rf MANIFEST.in
rm -rf README.md
rm -rf tests/
rm -rf training/
rm -rf usage.m

git add .
git commit -m "clean"
git push origin master
