# iPC VRE Dorothea Executor

Example pipelines file that is ready to run in the VRE matching the code in the HowTo documentation.

This repo structure dorothea and tools can be forked and used as the base template for new tools and dorothea. It should have all of the base functionality and is set up for unit testing and with pylint to ensure code clarity.

## Requirements

- Python 3.6 or later (Recommended 3.7)
- Python3.6-pip, Python3.6-dev and Python3.6-venv or later
- R-4.0

```bash
sudo apt update
sudo apt install python3.6 
sudo apt install python3.6-pip python3.6-dev python3.6-venv
sudo apt install r-base
```

## Installation

Directly from GitHub:

```bash
cd $HOME

git clone https://github.com/inab/vre_dorothea_executor.git

cd vre_dorothea_executor
```

Create the Python environment:

```bash
python3 -m venv $HOME/vre_dorothea_executor/venv
source venv/bin/activate
pip install -r requirements.txt
```

## Run the Wrapper
```bash
./VRE_RUNNER --config tests/basic/config.json --in_metadata tests/basic/in_metadata.json --out_metadata out_metadata.json --log_file VRE_RUNNER.log
```
