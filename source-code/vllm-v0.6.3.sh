

git clone https://github.com/vllm-project/vllm.git
cd vllm

git checkout main
git branch -D master
git checkout v0.6.3 -b master
git remote set-url origin ssh://git@bitbucket.iluvatar.ai:7999/swte/vllm-v0.6.3.git
git push origin master

rm -rf benchmarks/
rm -rf .buildkite/
rm -rf .clang-format
rm -rf CODE_OF_CONDUCT.md
rm -rf collect_env.py
rm -rf CONTRIBUTING.md
rm -rf Dockerfile*
rm -rf .dockerignore
rm -rf docs/
rm -rf examples/
rm -rf find_cuda_init.py
rm -rf format.sh
rm -rf .github/
rm -rf LICENSE
rm -rf python_only_dev.py
rm -rf README.md
rm -rf .readthedocs.yaml
rm -rf requirements-cpu.txt
rm -rf requirements-dev.txt
rm -rf requirements-hpu.txt
rm -rf requirements-lint.txt
rm -rf requirements-neuron.txt
rm -rf requirements-openvino.txt
rm -rf requirements-rocm.txt
rm -rf requirements-test.in
rm -rf requirements-test.txt
rm -rf requirements-tpu.txt
rm -rf requirements-xpu.txt
rm -rf SECURITY.md
rm -rf tests/
rm -rf tools/
python use_existing_torch.py
rm -rf use_existing_torch.py
rm -rf .yapfignore

git add .
git commit -m "clean"
git push origin master
