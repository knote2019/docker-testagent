

git clone https://github.com/vllm-project/vllm.git
cd vllm

git checkout v0.11.2 -b master
git remote set-url origin git@github.com:knote2019/vllm-v0.11.2.git
git push origin master

TODO: clean

python use_existing_torch.py
rm -rf use_existing_torch.py

git add .
git commit -m "clean"
git push origin master

sed -i 's@https://github.com/vllm-project/flash-attention.git@https://github.com/knote2019/flash-attention-v2.6.3.git@' CMakeLists.txt

git add .
git commit -m "update flash-attention-url"
git push origin master
