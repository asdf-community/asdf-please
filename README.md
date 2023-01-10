<div align="center">

# asdf-please [![Build](https://github.com/jtzero/asdf-please/actions/workflows/build.yml/badge.svg)](https://github.com/jtzero/asdf-please/actions/workflows/build.yml) [![Lint](https://github.com/jtzero/asdf-please/actions/workflows/lint.yml/badge.svg)](https://github.com/jtzero/asdf-please/actions/workflows/lint.yml)


[please](https://github.com/thought-machine/please) plugin for the [asdf version manager](https://asdf-vm.com).

</div>

# Contents

- [Dependencies](#dependencies)
- [Install](#install)
- [Contributing](#contributing)
- [License](#license)

# Install

Plugin:

```shell
asdf plugin add please https://github.com/jtzero/asdf-please.git
```

please:

```shell
# Show all installable versions
asdf list-all please

# Install specific version
asdf install please latest

# Set a version globally (on your ~/.tool-versions file)
asdf global please latest

# Now please commands are available
please --version
```

Check [asdf](https://github.com/asdf-vm/asdf) readme for more instructions on how to
install & manage versions.

# Contributing

Contributions of any kind welcome! See the [contributing guide](contributing.md).

[Thanks goes to these contributors](https://github.com/jtzero/asdf-please/graphs/contributors)!

# License

See [LICENSE](LICENSE) © [jtzero ?](https://github.com/jtzero/)
