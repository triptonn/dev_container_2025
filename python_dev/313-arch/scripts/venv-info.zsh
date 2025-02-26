function virtualenv_info() {
  [ $VIRTUAL_ENV ] && echo "(` $VIRTUAL_ENV/bin/python --version | sed 's/Python //' `)"
}
autoload -Uz is-at-least
