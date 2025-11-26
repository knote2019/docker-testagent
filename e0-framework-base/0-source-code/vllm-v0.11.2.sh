

git clone https://github.com/vllm-project/vllm.git
cd vllm

git checkout v0.11.2 -b master
git remote set-url origin git@github.com:knote2019/vllm-v0.11.2.git
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

sed -i 's@https://github.com/vllm-project/flash-attention.git@https://github.com/knote2019/flash-attention-v2.6.3.git@' CMakeLists.txt

git add .
git commit -m "update flash-attention-url"
git push origin master
