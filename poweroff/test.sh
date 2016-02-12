user=$(who | grep '(:[0-9])')
readarray -t y <<<"$user"

