#!/bin/zsh

# Rename malone_tunings to malone_tunings_builders
# rails g migration rename_malone_tunings_table_to_malone_tunings_builders

# Load zsh zmv.
Upload -U zmv

# Rename matching files and folders in the app, test, and spec directories.
folders=(app test spec)

file_name_changer () {
  for folder in $folders; do
    if find $folder/**/*$before*; then
      zmv $folder'/(**/)(*)'$before'(*)' $folder'/$1/$2'$after'$3'
    fi
  done
}

# Rename matching file content in the app, test, and spec directories.
file_content_changer () {
  for folder in $folders; do
    files=("${(@f)$(find $folder -not -path "*/images/*" -not -path "*/.*" -type f)}")
    for file in $files; do
      sed -E -i '' "s/$before/$after/g" $file
    done
  done
}

before="malone_tuning($|[^s])"
after="malone_tuning_builder"

file_name_changer

after="malone_tuning_builder\1"

file_content_changer

before=malone_tunings
after=malone_tuning_builders

file_name_changer

file_content_changer

before=MaloneTuning
after=MaloneTuningBuilder

file_content_changer

before="malone_tune($|[^s])"
after="malone_tuning"

file_name_changer

after="malone_tuning\1"

file_content_changer

before=malone_tunes
after=malone_tunings

file_name_changer

file_content_changer

before=MaloneTune
after=MaloneTuning

file_content_changer

## Before running this script make sure to clean working directory and run tests.
## In order to undo any changes performed by this script;
#
## git checkout -- .
## git clean -fd
