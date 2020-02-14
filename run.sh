#!/bin/bash

version=$(./d8 -e 'console.log(version())' | awk '{ print $1 }')
commit=$(cd out/v8/v8 && git rev-parse HEAD)

echo "::set-env name=V8_VERSION::${version}"
echo "::set-env name=V8_COMMIT::${commit}"

# shellcheck disable=SC2012
previous_version=$(ls postmortem/ | sort -V | tail -n 1)
# shellcheck disable=SC2012
previous_run=postmortem/"${previous_version}"/"$(ls postmortem/"${previous_version}"/ | sort | tail -n 1)"

dir=postmortem/"$version"/"$(date +%Y-%m-%d)"
mkdir -p "$dir"
cp current-symbols "$dir"/symbols
echo "$commit" > "$dir"/commit

if diff -Naur "$previous_run"/symbols "$dir"/symbols > "$dir"/diff; then
  echo "::set-env name=V8_UPDATED_SYMBOLS::false"
  exit 0
fi
echo "::set-env name=V8_UPDATED_SYMBOLS::true"

cat <<EOF > create-issue
---
title: ${version} $(date +%Y-%m-%d) postmortem metadata changes
---

  * \`git diff $(cat "$previous_run"/commit) ${commit}\`
  * \`git log $(cat "$previous_run"/commit) ${commit}\`

\`\`\`diff
$(cat "$dir"/diff)
\`\`\`

[Artifacts](https://github.com/${GITHUB_REPO}/actions/runs/${GITHUB_RUN_ID})

cc @mmarchini
EOF
