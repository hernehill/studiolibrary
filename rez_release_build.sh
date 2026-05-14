#! /usr/bin/env bash

function get_package_name {
    python3 -c "
import re
with open('package.py', 'r') as f:
    content = f.read()
m = re.search(r\"name\s*=\s*['\\\"]([^'\\\"]+)['\\\"]\", content)
if m:
    print(m.group(1))
"
}

function get_package_version {
    python3 -c "
import re
with open('package.py', 'r') as f:
    content = f.read()
m = re.search(r\"version\s*=\s*['\\\"]([^'\\\"]+)['\\\"]\", content)
if m:
    print(m.group(1))
"
}

function bump_version {
    python3 - "$1" "$2" <<'EOF'
import sys
version, bump_type = sys.argv[1], sys.argv[2]
major, minor, patch = map(int, version.split('.'))
if bump_type == 'major':
    major += 1; minor = 0; patch = 0
elif bump_type == 'minor':
    minor += 1; patch = 0
else:
    patch += 1
print(f'{major}.{minor}.{patch}')
EOF
}

function update_package_version {
    python3 - "$1" <<'EOF'
import re, sys
new_version = sys.argv[1]
with open('package.py', 'r') as f:
    content = f.read()
new_content = re.sub(r"(version\s*=\s*['\"])([^'\"]+)(['\"])", r'\g<1>' + new_version + r'\3', content)
with open('package.py', 'w') as f:
    f.write(new_content)
EOF
}

function check_version_tag {
    local pkg_name version tag
    pkg_name=$(get_package_name)
    version=$(get_package_version)
    tag="${pkg_name}-${version}"

    if git tag --list | grep -qx "${tag}"; then
        echo
        echo "Version ${version} already has tag '${tag}'."
        echo "Select a version bump type:"
        echo "  1) major -> $(bump_version "$version" major)"
        echo "  2) minor -> $(bump_version "$version" minor)"
        echo "  3) patch -> $(bump_version "$version" patch)"
        echo "  c) cancel"
        echo
        local choice bump_type new_version
        read -rp "Enter choice [1/2/3/c]: " choice
        case $choice in
            1) bump_type="major" ;;
            2) bump_type="minor" ;;
            3) bump_type="patch" ;;
            c|C) echo "Cancelled."; exit 0 ;;
            *) echo "Invalid choice. Exiting."; exit 1 ;;
        esac
        new_version=$(bump_version "$version" "$bump_type")
        update_package_version "$new_version"
        echo "Updated package.py: ${version} -> ${new_version}"
        echo
    fi
}

function run_process {

    echo "-------------------------------------"
    echo "Processing..."
    echo

    check_version_tag

    git add --all
    git commit -m "${LOCAL_VARS[0]}"
    git push

    rez-release --no-latest --message "${LOCAL_VARS[0]}"
    rez-build -i --symlink

}

# Collect all input arguments into a local array of variables
LOCAL_VARS=("$@")

if [ ! "${#LOCAL_VARS[@]}" -eq 1 ]; then
    echo "Missing commit comment"
    exit 1
fi


run_process


# How to use:
# ./rez_release_build.sh "My commit message"
