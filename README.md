# Machinekit for the C.H.I.P
The purpose of this project is to make using Machinekit on the [NextThing C.H.I.P](https://getchip.com/) as comfortable as possible.

If your C.H.I.P. is already connected to the internet, you can skip ahead to <a href="#name">the installation</a>.

## Setup WiFi
First of all, you need to connect your C.H.I.P. to the web. Do achieve this you connect the C.H.I.P. to WiFi network.

First, list the available networks.

``` bash
nmcli device wifi list
```

You should see a list of available networks.
``` bash
*  SSID      MODE   CHAN  RATE       SIGNAL  BARS  SECURITY
*  NextThing HQ    Infra  11    54 Mbit/s  100     ▂▄▆█  --
   NextThing Shop  Infra  6     54 Mbit/s  30      ▂___  WPA1 WPA2
   2WIRE533        Infra  10    54 Mbit/s  44      ▂▄__  WPA1 WPA2
```

Next, connect a network. Without password:
``` bash
sudo nmcli device wifi connect '(your wifi network name/SSID)' ifname wlan0
```

Or with password:
``` bash
sudo nmcli device wifi connect '(your wifi network name/SSID)' password '(your wifi password)' ifname wlan0
```

Once connected you are ready to install Machinekit.

<a name="install"/>
## Install

Installing Machinekit on the C.H.I.P is as easy as executing the following line:
``` bash
curl -sSL http://bit.ly/2cyf0At | sudo -E bash -
```

This script will download and install Machinekit and an RT-PREEMPT kernel for the C.H.I.P 4.4 images. *Caution:* During the installation, it will download a few hundred megabytes of data.

## Test
Now it is time to download and run the first Machinekit configuration.

First, install git.
``` bash
sudo apt install git
```

Then, clone the `hal_hello_chip` configuration and execute the `run.py`:
``` bash
cd
mkdir repos
cd repos
git clone https://github.com/machinekoder/hal_hello_chip
cd hal_hello_chip
./run.py &
```

Now you should have a running Machinekit instance. To verify your setup is working run:

``` bash
halcmd show pin
```
You should see something similar to this:
```
Component Pins:
  Comp   Inst Type  Dir         Value  Name                                             Epsilon         Flags
    73        bit   OUT         FALSE  chip_gpio.in-04                                                  0
    73        bit   IN          FALSE  chip_gpio.in-04.invert                                           0
    73        bit   OUT         FALSE  chip_gpio.in-05                                                  0
    73        bit   IN          FALSE  chip_gpio.in-05.invert                                           0
    73        bit   OUT         FALSE  chip_gpio.in-06                                                  0
    73        bit   IN          FALSE  chip_gpio.in-06.invert                                           0
    73        bit   OUT         FALSE  chip_gpio.in-07                                                  0
    73        bit   IN          FALSE  chip_gpio.in-07.invert                                           0
    73        bit   IN          FALSE  chip_gpio.out-00                                                 0 <== square
    73        bit   IN          FALSE  chip_gpio.out-00.invert                                          0
    73        bit   IN          FALSE  chip_gpio.out-01                                                 0
    73        bit   IN          FALSE  chip_gpio.out-01.invert                                          0
    73        bit   IN          FALSE  chip_gpio.out-02                                                 0
    73        bit   IN          FALSE  chip_gpio.out-02.invert                                          0
    73        bit   IN          FALSE  chip_gpio.out-03                                                 0
    73        bit   IN          FALSE  chip_gpio.out-03.invert                                          0
    73        s32   OUT          3625  chip_gpio.read.time                                              0
    73        s32   OUT          3875  chip_gpio.write.time                                             0
   102        float IN              1  siggen.0.amplitude                               0.000010        0
   102        bit   OUT         FALSE  siggen.0.clock                                                   0 ==> square
   102        float OUT    -0.9921147  siggen.0.cosine                                  0.000010        0
   102        float IN             10  siggen.0.frequency                               0.000010        0
   102        float IN              0  siggen.0.offset                                  0.000010        0
   102        float OUT         -0.04  siggen.0.sawtooth                                0.000010        0
   102        float OUT     0.1253332  siggen.0.sine                                    0.000010        0
   102        float OUT             1  siggen.0.square                                  0.000010        0
   102        float OUT         -0.88  siggen.0.triangle                                0.000010        0
   102        s32   OUT          7958  siggen.0.update.time                                             0
```

Now you are ready to play around with [Machinekit](http://machinekit.io)

## Setup USB OTG networking

If you want to use USB networking on your C.H.I.P., you can use following commands.

``` bash
sudo editor /etc/network/interfaces.d/usb0
```
And insert
```
auto usb0
iface usb0 inet static
address 192.168.7.1
netmask 255.255.255.0

```
Start the network by running:
``` bash
sudo ifup usb0
```

On your host computer, you have to use manual IPv4 address `192.168.7.2`.
