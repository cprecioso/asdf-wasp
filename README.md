<div align="center">

# asdf-wasp [![Build](https://github.com/cprecioso/asdf-wasp/actions/workflows/build.yml/badge.svg)](https://github.com/cprecioso/asdf-wasp/actions/workflows/build.yml) [![Lint](https://github.com/cprecioso/asdf-wasp/actions/workflows/lint.yml/badge.svg)](https://github.com/cprecioso/asdf-wasp/actions/workflows/lint.yml)

[wasp](https://wasp.sh/docs) plugin for the [asdf version manager](https://asdf-vm.com).

</div>

# Contents

- [Dependencies](#dependencies)
- [Install](#install)
- [Contributing](#contributing)
- [License](#license)

# Dependencies

**TODO: adapt this section**

- `bash`, `curl`, `tar`, and [POSIX utilities](https://pubs.opengroup.org/onlinepubs/9699919799/idx/utilities.html).
- `SOME_ENV_VAR`: set this environment variable in your shell config to load the correct version of tool x.

# Install

Plugin:

```shell
asdf plugin add wasp
# or
asdf plugin add wasp https://github.com/cprecioso/asdf-wasp.git
```

wasp:

```shell
# Show all installable versions
asdf list-all wasp

# Install specific version
asdf install wasp latest

# Set a version globally (on your ~/.tool-versions file)
asdf global wasp latest

# Now wasp commands are available
wasp version
```

Check [asdf](https://github.com/asdf-vm/asdf) readme for more instructions on how to
install & manage versions.

# Contributing

Contributions of any kind welcome! See the [contributing guide](contributing.md).

[Thanks goes to these contributors](https://github.com/cprecioso/asdf-wasp/graphs/contributors)!

# License

See [LICENSE](LICENSE) © [Carlos Precioso](https://github.com/cprecioso/)
