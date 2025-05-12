# local-project-opener


Open sd-cold-start-recs 
Check out to pr
use java 8
open docker if not
check if the docker port is taken
use external service

test


## How to interact with toml using `yq`
`yq` is a light-weight CLI processor for toml.

```bash
export TOML_FILEPATH=project-info.toml

# Output a TOML file
yq eval -oy $TOML_FILEPATH

# Output the first element in a YAML file that contains only an array
yq eval -oy '.[0]' $TOML_FILEPATH

# Output thhe element with given ID, e.g. "project1"
yq eval -oy '.["project1"]' $TOML_FILEPATH

# Set [or overwrite] a key to a value in a file
yq eval '.key = "value"' --inplace path/to/file.yaml


# read project info with project-id
yq e -oy ".$PJID" $TOML_FILEPATH

```



