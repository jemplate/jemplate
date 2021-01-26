#!/usr/bin/env bash

set -eu

src=$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)

module_filepath=$1 yaml_filepath=$2

module_file=$(basename "$module_filepath")
module_name=${module_file%.py}
module_path=$(dirname "$module_filepath")

export PYTHONPATH=$src/python/lib:$module_path

python3 -c "
import $module_name, yaml
text = open('$yaml_filepath').read()
data = yaml.safe_load(text)
output = $module_name.render('main.tt', data)
print(output, end='')
"
