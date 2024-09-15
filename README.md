![Gameplay video](https://media.forgecdn.net/attachments/description/676447/description_79cd99f7-eac7-4849-b97c-427f1c7140b6.png)

[![Video thumbnail](https://img.youtube.com/vi/jizdfGCNxmU/maxresdefault.jpg)](https://www.youtube.com/watch?v=jizdfGCNxmU)

###### Click the image above to see the video

 

![Features](https://media.forgecdn.net/attachments/description/676447/description_241dfa18-3e41-4400-99a9-cc1eedeb24d9.png)

*   Three themes to choose from: Gradient Mode, Dark Mode & default
*   Beautiful Armory packed with information
*   Elegant WunderBar to have all the important information at your fingertips
*   Unique hand-made specialization icons
*   Custom text tags
*   Game Menu Skin to personalize your gameplay and provide useful information
*   Enhanced custom installer
*   Active Discord community
*   …and more!

![Requirements](https://media.forgecdn.net/attachments/description/676447/description_63516ad4-2c2e-4383-b5c8-29f43db86c80.png)

Required AddOns:
----------------

*   [ElvUI](https://www.tukui.org/download.php?ui=elvui)

Recommended AddOns:
-------------------

*   [Details! Damage Meter](https://www.curseforge.com/wow/addons/details)
*   [Plater](https://www.curseforge.com/wow/addons/plater-nameplates)
*   [Weak Auras](https://www.curseforge.com/wow/addons/weakauras-2)
*   [ElvUI WindTools](https://www.curseforge.com/wow/addons/elvui-windtools) _(Retail only)_

Additional supported AddOns:
----------------------------

*   [BigWigs](https://www.curseforge.com/wow/addons/big-wigs)
*   [OmniCD - Party Cooldown Tracker](https://www.curseforge.com/wow/addons/omnicd)
*   [WarpDeplete (Retail only)](https://www.curseforge.com/wow/addons/warpdeplete)
*   [Ratio Minimap Auras](https://www.curseforge.com/wow/addons/elvui-ratiominimapauras)

![Installation](https://media.forgecdn.net/attachments/description/676447/description_eef9d427-56cd-4167-a38e-59f260b92ac1.png)

*   Make a backup of your WTF folder _(it is recommended to install ToxiUI on a clean profile)_
*   Install the required addons
*   Enter game & make sure that all of the AddOns are loaded correctly
*   Once you load up your character, the ToxiUI installer will pop-up
*   Simply **follow** the installers **instructions very closely**
*   If you have any problems or issues at any step, please visit our discord server for support!

[![Installation video guide](https://img.youtube.com/vi/C0YpDaEHvWU/maxresdefault.jpg)](https://www.youtube.com/watch?v=C0YpDaEHvWU)

###### Click the image above to see the video

 

![Credits](https://media.forgecdn.net/attachments/description/676447/description_d643a212-3ccc-47e5-b892-363771a6ac65.png)
--------------------------------------------------------------------------------------------------------------------------

*   Nawuko for developing the initial ToxiUI codebase
*   Ryada, Wolen and others for contributing to the project staying alive
*   Hekili for help with coding the first version of installer framework
*   Releaf for those lovely WunderBar icons
*   v0dKa for supporting heavily in the early days - real MVP
*   Redtuzk & his team for the inspiration
*   ElvUI discord for continuous help and support
*   PayPal & Patreon supporters! You guys rock!

![Discord](https://media.forgecdn.net/attachments/description/676447/description_9d2a48cc-2282-4076-8652-49eb0a8d7f03.png)

*   If you're having any problems or just wanna chat with us, please join our [discord server](https://discord.gg/r85TGUU7zA)

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

`/tx dev toggle` - Toggles Developer mode, which activates overrides<br>

### Exports

`/tx dev export names` - Triggers the import of badge names (decode)
