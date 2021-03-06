# slack-user-status-trigger

Demo
---

![demo image](https://raw.githubusercontent.com/MaxMEllon/demos/master/slack-user-status-trigger/demo.gif)

Usage
---

```
$ work start

$ work stop
```

Installation
---

- install with [zplug](https://github.com/zplug/zplug):

```bash
zplug 'maxmellon/slack-user-status-trigger', \
    use:'(*.sh)', \
    rename-to:'$1'
```

- manual install

```bash
$ git clone git@github.com:MaxMEllon/slack-user-status-trigger.git /path/to/slack-user-status-trigger
$ source /path/to/slack-user-status-trigger/work-reporter.sh
```

Configurations
---

If you use `bash`, all you need is adding below line to your `~/.bashrc` or `~/.bash_profile`

```bash
export SLACK_API_TOKEN="xoxp-00000000000-00000000000-000000000000-0123456789abcdefghijklmnopqrstuv"
export SLACK_START_STATUS_TEXT="お仕事なう"
export SLACK_START_EMOJI=":muscle:"
export SLACK_END_STATUS_TEXT="おやすみ"
export SLACK_END_EMOJI=":zzz:"
```

LICENSE
---

- [MIT](./LICENSE.txt)

  `(c)` Kento TSUJ (a.k.a. MaxMEllon)
