# Konsole: Nerd Font + readable profile

Install a Nerd Font for the current user and make Konsole use it by default.
Without a Nerd Font, Neovim icons (file types, diagnostics, statusline) show up as boxes.

## Install JetBrains Mono Nerd Font (user-local, no sudo)

```bash
cd /tmp
curl -fsSL -o JBM.tar.xz \
  https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.tar.xz
mkdir -p ~/.local/share/fonts/JetBrainsMonoNerd
tar -xJf JBM.tar.xz -C ~/.local/share/fonts/JetBrainsMonoNerd \
  --wildcards 'JetBrainsMonoNerdFont-*.ttf'
fc-cache -f ~/.local/share/fonts
```

Check:

```bash
fc-list : family | grep -i "JetBrainsMono Nerd Font"
```

## Create a Konsole profile

`~/.local/share/konsole/Code.profile`:

```ini
[Appearance]
Font=JetBrainsMono Nerd Font,13,-1,5,50,0,0,0,0,0
LineSpacing=2
UseFontLineChararacters=true

[General]
Name=Code
Parent=FALLBACK/
```

- `13` — font size (12–14 is comfortable for code).
- `LineSpacing=2` — extra pixels between lines.
- `UseFontLineChararacters` is spelled with a typo in Konsole itself — keep it as is.

## Make it the default profile

```bash
kwriteconfig5 --file konsolerc --group "Desktop Entry" --key DefaultProfile Code.profile
```

(On Plasma 6 use `kwriteconfig6`.)

Restart Konsole — already open windows keep the old profile.
Fine-tuning: *Settings → Edit Current Profile → Appearance*.
