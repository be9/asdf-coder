<div align="center">

# asdf-coder [![Build](https://github.com/be9/asdf-coder/actions/workflows/build.yml/badge.svg)](https://github.com/be9/asdf-coder/actions/workflows/build.yml) [![Lint](https://github.com/be9/asdf-coder/actions/workflows/lint.yml/badge.svg)](https://github.com/be9/asdf-coder/actions/workflows/lint.yml)

[coder](https://coder.com/docs/cli) plugin for the [asdf version manager](https://asdf-vm.com).

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
asdf plugin add coder
# or
asdf plugin add coder https://github.com/be9/asdf-coder.git
```

coder:

```shell
# Show all installable versions
asdf list-all coder

# Install specific version
asdf install coder latest

# Set a version globally (on your ~/.tool-versions file)
asdf global coder latest

# Now coder commands are available
coder --version
```

Check [asdf](https://github.com/asdf-vm/asdf) readme for more instructions on how to
install & manage versions.

# Contributing

Contributions of any kind welcome! See the [contributing guide](contributing.md).

[Thanks goes to these contributors](https://github.com/be9/asdf-coder/graphs/contributors)!

# License

See [LICENSE](LICENSE) © [Oleg Dashevskii](https://github.com/be9/)
