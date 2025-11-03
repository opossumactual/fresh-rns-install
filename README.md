# Reticulum & Nomadnet Installer

A comprehensive installation script for [Reticulum Network Stack](https://reticulum.network/) and [Nomadnet](https://github.com/markqvist/NomadNet) on Linux systems.

## What is This?

This script automates the installation of:

- **Reticulum Network Stack** - A cryptography-based networking stack for building mesh networks
- **LXMF** - Lightweight Extensible Message Format for offline messaging
- **Nomadnet** - A private, resilient communication platform built on Reticulum

## Features

✅ Automatic OS detection (Ubuntu, Debian, Fedora, Arch, etc.)
✅ Installs all system dependencies
✅ Installs Python packages with proper versions
✅ Creates initial configuration
✅ Verifies installation
✅ Supports both `rns` and `rnspure` packages
✅ Colorful terminal output with progress indicators

## Requirements

- Linux-based operating system
- Python 3.7 or higher
- Internet connection for downloading packages
- sudo privileges for system package installation

## Quick Install

```bash
# Download the script
wget https://raw.githubusercontent.com/opossumactual/fresh-rns-install/main/install_reticulum_nomadnet.sh

# Make it executable
chmod +x install_reticulum_nomadnet.sh

# Run the installer
./install_reticulum_nomadnet.sh
```

Or clone the repository:

```bash
git clone https://github.com/opossumactual/fresh-rns-install.git
cd fresh-rns-install
./install_reticulum_nomadnet.sh
```

**One-liner (downloads and runs):**

```bash
curl -sSL https://raw.githubusercontent.com/opossumactual/fresh-rns-install/main/install_reticulum_nomadnet.sh | bash
```

## What Gets Installed

### System Dependencies

- Python 3 and pip
- Python development headers
- OpenSSL development libraries
- Build tools (gcc, make, etc.)
- Git

### Python Packages

- **Reticulum (rns)** - Networking stack
- **LXMF (>=0.6.1)** - Messaging protocol
- **Nomadnet** - Communication client
- **urwid (>=2.6.16)** - Terminal UI library
- **qrcode** - QR code generation
- **pyserial** - Serial port support

### Optional Packages

- **feedparser** - For RSS feed support
- **requests** - For HTTP functionality

## Usage

After installation:

```bash
# Reload your shell
source ~/.bashrc

# Start Nomadnet
nomadnet

# Check Reticulum status
rnstatus

# View detailed interface information
rnstatus -v
```

## Configuration

Configuration files are located at:

- **Reticulum**: `~/.reticulum/config`
- **Nomadnet**: `~/.nomadnetwork/config`

Edit configurations:

```bash
# Edit Reticulum config
nano ~/.reticulum/config

# Edit Nomadnet config
nano ~/.nomadnetwork/config
```

## Supported Operating Systems

- Ubuntu / Linux Mint / Pop!_OS
- Debian
- Fedora / RHEL / CentOS
- Arch Linux / Manjaro
- Other Linux distributions (with manual dependency confirmation)

## Architecture Notes

- **Standard systems**: Works out of the box
- **ARM/RISC-V**: May require `python3-dev` installed first
- **32-bit Raspberry Pi**: May need manual build dependency configuration

## Documentation

- [Reticulum Manual](https://reticulum.network/manual/)
- [Reticulum GitHub](https://github.com/markqvist/Reticulum)
- [Nomadnet GitHub](https://github.com/markqvist/NomadNet)
- [Getting Started Fast](https://markqvist.github.io/Reticulum/manual/gettingstartedfast.html)

## Connecting to the Testnet

To connect to the Reticulum testnet, add this to `~/.reticulum/config`:

```ini
[[RNS Testnet Dublin]]
  type = TCPClientInterface
  enabled = yes
  target_host = dublin.connect.reticulum.network
  target_port = 4965
```

## Troubleshooting

### Command not found after installation

Reload your shell configuration:

```bash
source ~/.bashrc
# or
export PATH="$HOME/.local/bin:$PATH"
```

### Python import errors

Ensure pip packages are installed:

```bash
pip3 install --user nomadnet
```

### Permission denied

Make sure the script is executable:

```bash
chmod +x install_reticulum_nomadnet.sh
```

## Uninstallation

To remove installed packages:

```bash
# Remove Python packages
pip3 uninstall rns lxmf nomadnet urwid qrcode pyserial

# Remove configuration (optional)
rm -rf ~/.reticulum
rm -rf ~/.nomadnetwork
```

## Contributing

Contributions are welcome! Please feel free to submit issues or pull requests.

## License

This installer script is released under the MIT License.

## Credits

- **Reticulum Network Stack** by Mark Qvist
- **Nomadnet** by Mark Qvist
- **LXMF** by Mark Qvist

## Support

For issues with:
- **This installer**: Open an issue on this repository
- **Reticulum/Nomadnet**: Visit the official repositories
  - https://github.com/markqvist/Reticulum
  - https://github.com/markqvist/NomadNet

## What's Next?

After installation, you can:

1. **Start exploring** - Launch `nomadnet` and browse the network
2. **Host a node** - Enable node hosting in Nomadnet config
3. **Add interfaces** - Configure LoRa, packet radio, or other interfaces
4. **Join the testnet** - Connect to the public Reticulum testnet
5. **Build applications** - Create your own Reticulum-based apps

Enjoy your decentralized mesh network!
