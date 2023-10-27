#!/usr/bin/env bash
set -x

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
FOP_XML_FILE="/ofbiz/framework/webapp/config/fop.xconf"
TMPFILE=$(mktemp)

xsltproc --output "$TMPFILE" "$SCRIPT_DIR/fop-xconf-update.xslt" "$FOP_XML_FILE"
mv "$TMPFILE" "$FOP_XML_FILE"
