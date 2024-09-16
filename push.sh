#Created with ChatGPT 

# Check if an argument is passed, and validate it
if [ -z "$1" ]; then
    pType='patch'
else
    pType =$1
fi

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

   # Increment the correct version part based on the argument
  case "$pType" in
    major)
      major=$((major + 1))
      minor=0  # Reset minor and patch when incrementing major
      patch=0
      ;;
    minor)
      minor=$((minor + 1))
      patch=0  # Reset patch when incrementing minor
      ;;
    patch)
      patch=$((patch + 1))
      ;;
    *)
      echo "Error: Invalid argument. Use 'major', 'minor', or 'patch'."
      exit 1
      ;;
  esac

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
