## Mac M1 安装 Tun/Tap


- Download https://github.com/Tunnelblick/Tunnelblick/tree/master/third_party/tap-notarized.kext
- Download https://github.com/Tunnelblick/Tunnelblick/tree/master/third_party/tun-notarized.kext
- Change the name to tap.kext and tap.kext,
- Copy to /Library/Extensions
- add net.tunnelblick.tap.plist and net.tunnelblick.tun.plist to /Library/LaunchDaemons/

```
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>net.tunnelblick.tap</string>
    <key>ProgramArguments</key>
    <array>
        <string>/sbin/kextload</string>
        <string>/Library/Extensions/tap.kext</string>
    </array>
    <key>KeepAlive</key>
    <false/>
    <key>RunAtLoad</key>
    <true/>
    <key>UserName</key>
    <string>root</string>
</dict>
</plist>
```

```
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>net.tunnelblick.tun</string>
    <key>ProgramArguments</key>
    <array>
          <string>/sbin/kextload</string>
          <string>/Library/Extensions/tun.kext</string>
    </array>
    <key>KeepAlive</key>
    <false/>
    <key>RunAtLoad</key>
    <true/>
    <key>UserName</key>
    <string>root</string>
</dict>
</plist>
```


- Run `sudo kextload /Library/Extensions/tap.kext` in the terminal
- restart Mac after allowing the security check.
