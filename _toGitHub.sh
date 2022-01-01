#!/bin/bash
## unpack all these spacefm plugins to $base to upload to github
base=/media/ramdisk
for z in *.spacefm-plugin.tar.gz *.spacefm-file-handler.tar.gz
do
targetdir="$base"/spacefm-plugins/"${z/.tar.gz}"
mkdir -p "$targetdir"
tar -xf "$z" -C "$targetdir"
done
pushd "$basis"/spacefm-plugins
echo "# The whole collection">"$base"/collection.md
for d in *.spacefm-plugin *.spacefm-file-handler
do
md="${d/.spacefm-*}.md"
echo -e "# $d" > "$md"
sed -nE 's/^(cstm|hand_f)_.*-label=(.*)/## \2\n /p;s/^(cstm|hand_f)_.*-line=/ /p' "$d"/plugin | sed -E 's/\\n/\n /g;s/\\t/\t/g' >> "$md"
cat "$md">>"$base"/collection.md
echo "">>"$base"/collection.md
done
popd
# remove export of all plugins older than this script (but collection.nd remains complete)
find -maxdepth 1 \( -name "*.spacefm-plugin.tar.gz" -o -name "*.spacefm-file-handler.tar.gz" \) \! -newer "_toGitHub.sh" -exec bash -v -c "cd $basis/spacefm-plugins;"'rm -R "${1/.spacefm-*}.md" "${1/.tar.gz }/"' _ \{\} \;
# mark NOW as new dividing line for changed plugins
touch "$0" 
