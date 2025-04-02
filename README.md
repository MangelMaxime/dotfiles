## Increase inotify limits

[Source](https://www.suse.com/support/kb/doc/?id=000020048)

```bash
sudo sysctl fs.inotify.max_user_instances=8192
sudo sysctl fs.inotify.max_user_watches=524288
sudo sysctl -p
```

## Programs

- [btop](https://github.com/aristocratos/btop)
- [cliphist](https://github.com/sentriz/cliphist)
