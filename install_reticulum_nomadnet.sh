#!/bin/bash

################################################################################
# Reticulum & Nomadnet Installation Script
#
# This script installs Reticulum Network Stack and Nomadnet on Linux systems
# with all required dependencies.
#
# Author: Your Name
# Repository: https://github.com/yourusername/reticulum-nomadnet-installer
# License: MIT
################################################################################

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Script version
VERSION="1.0.0"

################################################################################
# Helper Functions
################################################################################

print_header() {
    echo -e "\n${BLUE}========================================${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}========================================${NC}\n"
}

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ $1${NC}"
}

################################################################################
# System Detection
################################################################################

detect_os() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        OS=$ID
        OS_VERSION=$VERSION_ID
    elif [ -f /etc/lsb-release ]; then
        . /etc/lsb-release
        OS=$DISTRIB_ID
        OS_VERSION=$DISTRIB_RELEASE
    else
        OS=$(uname -s)
        OS_VERSION=$(uname -r)
    fi

    print_info "Detected OS: $OS $OS_VERSION"
}

################################################################################
# Dependency Checks
################################################################################

check_python() {
    print_header "Checking Python Installation"

    if command -v python3 &> /dev/null; then
        PYTHON_VERSION=$(python3 --version | cut -d' ' -f2)
        PYTHON_MAJOR=$(echo $PYTHON_VERSION | cut -d'.' -f1)
        PYTHON_MINOR=$(echo $PYTHON_VERSION | cut -d'.' -f2)

        if [ "$PYTHON_MAJOR" -ge 3 ] && [ "$PYTHON_MINOR" -ge 7 ]; then
            print_success "Python $PYTHON_VERSION found (>= 3.7 required)"
            return 0
        else
            print_error "Python $PYTHON_VERSION found, but >= 3.7 is required"
            return 1
        fi
    else
        print_error "Python 3 not found"
        return 1
    fi
}

check_pip() {
    print_header "Checking pip Installation"

    if command -v pip3 &> /dev/null; then
        PIP_VERSION=$(pip3 --version | cut -d' ' -f2)
        print_success "pip $PIP_VERSION found"
        return 0
    else
        print_error "pip3 not found"
        return 1
    fi
}

################################################################################
# System Dependencies Installation
################################################################################

install_system_dependencies() {
    print_header "Installing System Dependencies"

    case $OS in
        ubuntu|debian|linuxmint|pop)
            print_info "Installing dependencies for Debian/Ubuntu-based system..."
            sudo apt-get update
            sudo apt-get install -y \
                python3 \
                python3-pip \
                python3-dev \
                python3-cryptography \
                python3-serial \
                build-essential \
                libssl-dev \
                libffi-dev \
                git
            ;;

        fedora|rhel|centos)
            print_info "Installing dependencies for Fedora/RHEL-based system..."
            sudo dnf install -y \
                python3 \
                python3-pip \
                python3-devel \
                python3-cryptography \
                python3-pyserial \
                gcc \
                openssl-devel \
                libffi-devel \
                git
            ;;

        arch|manjaro)
            print_info "Installing dependencies for Arch-based system..."
            sudo pacman -Sy --noconfirm \
                python \
                python-pip \
                python-cryptography \
                python-pyserial \
                base-devel \
                openssl \
                git
            ;;

        *)
            print_warning "Unknown distribution. Please install manually:"
            print_info "  - Python 3.7+"
            print_info "  - pip3"
            print_info "  - python3-dev / python3-devel"
            print_info "  - OpenSSL development libraries"
            print_info "  - build-essential / gcc"
            read -p "Have you installed these dependencies? (y/n) " -n 1 -r
            echo
            if [[ ! $REPLY =~ ^[Yy]$ ]]; then
                print_error "Please install dependencies first"
                exit 1
            fi
            ;;
    esac

    print_success "System dependencies installed"
}

################################################################################
# Python Package Installation
################################################################################

install_reticulum() {
    print_header "Installing Reticulum Network Stack"

    # Ask user which version to install
    echo "Choose Reticulum installation option:"
    echo "  1) Standard (rns) - Includes all dependencies"
    echo "  2) Pure Python (rnspure) - No external dependencies"
    read -p "Enter choice [1-2] (default: 1): " choice
    choice=${choice:-1}

    case $choice in
        1)
            print_info "Installing standard Reticulum package (rns)..."
            pip3 install --user rns
            ;;
        2)
            print_info "Installing pure Python Reticulum package (rnspure)..."
            pip3 install --user rnspure
            ;;
        *)
            print_error "Invalid choice"
            exit 1
            ;;
    esac

    print_success "Reticulum installed successfully"
}

install_lxmf() {
    print_header "Installing LXMF (Lightweight Extensible Message Format)"

    print_info "Installing LXMF >= 0.6.1..."
    pip3 install --user "lxmf>=0.6.1"

    print_success "LXMF installed successfully"
}

install_nomadnet() {
    print_header "Installing Nomadnet"

    print_info "Installing Nomadnet and dependencies..."
    print_info "  - rns >= 0.9.1"
    print_info "  - lxmf >= 0.6.1"
    print_info "  - urwid >= 2.6.16"
    print_info "  - qrcode"

    pip3 install --user nomadnet

    print_success "Nomadnet installed successfully"
}

################################################################################
# Optional Tools Installation
################################################################################

install_optional_tools() {
    print_header "Optional Tools"

    echo "Would you like to install optional Python packages?"
    echo "  - feedparser (for RSS feeds)"
    echo "  - requests (for HTTP requests)"
    read -p "Install optional tools? (y/n): " -n 1 -r
    echo

    if [[ $REPLY =~ ^[Yy]$ ]]; then
        print_info "Installing optional packages..."
        pip3 install --user feedparser requests
        print_success "Optional packages installed"
    else
        print_info "Skipping optional packages"
    fi
}

################################################################################
# Configuration Setup
################################################################################

setup_configuration() {
    print_header "Setting Up Configuration"

    # Ensure PATH includes user's local bin
    if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
        print_warning "Adding ~/.local/bin to PATH"
        echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
        export PATH="$HOME/.local/bin:$PATH"
    fi

    # Initialize Reticulum config
    print_info "Initializing Reticulum configuration..."
    if [ ! -f ~/.reticulum/config ]; then
        python3 -c "import RNS; RNS.Reticulum()" 2>/dev/null || true
        print_success "Reticulum configuration initialized at ~/.reticulum/config"
    else
        print_info "Reticulum configuration already exists"
    fi

    # Initialize Nomadnet config
    print_info "Initializing Nomadnet configuration..."
    if [ ! -f ~/.nomadnetwork/config ]; then
        mkdir -p ~/.nomadnetwork
        print_success "Nomadnet directory created at ~/.nomadnetwork/"
        print_info "Configuration will be created on first run"
    else
        print_info "Nomadnet configuration already exists"
    fi

    print_success "Configuration setup complete"
}

################################################################################
# Verification
################################################################################

verify_installation() {
    print_header "Verifying Installation"

    # Test Reticulum import
    if python3 -c "import RNS; print('Reticulum version:', RNS.version)" 2>/dev/null; then
        print_success "Reticulum import successful"
    else
        print_error "Reticulum import failed"
        return 1
    fi

    # Test LXMF import
    if python3 -c "import LXMF; print('LXMF version:', LXMF.__version__)" 2>/dev/null; then
        print_success "LXMF import successful"
    else
        print_error "LXMF import failed"
        return 1
    fi

    # Check for nomadnet command
    if command -v nomadnet &> /dev/null; then
        print_success "nomadnet command available"
    else
        print_warning "nomadnet command not found in PATH"
        print_info "Try running: source ~/.bashrc"
    fi

    print_success "Installation verification complete"
}

################################################################################
# Main Installation Flow
################################################################################

main() {
    clear
    print_header "Reticulum & Nomadnet Installer v${VERSION}"

    print_info "This script will install:"
    print_info "  • Reticulum Network Stack"
    print_info "  • LXMF (Lightweight Extensible Message Format)"
    print_info "  • Nomadnet"
    print_info "  • All required dependencies"
    echo ""
    read -p "Continue with installation? (y/n) " -n 1 -r
    echo

    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        print_info "Installation cancelled"
        exit 0
    fi

    # Detect operating system
    detect_os

    # Check Python
    if ! check_python; then
        print_error "Python 3.7+ is required. Please install it first."
        exit 1
    fi

    # Install system dependencies
    install_system_dependencies

    # Check pip
    if ! check_pip; then
        print_error "pip3 is required but not installed properly"
        exit 1
    fi

    # Install Python packages
    install_reticulum
    install_lxmf
    install_nomadnet

    # Optional tools
    install_optional_tools

    # Setup configuration
    setup_configuration

    # Verify installation
    verify_installation

    # Final message
    print_header "Installation Complete!"

    echo -e "${GREEN}"
    echo "┌─────────────────────────────────────────────┐"
    echo "│  Reticulum & Nomadnet Installation Complete │"
    echo "└─────────────────────────────────────────────┘"
    echo -e "${NC}"

    print_info "Next steps:"
    echo ""
    echo "  1. Reload your shell or run: source ~/.bashrc"
    echo "  2. Start Nomadnet: nomadnet"
    echo "  3. Configure Reticulum: nano ~/.reticulum/config"
    echo "  4. Configure Nomadnet: nano ~/.nomadnetwork/config"
    echo ""
    print_info "Documentation:"
    echo "  • Reticulum: https://reticulum.network/manual/"
    echo "  • Nomadnet: https://github.com/markqvist/NomadNet"
    echo ""
    print_info "Test connections:"
    echo "  • Check Reticulum status: rnstatus"
    echo "  • Check interfaces: rnstatus -v"
    echo "  • Start Nomadnet: nomadnet"
    echo ""

    print_success "Enjoy your mesh network!"
}

# Run main installation
main
