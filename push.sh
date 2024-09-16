#!/bin/bash

# Fetch the latest tags from the remote
git fetch --tags

# Get the latest tag in the format vx.y.z
latest_tag=$(git describe --tags `git rev-list --tags --max-count=1`)

if [ -z "$latest_tag" ]; then
  # If no tags exist, start from v0.0.1
  new_tag="v0.0.1"
else
  # Extract the major, minor, and patch numbers from the latest tag
  IFS='.' read -r -a version_parts <<< "${latest_tag//v/}"
  major="${version_parts[0]}"
  minor="${version_parts[1]}"
  patch="${version_parts[2]}"

  # Increment the patch version by 1
  patch=$((patch + 1))

  # Create the new tag
  new_tag="v$major.$minor.$patch"
fi

# Create the new tag
git tag "$new_tag"

# Push the tag to the remote repository (only the new tag)
git push origin "$new_tag"

# Push the current commit to the remote branch (usually main or master)
git push origin $(git rev-parse --abbrev-ref HEAD)

echo "Created and pushed new tag: $new_tag"
