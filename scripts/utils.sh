idpt-append() {
  line="$1"
  file="$2"
  if ! grep -Fxq "$line" "$file"; then
    echo "$line" >> "$file"
  fi
}

idpt-append-sudo() {
  line="$1"
  file="$2"
  if ! grep -Fxq "$line" "$file"; then
    echo "$line" | sudo tee -a "$file"
  fi
}

append_bashrc() {
  file="$HOME/.bashrc"
  lines=("$@")
  echo "file: $file"
  for line in "${lines[@]}"; do
    echo "line: \"$line\" added"
    idpt-append "$line" "$file"
  done
}

# write a function which tell if a ubuntu package is installed
is_ubuntu_package_installed() {
  if dpkg -s "$1" > /dev/null 2>&1; then
    echo "Package $1 is installed"
    return 0
  else
    echo "Package $1 is not installed"
    return 1
  fi
}

is_ubuntu_packages_installed() {
  packages=("$@")
  for pkg in "${packages[@]}"; do
    if ! is_ubuntu_package_installed "$pkg"; then
      return 1
    fi
  done
}

install_ubuntu_packages() {
  packages=("$@")
  for pkg in "${packages[@]}"; do
    if ! is_ubuntu_package_installed "$pkg"; then
      sudo apt-get install -y "$pkg"
    fi
  done
}

ensure_sudo() {
  if [[ $(dpkg -L sudo) ]]; then
    echo "sudo is installed"
  else
    echo "sudo is not installed, try install it"
    apt-get update
    apt-get install -y sudo || exit_code=$?
    if [[ $exit_code -ne 0 ]]; then
      echo "install sudo failed."
    else
      echo "install sudo done."
    fi
  fi
}
