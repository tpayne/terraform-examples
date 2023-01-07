#!/bin/sh

getPaths() {
  echo "$@" | tr ' ' '\n' | xargs -n1 dirname | sort -u
  return $?
}

goPath() {
  cmd=${1}
  shift
  for path in "$@"; do
    pushd $path > /dev/null 2>&1
    (${cmd})
    popd > /dev/null 2>&1
  done
}

runTFDocs() {
  paths=$(getPaths "$@")

  for path in ${paths}; do
     terraform-docs md "${path}" --output-file "inputs.md"
  done
  return $?
}

runTFSec() {
  goPath "tfsec --exclude-downloaded-modules" $(getPaths "$@")
  return $?
}

runTFFmt() {
  echo "$@" | xargs -n1 terraform fmt
  return $?
}

runTFLint() {
  goPath tflint $(getPaths "$@")
  return $?
}

runArmScan() {
  paths=$(getPaths "$@")

  cd /terraform-tools/arm-ttk/

  for path in ${paths}; do
pwsh << EOF
      Get-ChildItem *.ps1, *.psd1, *.ps1xml, *.psm1 -Recurse | Unblock-File
      Import-Module ./arm-ttk.psd1
      Test-AzTemplate -TemplatePath ${path}
EOF
  done
  return $?
}

if [ "x$1" = "xfmt" ]; then
  shift
  echo "$@"
  runTFFmt "$@"
elif [ "x$1" = "xdocs" ]; then
  shift
  echo "$@"
  runTFDocs "$@"
elif [ "x$1" = "xsec" ]; then
  shift
  echo "$@"
  runTFSec "$@"
elif [ "x$1" = "xlint" ]; then
  shift
  echo "$@"
  runTFLint "$@"
elif [ "x$1" = "xarm" ]; then
  shift
  echo "$@"
  runArmScan "$@"
fi

exit $?