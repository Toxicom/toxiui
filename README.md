# ToxiUI is a minimalistic edit of ElvUI by Toxi

It's best played at 1440p resolution!

## Features:

- Very easy installation process
- Modern & customisable data panel - WunderBar
- Constant updates
- Lots of extra built-in plugins for Quality of Life
- DPS & Healer layouts
- 3 themes to choose from
- Easily customisable gradient colors

## Development workflow
### Use the `development` branch
The `stable` branch should be updated only every big (non-beta) release, so that we have a reference.

### Pull requests only
Please do not push code to the `stable` or `development` branches and only use Pull Requests.

### Commit messages
We use a VSCode extension called **Emoji Log** for commit messages.
This is so that #git-feed is readable and easy to understand.

Commits including `TEST:` will be exluded from the changelog in #build-releases

VS Marketplace Link: https://marketplace.visualstudio.com/items?itemName=ahmadawais.emoji-log-vscode  

### Code formatting
Please install the stylua extension and setup to format on save

https://marketplace.visualstudio.com/items?itemName=JohnnyMorganz.stylua

## Chat Commands:

### General (user facing)

_Prefix: `/tx` `/txui` `/toxui` `/toxiui`_

`/tx` - ElvUI TXUI Options Dialog _(alias of /tx settings)_<br>
`/tx changelog` - ElvUI TXUI Options showing ONLY the changelog<br>
`/tx wb` - ElvUI TXUI Options showing ONLY WunderBar<br>
`/tx badge` - Disable chat badges _(only possible if you actually have a chat badge)_<br>
`/tx export names` - Export a list of all character names where ElvUI was active<br>
`/tx reset` - Resets all TXUI Settings _(not the ElvUI profile itself, tho a re-install is needed to gain access to TXUI features back)_<br>
`/tx status` - Shows the Diagnostic Popup _(alias of /tx info)_<br>
`/tx install` - Shows the Installer Dialog for TXUI

### Dev Section (or beta builds)

`/tx dev profile [dps|healer]` - Install the ElvUI Profile without confirmation<br>
`/tx dev cvar` - Sets the default ElvUI Cvars _(+ personal change)_<br>
`/tx dev chat` - Install a custom chat config<br>
`/tx dev wb` - Enables the wunderbar debug mode<br>
`/tx dev splash` - Shows the Splashscreen for 15 Seconds<br>
`/tx dev dpi` - Gives you a scaled pixel perfect number (Magic Config Number -> Actual Number)

### Devs Only

`/tx dev toggle` - Toggles Developer mode, which activates overrides and custom features _(like Escape-Menu Background etc)_<br>

### Exports

`/tx dev export bw [dps|healer]` - Exports the BigWigs profile for DPS or Healer<br>
`/tx dev export dbm [dps|healer]` - Same as above just for DBM<br>
`/tx dev export names` - Triggers the import of badge names (decode)
