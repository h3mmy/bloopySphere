# Plex Trakt Sync

Project page [Github](https://github.com/Taxel/PlexTraktSync)

_Yes the config file has to be `.yml` and not `.yaml`_ 🤷🏽‍♀️

There is no way to authenticate declaritively and the codeowner seems resistant to add any non-interactive method. So you need to manually exec into the container for this to be useful and it defeats the purpose a bit.

To pause the container after startup and be able to use "interactive" mode, replace the container args:

1. Instead of `sync`, use something like `info && /bin/bash` to drop into a shell
2. You might need to generate a token directly if it doesn't look at the provided one. Idk why, I'm not the codeowner
