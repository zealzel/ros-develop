#!/usr/bin/env bash

idpt-append() {
  line="$1"
  file="$2"
  if ! grep -Fxq "$line" "$file"; then
    echo "$line" >> "$file"
  fi
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

# Testing the function with some content
contents=$(cat <<EOL
    ethernets:
        eth0:
            dhcp4: false
            addresses: [192.168.1.3/24]
            routes:
              - to: 192.168.1.2/32
                via: 192.168.1.3
        enx7cc2c64a19b7:
            dhcp4: false
            addresses: [192.168.1.12/24]
            routes:
              - to: 192.168.1.4/32
                via: 192.168.1.12
EOL
)

append_content "test.txt" "$contents"
