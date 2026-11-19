# systemd-http-time-sync

A lightweight `systemd` service and Bash script that automatically syncs your Linux system clock and hardware clock (RTC) at boot using plain HTTP `Date` headers.

## Why?

Standard NTP (`systemd-timesyncd`, `chrony`) often fails or isn't enough in a few common scenarios:

* **Dual-boot clock drift:** Windows stores local time in the hardware clock while Linux expects UTC, causing time jumps between boots.
* **Dead or missing CMOS battery:** The system clock resets to a past date every time the machine loses power.
* **Blocked NTP ports:** University and corporate firewalls frequently block UDP port 123.
* **SSL/TLS chicken-and-egg problem:** When the system clock is far behind, HTTPS requests fail certificate validation. Polling over plain `http://` bypasses this cleanly.

## How It Works

1. Launches automatically on boot via `systemd` once the network is up.
2. Polls reliable fallback servers (`google.com`, `cloudflare.com`, `1.1.1.1`) over plain HTTP for their `Date` header.
3. Updates both the OS clock (`date -s`) and the hardware clock (`hwclock --systohc`), then exits cleanly.
4. If the machine is offline at boot, it retries every 10 seconds until a connection is available.

## Installation

```bash
git clone [https://github.com/Anish-Prime/systemd-http-time-sync.git](https://github.com/Anish-Prime/systemd-http-time-sync.git)
cd systemd-http-time-sync
sudo ./install.sh
```

## Verification

Check the service logs to confirm the sync succeeded:

```bash
journalctl -u http-time-sync.service -n 5
```

You should see output similar to:

```text
Time synced from [http://google.com](http://google.com) to: Thu, 19 Nov 2026 20:04:34 GMT
http-time-sync.service: Deactivated successfully.
```

## Uninstall

```bash
sudo ./uninstall.sh
```

## License

See the [LICENSE](LICENSE) file for details.
