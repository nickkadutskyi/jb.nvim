#!/usr/bin/env bash

# Sample comment
let "a=16 << 2" "b=64";
(( a=16 << 2, b=64 ))
b="Sample text";

# shellcheck disable=SC1234
[ -f "test.txt" ] && echo exists || echo does not exist
[[ -f "test.txt" || -L "test.txt" ]] && echo "file or symbolic link"
backgroundCommand |& otherCommand >/dev/null &

foo() {
  if [ $string1 == \"${1}\" ]; then
    for url in `cat example.txt`; do
      curl ${url} > result.html
    done
  fi

  local myLocalVar=value
  myLocalVar=new-value
  echo $myLocalVar
}

rm -f $(find / -name core) &> /dev/null
mkdir -p "${AGENT_USER_HOME}_${PLATFORM}"

multiline='first line
           second line
           third line'

cat $1 << EOF
 Sameue text living in $HOME $TEST
EOF

# Zsh
echo $MY_PATH:l:A
echo ${(e)MY_PATH:l:A}
echo ${(s:/:qq)HOME}
echo $~glob_spec
echo ${~glob_spec}

exit 0

appended binary data
more appended binary data
