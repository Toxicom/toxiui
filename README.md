
![ToxiUI](https://i.imgur.com/S5a4FCi.png)
# ToxiUI: Enhancing Your World of Warcraft Experience
Welcome to ToxiUI, a thoughtfully crafted plugin for the renowned ElvUI, meticulously designed by Toxi. If you're seeking a seamless and visually appealing overhaul for your World of Warcraft interface, you're in the right place. ToxiUI seamlessly combines functionality and aesthetics, ensuring that your gaming experience reaches new heights of enjoyment and efficiency.

## Why ToxiUI?
![ToxiUI Installer](https://i.imgur.com/SmPHcOb.png)
### Effortless Installation
Gone are the days of complex installation processes. ToxiUI prides itself on a straightforward installation that doesn't require a degree in rocket science. With clear instructions and user-friendly steps, you'll be up and running with ToxiUI in no time.

![ToxiUI WunderBar](https://i.imgur.com/SopBA5h.png)
### WunderBar: Your Modern Data Panel
Experience the future of data panels with WunderBar. ToxiUI introduces a modern and customizable data panel that serves as your one-stop hub for crucial information. Whether you're tracking your character's statistics, managing resources, or just staring at the clock while afk running around the capital city, WunderBar offers unparalleled convenience and customization.

![ToxiUI Themes](https://i.imgur.com/3hhJSwN.png)
### A World of Themes and Customization
ToxiUI empowers you to personalize your World of Warcraft interface. With three distinct themes to choose from, you can align your UI with your personal style or adapt it to match your character's journey. And if that's not enough, the ability to easily customize gradient colors ensures your UI remains as unique as your adventure.

### Community-Driven Evolution
ToxiUI is not just a modification; it's a collaborative journey driven by the World of Warcraft community. As an open-source project, it thrives on the collective expertise and passion of players like you. While the pace of official development might have eased, the heart of ToxiUI beats stronger than ever through community contributions.

### Tailored for Diverse Playstyles
Whether you're a damage-dealing dynamo or a healing virtuoso, ToxiUI has you covered. It offers specialized layouts for DPS and healers, optimizing your interface for the roles you excel in. No matter your preferred playstyle, ToxiUI adapts to amplify your performance.

### Embrace ToxiUI
Elevate your World of Warcraft journey with ToxiUI. Seamlessly merging minimalist design, cutting-edge functionality, and immersive customization, ToxiUI stands as the ultimate UI modification for players who demand the best. Join the ranks of adventurers who have embraced ToxiUI and experience Azeroth like never before.

## How to keep up to date with repo
### Windows OS
1. Clone the repository
2. `git checkout development`
3. Create a [symlink directory junction](https://www.howtogeek.com/howto/16226/complete-guide-to-symbolic-links-symlinks-on-windows-or-linux/)
    1. Open up Command Prompt **as administator**
    2. `mklink /J <new path> <old path>`

#### Example:
```sh
mklink /J "D:\Games\World of Warcraft\_retail_\Interface\AddOns\ElvUI_ToxiUI\" C:\Users\Toxi\Documents\GitHub\toxiui
```


## Development workflow
### Use the `development` branch
The `stable` branch should be updated only every big (non-beta) release, so that we have a reference.

⚠️ **2023-07-15:** Moving the release CI to `development` branch. `stable` will only be used as a reference point, but even then not sure if needed with the amount of commits we have nowadays.

### Pull requests only
⛔️ Please do not push code to the `stable` or `development` branches and only use Pull Requests.

### Commit messages
![Emoji Log Extension](https://i.imgur.com/wfC95MH.png)

We use a [VSCode](https://code.visualstudio.com/) extension called **Emoji Log** for commit messages.
This is so that [#📦git-feed](https://discord.com/channels/769550106948141086/797585103278571551) is readable and easy to understand.

ℹ️ Commits including `TEST:` will be exluded from the changelog in #build-releases

🔗 https://marketplace.visualstudio.com/items?itemName=ahmadawais.emoji-log-vscode

### Code formatting
Please install the stylua extension and setup to format on save

```json
// settings.json
{
    "editor.formatOnSave": true,
    "[lua]": {
        "editor.defaultFormatter": "JohnnyMorganz.stylua"
    },
}
```

🔗 https://marketplace.visualstudio.com/items?itemName=JohnnyMorganz.stylua

## Chat Commands:

### General (user facing)

_Prefix: `/tx` `/txui` `/toxi` `/toxiui`_

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
`/tx dev export names` - Triggers the import of badge names (decode)
