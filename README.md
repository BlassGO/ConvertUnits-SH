# Convert Tool

A simple pure Shell Script + AWK function to convert units (``100 GB -> MB``)  using a configuration file 🚀

> A dynamic relationship is maintained among all units. In this way, all possible conversion sequences can be obtained from a reduced set of relationships

## 💻 Compatibility

- **Linux / macOS**: Works with Bash / Zsh / SH and more
- **Architecture**: Runs on any hardware (x86, ARM, etc.) since it uses pure Shell + AWK

## 📦 Installation

Use the automatic installer for easy setup:

1. Clone the repository:
   ```bash
   git clone https://github.com/BlassGO/ConvertUnits-SH.git convert-tool
   cd convert-tool
   ```
2. Run the installer:
   ```bash
   ./install.sh
   ```

## 🛠️ Usage

Run the `convert` command to convert units based on the config file:
```bash
convert 1GB MB  # 1 GigaByte -> 1024 MegaBytes
```

More examples:
```bash
convert 5h s    # 5 hours -> 18000 seconds
convert 3d s    # 3 days -> 259200 seconds
convert 10.5km m   # 10.5 kilometers -> 10500 meters
convert 0.05g kg   # 0.05 grams -> 0.00005 kilograms
convert 1000N kN   # 1000 Newtons -> 1 kiloNewton
```

Interesting cases:
```bash
convert h s   # 1 hour -> 3600 seconds
convert 1e-05h s    # 0.00001 hour -> 0.036 seconds
```

### Options
- `-d <number>`: Set decimal places (default is 16)
  ```bash
  convert -d 2   1.6GB MB  # Result: 1638.40 MB

  convert -d 0   1.6GB MB  # Result: 1638 MB
  ```
- `-s`: Show the conversion steps
  ```bash
  convert -s   1.5GB KB    # 1.5GB | 1536MB -> 1572864KB
  ```

### Environment Variables (Optional)
- `convert_from`: Default unit to convert from.
- `convert_to`: Default unit to convert to.
- `convert_config`: Custom path to the configuration file.
  ```bash
  export convert_from=MB
  export convert_to=GB
  convert 1024  # Converts 1024MB to GB
  ```

## 📋 Supported Units

The tool supports the following unit groups and their conversions, as defined in `units.config`:

| Group | Unit | Full Name |
|-------|------|-----------|
| **Storage** | b | Bit |
| | B | Byte |
| | KB | Kilobyte |
| | MB | Megabyte |
| | GB | Gigabyte |
| | TB | Terabyte |
| **Time** | s | Second |
| | min | Minute |
| | h | Hour |
| | d | Day |
| **Length** | mm | Millimeter |
| | cm | Centimeter |
| | m | Meter |
| | km | Kilometer |
| **Mass** | g | Gram |
| | on | Ounce |
| | lb | Pound |
| | kg | Kilogram |
| | ston | Stone |
| | @ | Arroba |
| | q | Quintal |
| | ton | Tonne |
| **Force** | dyn | Dyne |
| | pdl | Poundal |
| | ozf | Ounce-force |
| | N | Newton |
| | lbf | Pound-force |
| | kN | Kilonewton |

## ⚙️ Configuration

The tool uses `~/.config/convert/units.config` to define unit conversions. Edit it to add or change units:
```bash
nano ~/.config/convert/units.config
```

Base config example:
```text
[storage: "b" "B" "KB" "MB" "GB" "TB"]
1B = 8b
1KB = 1024B
1MB = 1024KB
1GB = 1024MB
1TB = 1024GB
[storage end]
```

- Groups (`[storage: ...]`) list related units and order.
- Lines like `1B = 8b` define conversion ratios.
- Comments start with `#`.

> **Rules:** Use scientific notation for small numbers (e.g., 1e-05 for 0.00001). Numeric values in the config file with many decimal places behave better with scientific notation; if more than 5 decimal places are required, it's better to always use it

## 🗑️ Uninstall

1. Just run:
   ```bash
   ./uninstall.sh
   ```

## ☕ Support

If you find this tool useful, consider buying me a coffee to support my work! If you're not able to, starring the repository helps a lot too!

<a href="https://www.buymeacoffee.com/BlassGO" target="_blank"><img src="https://cdn.buymeacoffee.com/buttons/v2/default-yellow.png" alt="Buy Me A Coffee" style="height: 50px !important;width: 170px !important;" ></a>

---

## ✨ Credits

* **[BlassGO](https://github.com/BlassGO)**: Developer of this tool