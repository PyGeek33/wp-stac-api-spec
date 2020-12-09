#!/bin/bash

PATH=./node_modules/.bin:$PATH

# find all OpenAPI docs that are not fragments
FNAMES=`find . -name "openapi.yaml" -not -path "./fragments/*" -not -path "./node_modules/*"`

# use speccy to resolve
for fin in $FNAMES; do
    fout=./build/$fin
    mkdir -p ${fout%/*}
    #speccy resolve $fin > $fout
    swagger-cli bundle $fin -o $fout -t yaml
    cp build/index.html ${fout%/*}/
done

# use swagger-combine
#swagger-combine swagger.yaml -o build/STAC-complete.yml

# use openapi-merge-cli
#openapi-merge-cli -c openapi-merge-config.json
#json2yaml build/STAC-complete.json > build/STAC-complete.yml

# use yq
yq merge \
    build/core/openapi.yaml \
    build/item-search/openapi.yaml \
    build/ogcapi-features/openapi.yaml \
    build/ogcapi-features/extensions/transaction/openapi.yaml \
    build/ogcapi-features/extensions/version/openapi.yaml \
    | tee build/openapi.yaml