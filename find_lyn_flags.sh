find_lyn_flags () {
	local dir="${1:-.}" # Use current directory if no argument provided 
	cd "$dir" && find . -iname '*jpg' -print0 | sort -z | xargs -0 -I {} sh -c 'if xattr -p com.apple.metadata:kMDItemLynFlagTag "{}" >/dev/null 2>&1; then echo "{}"; fi' | sed 's:^\./::'
}
