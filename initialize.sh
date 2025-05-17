#!/bin/sh

set -e

TEMPLATE="static"
PROJECT_NAME="web-ui-template"

# Parse arguments
while [ $# -gt 0 ]; do
    case "$1" in
        --template | -t)
            shift
            if [ "$1" = "static" ] || [ "$1" = "server" ]; then
                TEMPLATE="$1"
            else
                echo "Invalid template: $1"
                echo "Usage: $0 [--template static|server] [project-name]"
                exit 1
            fi
            ;;
        -*)
            echo "Unknown option: $1"
            echo "Usage: $0 [--template static|server] [project-name]"
                1
            ;;
        *)
            PROJECT_NAME="$1"
            ;;
    esac
    shift
done

if [ "$TEMPLATE" = "server" ]; then
    echo "Server template is coming soon"
    exit 0
fi

TEMPLATE_URL="https://github.com/maclong9/web-ui/archive/refs/heads/main.tar.gz"
TMP_DIR=$(mktemp -d)
curl -fsSL "$TEMPLATE_URL" | tar -xz -C "$TMP_DIR"

TEMPLATE_PATH="$TMP_DIR/web-ui-main/examples/$TEMPLATE"
if [ ! -d "$TEMPLATE_PATH" ]; then
    echo "Template directory not found: $TEMPLATE_PATH"
    exit 1
fi

cp -R "$TEMPLATE_PATH" "$PROJECT_NAME"

# macOS/BSD sed needs '' after -i, GNU sed does not
if [ "$(uname -s)" = "Darwin" ]; then
    SED_INPLACE="sed -i ''"
else
    SED_INPLACE="sed -i"
fi

find "$PROJECT_NAME" -type f -name "Package.swift" -exec $SED_INPLACE "s/example/$PROJECT_NAME/g" {} +
find "$PROJECT_NAME/Sources" -type f -name "Application.swift" -exec $SED_INPLACE "s/example/$PROJECT_NAME/g" {} +
rm -rf "$PROJECT_NAME/.git"
rm -rf "$TMP_DIR"

printf '\033[1;32m✓ %s initialisation complete

Run \033[1;33mcd %s && swift run\033[0m to build
your static site to the \033[1;36m.output\033[0m directory.\n\n' "$PROJECT_NAME" "$PROJECT_NAME"
