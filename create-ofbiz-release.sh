#!/bin/bash
# Builds, signs and checksums the Apache OFBiz source release archive.
#
# The sources are downloaded from the release tags on GitHub, so the
# "release<version>" tag must already be pushed to both the ofbiz-framework
# and ofbiz-plugins repositories before running this script.
#
# Usage, from the directory where the release files should be created:
#   bash /path/to/create-ofbiz-release.sh 24.09.01
#
# Output files:
#   apache-ofbiz-<version>/            unpacked release tree
#   apache-ofbiz-<version>.zip         release archive
#   apache-ofbiz-<version>.zip.asc     detached GPG signature
#   apache-ofbiz-<version>.zip.sha512  SHA-512 checksum

# Colors for terminal output
RED='\033[0;31m'
GRN='\033[0;32m'
NC='\033[0m' # No Color

# Abort on the first failing command, unset variable or failed pipeline stage
set -euo pipefail

if [[ $# -eq 0 ]] ; then
    echo -e "Usage: $0 ${RED}<version>${NC}  (e.g. $0 24.09.01)"
    exit 1
fi

# Make sure all the required tools are available before changing anything
missing=()
for tool in curl tar awk perl zip gpg; do
    command -v "$tool" >/dev/null 2>&1 || missing+=("$tool")
done
if [[ ${#missing[@]} -gt 0 ]]; then
    echo -e "${RED}Missing required tools: ${missing[*]}${NC}"
    exit 1
fi

# Make sure a GPG secret key is available to sign the archive
if [[ -z "$(gpg --list-secret-keys 2>/dev/null)" ]]; then
    echo -e "${RED}No GPG secret key found to sign the release archive${NC}"
    exit 1
fi

# Refuse to overwrite or mix with the output of a previous run
for path in apache-ofbiz-$1 apache-ofbiz-$1.zip apache-ofbiz-$1.zip.asc apache-ofbiz-$1.zip.sha512; do
    if [[ -e "$path" ]]; then
        echo -e "${RED}$path already exists: remove it or run the script from another directory${NC}"
        exit 1
    fi
done

# Make sure the release tag exists in both repositories before creating anything
for repo in ofbiz-framework ofbiz-plugins; do
    if ! curl -fsIL -o /dev/null https://github.com/apache/$repo/archive/refs/tags/release$1.tar.gz; then
        echo -e "${RED}Tag release$1 not found in the apache/$repo repository on GitHub${NC}"
        exit 1
    fi
done

# Download the tagged framework sources and unpack the tagged plugins under plugins/
echo -e "## Downloading sources for tag ${GRN}release$1${NC} from GitHub"
mkdir -p apache-ofbiz-$1/
mkdir -p apache-ofbiz-$1/plugins/
curl -fsSL https://github.com/apache/ofbiz-framework/archive/refs/tags/release$1.tar.gz | tar -xz -C apache-ofbiz-$1/ --strip-components=1
curl -fsSL https://github.com/apache/ofbiz-plugins/archive/refs/tags/release$1.tar.gz | tar -xz -C apache-ofbiz-$1/plugins/ --strip-components=1

# Append the plugin-specific part of the plugins LICENSE (everything after the
# first separator line) to the framework LICENSE, before the former is removed
echo "## Merging the plugins LICENSE into the framework LICENSE"
awk 'found; !found && index($0, "=========================================================================") {found=1}' \
    apache-ofbiz-$1/plugins/LICENSE >> apache-ofbiz-$1/LICENSE

# Remove files that do not belong in the source release: plugin repository
# metadata superseded by the framework's files, IDE/tooling configuration,
# version control settings and GitHub/ASF infrastructure configuration.
# -f because not every release branch contains all of these files.
echo "## Removing files not included in the source release"
rm -f apache-ofbiz-$1/plugins/LICENSE \
      apache-ofbiz-$1/plugins/VERSION \
      apache-ofbiz-$1/plugins/.project \
      apache-ofbiz-$1/plugins/.asf.yaml \
      apache-ofbiz-$1/.asf.yaml \
      apache-ofbiz-$1/.gitattributes \
      apache-ofbiz-$1/.hgignore \
      apache-ofbiz-$1/.pre-commit-config.yaml
rm -rf apache-ofbiz-$1/.github \
       apache-ofbiz-$1/.devcontainer \
       apache-ofbiz-$1/plugins/.github

# Switch the README status badge from orange (development) to green (stable release)
echo "## Marking the release as stable in README.adoc"
perl -pi -e 's/orange\.svg/green\.svg/g' apache-ofbiz-$1/README.adoc

# Write the release version to the VERSION file
echo "## Setting VERSION to $1"
echo "$1" > apache-ofbiz-$1/VERSION

# Create the release archive (-T tests its integrity once written)
echo -e "## Creating archive ${GRN}apache-ofbiz-$1.zip${NC}"
zip -q apache-ofbiz-$1.zip -r -T apache-ofbiz-$1/

# Sign the archive with the release manager's GPG key and compute its SHA-512 checksum
echo "## Signing the archive and computing its SHA-512 checksum"
gpg --armor --detach-sig --output apache-ofbiz-$1.zip.asc apache-ofbiz-$1.zip
gpg --print-md SHA512 apache-ofbiz-$1.zip > apache-ofbiz-$1.zip.sha512

echo -e "## ${GRN}Done.${NC}"
echo -e "## Created:"
echo -e "##   ${GRN}apache-ofbiz-$1.zip${NC}"
echo -e "##   ${GRN}apache-ofbiz-$1.zip.asc${NC}"
echo -e "##   ${GRN}apache-ofbiz-$1.zip.sha512${NC}"
echo -e "## ${RED}Check the archive contents, signature and checksum before publishing the release.${NC}"
