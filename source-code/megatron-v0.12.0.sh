

git clone https://github.com/NVIDIA/Megatron-LM.git
cd Megatron-LM

git checkout main
git branch -D master
git checkout core_v0.12.0 -b master
git remote set-url origin ssh://git@bitbucket.iluvatar.ai:7999/swte/megatron-v0.12.0.git
git push origin master

rm -rf CHANGELOG.md
rm -rf CODEOWNERS
rm -rf CONTRIBUTING.md
rm -rf .coveragerc
rm -rf Dockerfile.ci.dev
rm -rf Dockerfile.ci.lts
rm -rf Dockerfile.linting
rm -rf docs/
rm -rf examples/
rm -rf .flake8
rm -rf .github/
rm -rf .gitlab/
rm -rf .gitlab-ci.yml
rm -rf images/
rm -rf LICENSE
rm -rf MANIFEST.in
rm -rf mypy.ini
rm -rf pretrain_bert.py
rm -rf pretrain_ict.py
rm -rf pretrain_mamba.py
rm -rf pretrain_retro.py
rm -rf pretrain_t5.py
rm -rf pretrain_vision_classify.py
rm -rf pretrain_vision_dino.py
rm -rf pretrain_vision_inpaint.py
rm -rf .pylintrc
rm -rf pytest.ini
rm -rf requirements_ci.txt
rm -rf requirements_mlm.txt
rm -rf README.md
rm -rf tasks/
rm -rf tests/
rm -rf tools/

git add .
git commit -m "clean"
git push origin master
