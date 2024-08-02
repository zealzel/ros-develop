#!/usr/bin/env bash
script_dir="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"
#
source "$script_dir/../scripts/utils.sh"
source "$script_dir/../scripts/argparse.sh"

declare -A arg_desc=(
  ["-w,--WORKSPACE"]="Workspace name (default: colcon_ws)"
  ["-v,--VCS_REPOS"]="vcs repos"
)

declare -A parsed_args
parse_args "$@"

WORKSPACE=${parsed_args["WORKSPACE"]-ros2_ws}
VCS_REPOS=${parsed_args["VCS_REPOS"]}
VCS_REPOS=$(readlink -f "$VCS_REPOS")

echo ====== install_from_source ======
echo "WORKSPACE: $WORKSPACE"
echo "VCS_REPOS: $VCS_REPOS"

WORKSPACEPATH="$HOME/$WORKSPACE"
cd "$WORKSPACEPATH" || exit
# alway using --force flag
echo "vcs import --force src < $VCS_REPOS"
vcs import --force src <"$VCS_REPOS"

# install apriltag
cd "$WORKSPACEPATH/src/apriltag" || exit
cmake -B build -DCMAKE_BUILD_TYPE=Release
cmake --build build --target install

# build the rest repos
cd "$WORKSPACEPATH" || exit
colcon build
