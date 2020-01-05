#!/bin/bash
set -eo pipefail

declare -A base=(
	[alpine]='alpine'
)

variants=(
	alpine
)

min_version=''


# version_greater_or_equal A B returns whether A >= B
function version_greater_or_equal() {
	[[ "$(printf '%s\n' "$@" | sort -V | head -n 1)" != "$1" || "$1" == "$2" ]];
}

dockerRepo="monogramm/docker-powerdns-admin"
latests=( $( curl -fsSL 'https://api.github.com/repos/ngoduykhanh/powerdns-admin/tags' |tac|tac| \
	grep -oE 'v[[:digit:]]+(\.[[:digit:]]+)+' | \
	sort -urV )
	master
)

# Remove existing images
echo "reset docker images"
find ./images -maxdepth 1 -type d -regextype sed -regex '\./images/.*' -exec rm -r '{}' \;

echo "update docker images"
travisEnv=
for latest in "${latests[@]}"; do
	version=$(echo "$latest" | cut -d. -f1-2)
	echo "Checking $latest [$version]..."

	# Only add versions >= "$min_version"
	if version_greater_or_equal "$version" "$min_version"; then

        for variant in "${variants[@]}"; do
			# Create the version directory with a Dockerfile.
			dir="images/$version"
			if [ -d "$dir" ]; then
				continue
			fi
			echo "generating $latest [$version]"
			mkdir -p "$dir"

			# Copy the scripts/config files
			for name in .env entrypoint.sh docker_config.py generate_salt.py init_admin.py init_setting.py assets.py; do
				cp "template/$name" "$dir/$name"
				chmod 755 "$dir/$name"
			done

			template="Dockerfile-${base[$variant]}.template"
			cp "template/$template" "$dir/Dockerfile"
			cp "template/.dockerignore" "$dir/.dockerignore"
			cp -r "template/hooks" "$dir/"
			cp -r "template/test" "$dir/"
			cp "template/docker-compose.mysql.test.yml" "$dir/docker-compose.mysql.test.yml"
			cp "template/docker-compose.postgres.test.yml" "$dir/docker-compose.postgres.test.yml"
			cp "template/docker-compose.sqlite.test.yml" "$dir/docker-compose.sqlite.test.yml"

			# Replace the variables.
			sed -ri -e '
				s/%%VERSION%%/'"$latest"'/g;
			' "$dir/Dockerfile"

			# Add Travis-CI env var
            travisEnv='\n    - VERSION='"$version"' VARIANT='"$variant"' DATABASE=mysql'"$travisEnv"
            travisEnv='\n    - VERSION='"$version"' VARIANT='"$variant"' DATABASE=postgres'"$travisEnv"
            travisEnv='\n    - VERSION='"$version"' VARIANT='"$variant"' DATABASE=sqlite'"$travisEnv"

			if [[ $1 == 'build' ]]; then
				tag="$version"
				echo "Build Dockerfile for ${tag}"
				docker build -t ${dockerRepo}:${tag} $dir
			fi
        done

	fi

done

# update .travis.yml
travis="$(awk -v 'RS=\n\n' '$1 == "env:" && $2 == "#" && $3 == "Environments" { $0 = "env: # Environments'"$travisEnv"'" } { printf "%s%s", $0, RS }' .travis.yml)"
echo "$travis" > .travis.yml
