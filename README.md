A repo to hold common scripting tools I use.

# format_usb.sh - USB Formatting Script

## 📝 Overview
`format_usb.sh` is a **cross-platform** CLI tool to **format USB drives** on **Windows, Linux, and macOS**.

## 🔧 Features
✅ Detects available USB drives  
✅ Supports **FAT32, NTFS, and exFAT**  
✅ Prevents accidental formatting of system drives  
✅ Works with **Windows, Linux, and macOS**  
✅ **User-friendly CLI** with confirmation prompts  

## 🚀 Usage

### **1️⃣ Run the Script**
#### **Windows (Git Bash, WSL, PowerShell as Administrator)**
```sh
sh format_usb.sh
```
👉 **Must be run as Administrator**  

#### **Linux/macOS**
```sh
sudo bash format_usb.sh
```

### **2️⃣ Select a USB Drive**
The script will **list available USB drives**:
```plaintext
Number FriendlyName       Size
------ --------------    -----
0      INTEL SSD         1TB
1      SanDisk USB       32GB
```
Enter the drive number (e.g., `1` for `SanDisk USB`).

### **3️⃣ Choose a File System**
```plaintext
1) FAT32 (Default)
2) NTFS
3) exFAT
Choose format [1/2/3]: 1
```

### **4️⃣ Confirm Before Formatting**
```plaintext
⚠ WARNING: This will **ERASE** all data on drive 1!
Are you sure? (y/N): y
```

## 🛠️ Troubleshooting
### **Windows: "Access to a CIM resource was not available"**
👉 Run **PowerShell as Administrator**, then execute:
```powershell
Enable-PSRemoting -Force
```

### **Linux/macOS: "Permission Denied"**
👉 Use `sudo` when running the script:
```sh
sudo bash format_usb.sh
```

## 📄 License
MIT License - Free to use, modify, and distribute.

