#-----------------------------------------------------------------------------------------------------------------------
git clone https://github.com/Dao-AILab/flash-attention.git
cd flash-attention

git checkout main
git branch -D master
git checkout v2.6.3 -b master
git remote set-url origin ssh://git@bitbucket.iluvatar.ai:7999/swte/flash-attention-v2.6.3.git
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

#-----------------------------------------------------------------------------------------------------------------------
git clone https://github.com/NVIDIA/TransformerEngine.git
cd TransformerEngine

git checkout main
git branch -D master
git checkout v2.1 -b master
git remote set-url origin ssh://git@bitbucket.iluvatar.ai:7999/swte/TransformerEngine-v2.1.git
git push -u origin master

#-----------------------------------------------------------------------------------------------------------------------
git clone https://github.com/NVIDIA/Megatron-LM.git
cd Megatron-LM

git checkout main
git branch -D master
git checkout core_r0.8.0 -b master
git remote set-url origin ssh://git@bitbucket.iluvatar.ai:7999/swte/megatron-v0.8.0.git
git push origin master

rm -rf CODEOWNERS
rm -rf CONTRIBUTING.md
rm -rf .coveragerc
rm -rf Dockerfile.ci
rm -rf Dockerfile.linting
rm -rf docs/
rm -rf examples/
rm -rf .github/
rm -rf .gitlab-ci.yml
rm -rf images/
rm -rf jet-tests.yml
rm -rf LICENSE
rm -rf MANIFEST.in
rm -rf pretrain_bert.py
rm -rf pretrain_ict.py
rm -rf pretrain_mamba.py
rm -rf pretrain_retro.py
rm -rf pretrain_t5.py
rm -rf pretrain_vision_classify.py
rm -rf pretrain_vision_dino.py
rm -rf pretrain_vision_inpaint.py
rm -rf README.md
rm -rf tasks/
rm -rf tests/
rm -rf tools/

git add .
git commit -m "clean"
git push origin master
