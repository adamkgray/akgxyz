# Formatting a bootable drive on Mac using the CLI

---

_03.05.2022_

This is a short guide on how to format a bootable drive on mac using the CLI. Many articles out there already cover this topic, but they use the disk utility app on the Mac. In my experience, I have had issues with it and found it hard to debug. Plus, if you are a beginner, you want to have a better understand of what is _really_ going on behind the scenes. This guide will help you understand the process and will be less buggy than the app. Happy hacking!

## Getting Started

Insert your drive (re: USB stick) into your machine and open Terminal. Then run:

```bash
$ diskutil list
```

## Erasing and Formatting the Drive

You'll see a list of all disks on your machine. Your USB stick will proabably be the last one. It's name will be something like `/dev/diskN` where `N` is some integer. We will erase and format the drive in one command. Run:

```bash
$ diskutil eraseDisk FAT32 NAME /dev/diskN
```

NOTE: `NAME` can be anything but it must be all capital letters. This will erase the contents of your disk and reformat it to MS-DOS FAT 32, which is the format you want.


## Umounting the Drive

After erasing and formatting the drive, we must unmount it. Run:

```bash
$ diskutil unmountDisk /dev/diskN
```

This will unmount your disk. If you omit this step, when you try to write to the drive you will get a resource busy error.

## Writing the `.iso` to the Drive

Let's write your `.iso` to your drive using `dd`. This will stream the content of your `.iso` to you drive. I have heard that sysadmins jokingly refer to `dd` as "disk destroyer" because of its potentially disasterous effects if you, say, run it on the wrong file. So, carefully, run:

```bash
$ sudo dd bs=1M if=/path/to/your/linux.iso of=/dev/rdiskN`
```

Things to note:

1. `bs=1M` defines the transfer rate (sometimes you will get an error saying `illegal numeric value`. Just change it to `1m` as opposed to `1M`. It has to be capital or lowercase depending on whether you're using mac or linux and it's hard to keep it straight)
2. `if` and `of` stand for input-file and output-file respectively
3. The `r` in `rdiskN` stands for raw and makes the process go faster, but you don't need it, and it could just as well be `/dev/diskN`
4. The computer will produce no visual output as it formats the file. You just have to wait. You can press `ctrl-t` though if you want an update.

## Ejecting the Drive

When `dd` done writing to the USB, your prompt will return and a window will pop up saying that the USB is unreadable by your computer. This is okay. You can choose to eject it from this pop up, or choose ignore and eject it from the command line by running `diskutil eject /dev/diskN`

That's it! You can now insert your drive into another machine, power on, mash F11 and then boot from your `.iso`.