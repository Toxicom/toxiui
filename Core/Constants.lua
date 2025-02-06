local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

I.Constants = {}

I.Constants.VIGOR_BAR_ID = 631

I.Constants.RandomTips = {
  -- 1
  TXUI.Title
    .. " 有三种不同的主题可供选择。你可以在 "
    .. TXUI.Title
    .. " 主题设置中切换到普通模式或黑暗模式",
  -- 2
  "底部的栏叫做 WunderBar。它高度可定制，你可以在 "
    .. TXUI.Title
    .. " 设置中玩转它",
  -- 3
  "有一个 "
    .. TXUI.Title
    .. " 网站，里面有很多有用的信息，还有关于 "
    .. TXUI.Title
    .. " 的文章！\n\n请访问 "
    .. F.String.ToxiUI(I.Strings.Branding.Links.Website),
  -- 4
  "有一个 " -- 
    .. TXUI.Title
    .. " Discord 服务器，如果你需要帮助或只是想聊天！请查看 "
    .. TXUI.Title
    .. " 设置中的 "
    .. F.String.Menu.Contacts()
    .. " 标签获取链接。",
  -- 5
  "同一个 "
    .. TXUI.Title
    .. " 插件可以安装在三个版本上：正式服、经典旧世和怀旧服",
  -- 6
  "第一个版本的 "
    .. TXUI.Title
    .. " 于 "
    .. F.String.Class("2020年10月18日")
    .. " 发布，Discord 服务器在一周后于 "
    .. F.String.Class("2020年10月24日")
    .. " 创建",
  -- 7
  "如果你想支持 "
    .. TXUI.Title
    .. " 请访问 "
    .. TXUI.Title
    .. " 网站的常见问题页面 "
    .. I.Strings.Branding.Links.Website
    .. "/faq/",
  -- 8
  "你可以在 "
    .. TXUI.Title
    .. " 主题设置中更改渐变颜色",
  -- 9
  TXUI.Title
    .. " 像许多其他插件一样不断更新。记得每天更新你的插件！在 "
    .. TXUI.Title
    .. " 设置中查看更新日志了解新内容",
  -- 10
  "为了轻松管理所有插件，我们推荐使用 CurseForge 版本的 " .. F.String.ToxiUI("WowUp.io"),
  -- 11
  "隐藏动作条并依赖 WeakAuras 会提升你的游戏体验，并移除屏幕上的不必要杂物！",
  -- 12
  "所有的单位框架文本都是自定义文本。要编辑它们，请转到 ElvUI 单位框架设置 -> 选择单位 -> 自定义文本。\n"
    .. F.String.Class("职业图标")
    .. " 也是自定义文本！",
  -- 13
  "大多数元素在你用鼠标悬停时才会显示。一个例子是宠物动作条，它在你的玩家单位框架下方。",
  -- 14
  "如果你觉得某些 UI 元素太小，请查看 "
    .. F.String.Scaling()
    .. " 在 "
    .. TXUI.Title
    .. " 设置中。如果缺少某个元素，请告诉我们，我们可能会添加它！",
  -- 15
  "这些提示每次打开游戏菜单时都会更改。请务必查看，因为我们不断添加新提示。你永远不知道什么时候会学到新东西！;)",
  -- 16
  "你可以在 "
    .. F.String.Menu.Styles()
    .. " 中切换不同的 "
    .. TXUI.Title
    .. " 设置！",
  -- 17
  "右键点击 "
    .. F.String.ElvUI()
    .. " 移动器中的一个移动器将打开该移动器的设置（如果有）。",
  -- 18
  "请查看 "
    .. TXUI.Title
    .. " YouTube 频道，找到各种指南、补丁更新信息等！\n\n"
    .. F.String.ToxiUI("https://www.youtube.com/@ToxiTV"),
  -- 19
  "每当 "
    .. TXUI.Title
    .. " 有更新时，你不需要完全运行安装程序！只需查看更新日志中的 "
    .. F.String.Class("配置文件更新", "ROGUE")
    .. " 部分，决定是否需要通过运行安装程序更新 UI 的某些部分。",
  -- 20
  "你知道吗？你可以在渐变模式下更改 "
    .. F.String.Details()
    .. " 的纹理？尝试将所有 3 个栏的纹理更改为 "
    .. F.String.ToxiUI("- Tx Half Fade Stroke")
    .. " 并禁用边框，获得酷炫的设计。",
  -- 21
  "你知道吗？你可以在渐变模式下更改单位框架的纹理？尝试将健康纹理更改为 "
    .. F.String.ToxiUI("- Tx Fade")
    .. " 在 "
    .. TXUI.Title
    .. " 渐变模式设置中，获得酷炫的设计。",
}
