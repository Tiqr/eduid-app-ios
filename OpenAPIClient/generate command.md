#  Run this to generate the swift API

openapi-generator-cli generate -i [path to json file] -g swift5 -o [output path] --skip-validate-spec --additional-properties=responseAs=AsyncAwait
