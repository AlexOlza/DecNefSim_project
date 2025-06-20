#!/bin/bash
set -e

PACKAGE="$1"

if [ -z "$PACKAGE" ]; then
  echo "❌ No package name given."
  echo "Usage: ./try_package.sh <package_name>"
  exit 1
fi

echo "🔍 Installing and testing package: $PACKAGE"
pip install "$PACKAGE"

echo
echo "✅ Package '$PACKAGE' installed."
echo "🧪 Test it now in Python or notebooks."

while true; do
  echo
  read -p "Do you want to KEEP '$PACKAGE'? [y/n]: " answer
  case $answer in
    [Yy]* )
      # Extract the installed version (case-insensitive)
      VERSIONED_LINE=$(pip freeze | grep -i "^${PACKAGE}==")

      if [ -z "$VERSIONED_LINE" ]; then
        echo "⚠️ Could not determine exact version of '$PACKAGE'. Logging plain name."
        echo "$PACKAGE" >> manual_adds.txt
      else
        echo "$VERSIONED_LINE" >> manual_adds.txt
        echo "✅ Logged: $VERSIONED_LINE"
      fi

      echo "(Logged in manual_adds.txt — remember to freeze full environment when stable.)"
      break;;
    [Nn]* )
      echo "🗑️  Uninstalling '$PACKAGE'..."
      pip uninstall -y "$PACKAGE"
      echo "❌ Discarded '$PACKAGE'."
      break;;
    * ) echo "Please answer yes [y] or no [n].";;
  esac
done

