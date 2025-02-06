![游戏视频](https://media.forgecdn.net/attachments/description/676447/description_79cd99f7-eac7-4849-b97c-427f1c7140b6.png)

[![视频缩略图](https://img.youtube.com/vi/jizdfGCNxmU/maxresdefault.jpg)](https://www.youtube.com/watch?v=jizdfGCNxmU)

###### 点击上方图片观看视频

 

![功能](https://media.forgecdn.net/attachments/description/676447/description_241dfa18-3e41-4400-99a9-cc1eedeb24d9.png)

*   三种主题可供选择：渐变模式、暗黑模式和默认模式
*   信息丰富的美丽军械库
*   优雅的WunderBar，让所有重要信息触手可及
*   独特的手工制作专精图标
*   自定义文本标签
*   游戏菜单皮肤，个性化您的游戏体验并提供有用信息
*   增强的自定义安装程序
*   活跃的Discord社区
*   还有更多！

![要求](https://media.forgecdn.net/attachments/description/676447/description_63516ad4-2c2e-4383-b5c8-29f43db86c80.png)

必需插件：
----------------

*   [ElvUI](https://www.tukui.org/download.php?ui=elvui)

推荐插件：
-------------------

*   [Details! 伤害统计](https://www.curseforge.com/wow/addons/details)
*   [Plater](https://www.curseforge.com/wow/addons/plater-nameplates)
*   [Weak Auras](https://www.curseforge.com/wow/addons/weakauras-2)
*   [ElvUI WindTools](https://www.curseforge.com/wow/addons/elvui-windtools) _(仅限正式服)_

额外支持的插件：
----------------------------

*   [BigWigs](https://www.curseforge.com/wow/addons/big-wigs)
*   [OmniCD - 队伍冷却追踪](https://www.curseforge.com/wow/addons/omnicd)
*   [WarpDeplete (仅限正式服)](https://www.curseforge.com/wow/addons/warpdeplete)
*   [Ratio Minimap Auras](https://www.curseforge.com/wow/addons/elvui-ratiominimapauras)

![安装](https://media.forgecdn.net/attachments/description/676447/description_eef9d427-56cd-4167-a38e-59f260b92ac1.png)

*   备份您的WTF文件夹 _(建议在干净的配置文件上安装ToxiUI)_
*   安装必需的插件
*   进入游戏并确保所有插件正确加载
*   一旦加载角色，ToxiUI安装程序将弹出
*   只需**非常仔细地**按照安装程序的**说明**进行操作
*   如果在任何步骤遇到任何问题，请访问我们的Discord服务器寻求支持！

[![安装视频指南](https://img.youtube.com/vi/C0YpDaEHvWU/maxresdefault.jpg)](https://www.youtube.com/watch?v=C0YpDaEHvWU)

###### 点击上方图片观看视频

 

![致谢](https://media.forgecdn.net/attachments/description/676447/description_d643a212-3ccc-47e5-b892-363771a6ac65.png)
--------------------------------------------------------------------------------------------------------------------------

*   Nawuko 开发了初始的 ToxiUI 代码库
*   Ryada、Wolen 和其他人对项目的持续贡献
*   Hekili 帮助编写了第一个安装程序框架版本
*   Releaf 为那些可爱的 WunderBar 图标
*   v0dKa 在早期阶段的大力支持 - 真正的 MVP
*   Redtuzk 和他的团队提供了灵感
*   ElvUI Discord 提供的持续帮助和支持
*   PayPal 和 Patreon 支持者！你们真棒！

![Discord](https://media.forgecdn.net/attachments/description/676447/description_9d2a48cc-2282-4076-8652-49eb0a8d7f03.png)

*   如果您有任何问题或只是想与我们聊天，请加入我们的[Discord 服务器](https://discord.gg/r85TGUU7zA)

## 如何保持仓库更新
### Windows 操作系统
1. 克隆仓库
2. `git checkout development`
3. 创建一个[符号链接目录连接](https://www.howtogeek.com/howto/16226/complete-guide-to-symbolic-links-symlinks-on-windows-or-linux/)
    1. 以管理员身份打开命令提示符
    2. `mklink /J <新路径> <旧路径>`

#### 示例:
```sh
mklink /J "D:\Games\World of Warcraft\_retail_\Interface\AddOns\ElvUI_ToxiUI\" C:\Users\Toxi\Documents\GitHub\toxiui
```

## 开发工作流程
### 使用 `development` 分支
`stable` 分支应仅在每次大（非测试版）发布时更新，以便我们有一个参考点。

⚠️ **2023-07-15:** 将发布 CI 移动到 `development` 分支。`stable` 将仅用作参考点，但即使如此，考虑到我们现在的提交量，也不确定是否需要。

### 仅限拉取请求
⛔️ 请不要将代码推送到 `stable` 或 `development` 分支，仅使用拉取请求。

### 提交信息
![Emoji Log 扩展](https://i.imgur.com/wfC95MH.png)

我们使用一个名为 **Emoji Log** 的 [VSCode](https://code.visualstudio.com/) 扩展来编写提交信息。
这样可以使 [#📦git-feed](https://discord.com/channels/769550106948141086/797585103278571551) 可读且易于理解。

ℹ️ 包含 `TEST:` 的提交将从 #build-releases 的变更日志中排除

🔗 https://marketplace.visualstudio.com/items?itemName=ahmadawais.emoji-log-vscode

### 代码格式化
请安装 stylua 扩展并设置为保存时格式化

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

## 聊天命令：

### 通用（面向用户）

_前缀: `/tx` `/txui` `/toxi` `/toxiui`_

`/tx` - ElvUI TXUI 选项对话框 _(别名 /tx settings)_<br>
`/tx changelog` - ElvUI TXUI 选项，仅显示更新日志<br>
`/tx wb` - ElvUI TXUI 选项，仅显示 WunderBar<br>
`/tx badge` - 禁用聊天徽章 _(仅在您实际拥有聊天徽章时可能)_<br>
`/tx export names` - 导出所有启用 ElvUI 的角色名称列表<br>
`/tx reset` - 重置所有 TXUI 设置 _(不包括 ElvUI 配置文件，但需要重新安装以重新访问 TXUI 功能)_<br>
`/tx status` - 显示诊断弹出窗口 _(别名 /tx info)_<br>
`/tx install` - 显示 TXUI 安装程序对话框

### 开发部分（或测试版）

`/tx dev profile [dps|healer]` - 安装 ElvUI 配置文件，无需确认<br>
`/tx dev cvar` - 设置默认的 ElvUI Cvars _(+ 个人更改)_<br>
`/tx dev chat` - 安装自定义聊天配置<br>
`/tx dev wb` - 启用 wunderbar 调试模式<br>
`/tx dev splash` - 显示启动画面 15 秒<br>
`/tx dev dpi` - 为您提供缩放的像素完美数字（魔法配置数字 -> 实际数字）

### 仅限开发者

`/tx dev toggle` - 切换开发者模式，激活覆盖<br>

### 导出

`/tx dev export names` - 触发徽章名称的导入（解码）
