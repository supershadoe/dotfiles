# dotfiles
A snapshot of my current config (runs on WSL2 with Arch distro)

## Folders
Each folder is set relative to system root /.

## Files
`packages` file is a list of packages currently installed on the image
generated using

```bash
paru -Qe | cut -d\  -f1 > packages
```

## Usage
Do not forget to clone the submodules as well using

```bash
git clone --recurse-submodules https://github.com/supershadoe/dotfiles
```

