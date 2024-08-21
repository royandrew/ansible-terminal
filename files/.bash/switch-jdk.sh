#!/bin/bash

# Script to detect and switch between JDK installations managed by Homebrew

# Determine the Homebrew installation path
brew_prefix=$(brew --prefix)

# Get the list of installed JDKs from Homebrew
jdks=$(ls -d "${brew_prefix}"/opt/openjdk* 2>/dev/null)

# Check if any JDKs are installed
if [ -z "$jdks" ]; then
  echo "No JDK installations found via Homebrew."
  exit 1
fi

echo "Available JDK installations:"

# Display available JDK versions
index=1
for jdk in $jdks; do
  version=$(basename "$jdk" | sed 's/openjdk@//')
  echo "[$index] JDK $version"
  index=$((index + 1))
done

# Prompt the user to select a JDK version
echo -n "Enter the number corresponding to the JDK you want to switch to: "
read selection

# Validate the input
if ! [[ "$selection" =~ ^[0-9]+$ ]] || [ "$selection" -lt 1 ] || [ "$selection" -ge $index ]; then
  echo "Invalid selection."
  exit 1
fi

# Set the selected JDK
selected_jdk=$(echo "$jdks" | sed -n "${selection}p")
export JAVA_HOME="$selected_jdk"
export PATH="$JAVA_HOME/bin:$PATH"

echo "Switched to $(basename "$selected_jdk")."
echo "JAVA_HOME is now set to $JAVA_HOME"
