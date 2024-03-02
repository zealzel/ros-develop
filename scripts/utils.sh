idpt-append-sudo() {
  line="$1"
  file="$2"
  if ! grep -Fxq "$line" "$file"; then
    echo "$line" | sudo tee -a "$file"
  fi
}

idpt-append() {
  line="$1"
  file="$2"
  if ! grep -Fxq "$line" "$file"; then
    echo "$line" >> "$file"
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

append_content_lines() { # works for multi-line content
  file="$1"
  multi_line_content="$2"
  echo "file: $file"
  # Here, we use 'echo' and 'while' to read each line from the string.
  echo "$multi_line_content" | while IFS= read -r line
  do
    echo "Appending line: \"$line\""
    idpt-append "$line" "$file"  # appending content line-by-line
  done
}

# Now, we modify the 'append_content' to append instead of overwrite
append_content() {
  file="$1"
  new_content="$2"
  echo "file: $file"
  # Directly append new content to the file without overwriting
  append_content_lines "$file" "$new_content"
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

disable_needrestart() {
  if [[ $(dpkg -l | grep needrestart) ]]; then
    echo "needrestart is installed"
    sudo sed -i 's/#$nrconf{restart} = '"'"'i'"'"';/$nrconf{restart} = '"'"'a'"'"';/g' /etc/needrestart/needrestart.conf
  fi
}
