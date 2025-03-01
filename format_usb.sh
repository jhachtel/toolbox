#!/bin/bash
# format_usb.sh - A cross-platform script to format USB drives interactively
#
# Author: Your Name
# Version: 1.8
# License: MIT
# Compatible with: Windows (via Git Bash/WSL), macOS, Linux
#
# Description:
# This script lists available USB drives, allows the user to select one,
# formats it to a chosen filesystem (FAT32, NTFS, exFAT), and assigns a drive letter.
#
# Usage:
#   sudo bash format_usb.sh   # Linux/macOS
#   sh format_usb.sh          # Windows (Git Bash)
#
# Requirements:
# - Windows: Must run in Administrator mode (PowerShell or CMD)
# - Linux: Requires `lsblk` and `mkfs`
# - macOS: Requires `diskutil`

# Detect operating system
detect_os() {
    case "$(uname -s)" in
        Linux*)     OS="linux" ;;
        Darwin*)    OS="mac" ;;
        CYGWIN*|MINGW32*|MSYS*|MINGW*) OS="windows" ;;
        *)          echo "Unsupported OS"; exit 1 ;;
    esac
}

# List available USB drives
list_drives() {
    echo "🔍 Detecting available USB drives..."
    if [[ "$OS" == "linux" ]]; then
        lsblk -o NAME,SIZE,TYPE,MOUNTPOINT | grep "disk"
    elif [[ "$OS" == "mac" ]]; then
        diskutil list | grep "/dev/disk"
    elif [[ "$OS" == "windows" ]]; then
        powershell -Command "Get-Disk | Select Number, FriendlyName, Size"
    fi
}

# User input for selecting drive and filesystem
prompt_user() {
    echo "📌 Please select your USB drive:"
    read -p "Enter the drive identifier (e.g., sdb, disk2, or Disk #): " DRIVE

    echo "🗂 Select filesystem format:"
    echo "1) FAT32 (Default)"
    echo "2) NTFS"
    echo "3) exFAT"
    read -p "Choose format [1/2/3]: " FS_OPTION

    case "$FS_OPTION" in
        2) FILESYSTEM="ntfs" ;;
        3) FILESYSTEM="exfat" ;;
        *) FILESYSTEM="fat32" ;;
    esac

    echo "⚠ WARNING: This will **ERASE** all data on $DRIVE!"
    read -p "Are you sure? (y/N): " CONFIRM
    if [[ "$CONFIRM" != "y" ]]; then
        echo "❌ Operation canceled."
        exit 1
    fi
}

# Format the selected drive
format_drive() {
    echo "🚀 Formatting drive $DRIVE as $FILESYSTEM..."

    if [[ "$OS" == "linux" ]]; then
        sudo umount "/dev/$DRIVE"*
        sudo mkfs -t "$FILESYSTEM" "/dev/$DRIVE"

    elif [[ "$OS" == "mac" ]]; then
        diskutil unmountDisk "/dev/$DRIVE"
        diskutil eraseDisk "$FILESYSTEM" "USB_DRIVE" "/dev/$DRIVE"

    elif [[ "$OS" == "windows" ]]; then
        # Check if disk is already clean (has no partitions)
        CLEAN_REQUIRED=$(powershell -Command "if ((Get-Partition -DiskNumber $DRIVE) -eq \$null) { Write-Output 'yes' } else { Write-Output 'no' }")
        
        echo "select disk $DRIVE" > diskpart_commands.txt
        if [[ "$CLEAN_REQUIRED" == "yes" ]]; then
            echo "clean" >> diskpart_commands.txt
        fi
        echo "create partition primary" >> diskpart_commands.txt
        echo "select partition 1" >> diskpart_commands.txt
        echo "assign" >> diskpart_commands.txt
        echo "exit" >> diskpart_commands.txt

        rm diskpart_commands.txt

        if [[ "$FILESYSTEM" == "exfat" ]]; then
            powershell -Command "Format-Volume -DriveLetter Z -FileSystem exFAT -NewFileSystemLabel 'USB_DRIVE' -Confirm:\$false"
        elif [[ "$FILESYSTEM" == "ntfs" ]]; then
            powershell -Command "Format-Volume -DriveLetter Z -FileSystem NTFS -NewFileSystemLabel 'USB_DRIVE' -Confirm:\$false"
        else
            powershell -Command "Format-Volume -DriveLetter Z -FileSystem FAT32 -NewFileSystemLabel 'USB_DRIVE' -Confirm:\$false"
        fi
    fi

    echo "✅ Formatting complete!"
}

# Main script execution
detect_os
list_drives
prompt_user
format_drive
