

git clone https://github.com/NVIDIA/TransformerEngine.git
cd TransformerEngine

git checkout main
git branch -D master
git checkout v2.1 -b master
git remote set-url origin ssh://git@bitbucket.iluvatar.ai:7999/swte/TransformerEngine-v2.1.git
git push -u origin master
