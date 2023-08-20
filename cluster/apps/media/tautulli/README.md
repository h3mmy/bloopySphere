# Tautulli

[Github - Tautulli/Tautulli](https://github.com/Tautulli/Tautulli)

## Custom Scripts

Tautulli has support for [custom scripts](https://github.com/Tautulli/Tautulli/wiki/Custom-Scripts)
I use [JBOPS](https://github.com/blacktwin/JBOPS) to automate some stuff related to plex management.
Here is an example of handling 4k transcode violations.

### Kill 4K transcode streams

Tautulli -> Settings -> Notification Agents

#### Configuration

![Base Configuration](https://github.com/h3mmy/bloopysphere/blob/main/static/assets/tautulli_jbops_configuration.png?raw=true)

Define your script folder. Mine is mounted at `/add-ons` so my script folder is `/add-ons/JBOPS`.

Define your script file. In this case I am using `killstream/kill_stream.py`

#### Triggers

Define your triggers. Using 'Playback Start' and 'Playback Resume' will catch most cases. I've also used 'Transcode Decision Change' with some additional logic involved, but that is not showcased here.

#### Conditions

![Conditions](https://github.com/h3mmy/bloopysphere/blob/main/static/assets/tautulli_jbops_conditions.png?raw=true)

These are the conditions under which you want to kill the stream with a notification to the user. In the screenshot, I've shown a simple setup with 3 conditions:

1. `Video Resolution` contains `4K`
2. `Video Decision` is `transcode`
3. `Subtitle Codec` is `PGS`

Condition Logic is set to `{1} and ({2} or {3})`

I've included PGS subtitles as a streambreaker, but onyl for 4K streams. They usually force a transcode because they are images and have to be burned in. Some clients *can* direct play PGS subtitles, but I have opinions, and prefer usage of SRT. Using `bazarr` ensures most streams should have SRT subtitles.

#### Arguments

This is where you will pass parameters to the script. You will need to add these for each trigger you selected. I used something like this, but you should adapt it to your needs.

`--jbop stream --username {username} --sessionId {session_id} --killMessage 'Transcoding streams are not allowed for 4K content (Yours: {stream_bitrate}). Contact h3mmy for help.'`

![Arguments](https://github.com/h3mmy/bloopysphere/blob/main/static/assets/tautulli_jbops_parameters.png?raw=true)
