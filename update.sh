#!/bin/bash
set -eo pipefail

declare -A base=(
	[alpine]='alpine'
)

variants=(
	alpine
)

min_version='0.2'
dockerLatest='master'


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
rm -rf ./images/*

echo "update docker images"
travisEnv=
for latest in "${latests[@]}"; do
	version=$(echo "$latest" | cut -d. -f1-2)
	if [ "$latest" = 'master' ]; then
		tag=latest
	else
		tag=$(echo "$latest" | cut -dv -f2)
	fi
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
			for name in .env entrypoint.sh config_template.py generate_salt.py init_admin.py init_setting.py assets.py; do
				cp "template/$name" "$dir/$name"
				chmod 755 "$dir/$name"
			done

			template="Dockerfile.${base[$variant]}.template"
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
				s/%%TAG%%/'"$tag"'/g;
			' "$dir/Dockerfile"

			sed -ri -e '
				s|DOCKER_TAG=.*|DOCKER_TAG='"$version"'|g;
				s|DOCKER_REPO=.*|DOCKER_REPO='"$dockerRepo"'|g;
			' "$dir/hooks/run"

			# Create a list of "alias" tags for DockerHub post_push
			if [ "$latest" = "$dockerLatest" ]; then
				if [ "$variant" = 'alpine' ]; then
					echo "$latest-$variant $version-$variant $variant $latest $version latest " > "$dir/.dockertags"
				else
					echo "$latest-$variant $version-$variant $variant " > "$dir/.dockertags"
				fi
			else
				if [ "$variant" = 'alpine' ]; then
					echo "$latest-$variant $version-$variant $latest $version " > "$dir/.dockertags"
				else
					echo "$latest-$variant $version-$variant " > "$dir/.dockertags"
				fi
			fi

			# Add Travis-CI env var
			travisEnv='\n    - VERSION='"$version"' VARIANT='"$variant"' DATABASE=mysql DC_SUFFIX=.test'"$travisEnv"
			travisEnv='\n    - VERSION='"$version"' VARIANT='"$variant"' DATABASE=postgres DC_SUFFIX=.test'"$travisEnv"
			travisEnv='\n    - VERSION='"$version"' VARIANT='"$variant"' DATABASE=sqlite DC_SUFFIX='"$travisEnv"

			if [[ $1 == 'build' ]]; then
				tag="$version"
				echo "Build Dockerfile for ${tag}"
				docker build -t "${dockerRepo}:${tag}" "$dir"
			fi
		done

	fi

done

# update .travis.yml
travis="$(awk -v 'RS=\n\n' '$1 == "env:" && $2 == "#" && $3 == "Environments" { $0 = "env: # Environments'"$travisEnv"'" } { printf "%s%s", $0, RS }' .travis.yml)"
echo "$travis" > .travis.yml
