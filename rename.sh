#!/bin/zsh # Rename malone_tunings to malone_tunings_builders # rails g migration rename_malone_tunings_table_to_malone_tunings_builders

# Find occurences of term in files recursively.
# http://superuser.com/questions/441339/grep-all-files-in-a-directory-and-print-matches-with-filename
# s to suppress errors, r for recursive, H to display the filename and E (and
# the pipe) to match any of both patterns.

# grep -srHE 'malone_tuning' app/**/*.rb

# Load zsh zmv.
autoload -U zmv

# Rename matching files and folders in the app, test, and spec directories.
# for i in *.yourfiles; do mv "$i" "`echo $i | sed 's/old/new/g'`"; done - See
file_name_changer () {
  folders=(app test spec config)
  for folder in $folders; do
    if [ -n "$(find -E $folder -regex ".*$before.*" | head -n 1)" ]; then
      zmv $folder'/(**/)(*)'$before'(*)' $folder'/$1/$2'$after'$3$4'
    fi
  done
}

# Rename matching file content in the app, test, and spec directories.
file_content_changer () {
  folders=(app test spec lib config)
  for folder in $folders; do
    files=("${(@f)$(find $folder -not -path "*/images/*" -not -path "*/.*" -type f)}")
    for file in $files; do
      sed -E -i '' "s/$before/$after/g" $file
    done
  done
}

before="([^_])item_id([^s_])"
after="\1product_id\2"

file_content_changer

# before="malone_tuning($|[^s])"
# after="malone_tuning_builder"
# 
# file_name_changer
# 
# after="malone_tuning_builder\1"
# 
# file_content_changer
# 
# before=malone_tunings
# after=malone_tuning_builders
# 
# file_name_changer
# 
# file_content_changer
# 
# before=MaloneTuning
# after=MaloneTuningBuilder
# 
# file_content_changer
# 
# before="malone_tune($|[^s])"
# after="malone_tuning"
# 
# file_name_changer
# 
# after="malone_tuning\1"
# 
# file_content_changer
# 
# before=malone_tunes
# after=malone_tunings
# 
# file_name_changer
# 
# file_content_changer
# 
# before=MaloneTune
# after=MaloneTuning
# 
# file_content_changer

## Before running this script make sure to clean working directory and run tests.
## In order to undo any changes performed by this script;
#
## git checkout -- .
## git clean -fd
