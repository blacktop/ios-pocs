# ios-pocs

> iOS POCs and Ideas

## Getting Started

### Install Utils

Install [usbmuxd](https://github.com/libimobiledevice/usbmuxd)

```bash
$ brew install usbmuxd
```

Install [jtool](http://www.newosxbook.com/tools/jtool.html)

```bash
$ brew cask install jtool
```

### SSH via USB

Start proxy

```bash
$ iproxy 2222 22 &
```

SSH

```bash
$ ssh -p 2222 root@localhost
```

### Build in VSCode

#### Command+Shift+B

=OR=

```
$ make all
```

### Debugging

> **NOTE:** when you connected to XCode it installed dev tools on the device

#### In ssh session on iDevice

```bash
$ /Developer/usr/bin/debugserver localhost:6666 --waitfor evil
```

#### In VSCode (build bin)

`Command+Shift+B`

#### Now Start Debugging (remember to set a breakpoint)

Press `F5` or use GUI (you will need to continue past initial trap)

#### In DEBUG CONSOLE

Let's wake this guy up early :smiling_imp:

```lldb
thread jump --line 16
continue
```

## Misc

### Get Levin's [iOSBinaries](http://newosxbook.com/tools/iOSBinaries.html)

```bash
$ wget http://newosxbook.com/tools/binpack64-256.tar.gz
$ scp -P 2222 root@localhost:/
$ ssh -p 2222 root@localhost
$ cd /
$ tar -kxvf binpack64-256.tar.gz
```

### Stop iOS Auto-Updating

```bash
echo "127.0.0.1    mesu.apple.com" >> /etc/hosts
```
