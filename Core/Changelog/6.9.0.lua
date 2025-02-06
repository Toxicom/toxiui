local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

TXUI.Changelog["6.9.0"] = {
  HOTFIX = true,
  CHANGES = {
    "* 重大变更",
    "更改所有 " .. TXUI.Title .. " 使用的自定义文本的名称" .. F.String.Sublist("我们进行了自动数据库转换，因此不应出现任何问题"),
    "如果由于某些自定义文本未正确转换而遇到问题，请按照以下步骤操作:"
      .. F.String.Sublist("退出你的角色")
      .. F.String.Sublist("在你的魔兽世界目录中打开此文件: WTF/Account/<ACCOUNT_ID>/SavedVariables/ElvUI.lua")
      .. F.String.Sublist("找到一行写着 " .. F.String.ToxiUI("[\"lastDBConversion\"] = \"6.9.0\""))
      .. F.String.Sublist("将 6.9.0 更改为 6.8.8")
      .. F.String.Sublist("保存文件并重新登录你的角色")
      .. F.String.Sublist("这应该会再次触发数据库转换"),
    "移除 "
      .. F.String.ToxiUI("- Steelfish")
      .. " 字体" -- 
      .. F.String.Sublist("自 6.3.0 以来我们就没有使用过该字体")
      .. F.String.Sublist("如果你仍在使用它，请通过 SharedMedia 自行添加"),
    "从我们的字体中移除韩文字形" -- 
      .. F.String.Sublist("这是我考虑了很久的决定，对不起韩国玩家")
      .. F.String.Sublist("韩文字形使字体文件变得巨大，严重影响了加载时间")
      .. F.String.Sublist("你可以在 GitHub 上找到旧的字体文件"),
    "在 " .. TXUI.Title .. " 安装程序期间，不再在经典时代版本中设置 " .. F.String.ToxiUI("经典动作条样式") .. "，因为 Luxthos 现在有 WeakAuras",

    "* 新功能",
    "游戏菜单皮肤中的收藏" .. F.String.Sublist("仅限正式服"),
    "更新 "
      .. F.String.Plater()
      .. " 设计" -- 
      .. F.String.Sublist("减少生命条和施法条的高度")
      .. F.String.Sublist("将字体更改为 ToxiUI")
      .. F.String.Sublist("减少生命字体大小")
      .. F.String.Sublist("减少悬停目标透明度")
      .. F.String.Sublist("更改条纹纹理")
      .. F.String.Sublist("为友方玩家姓名板启用公会名称")
      .. F.String.Sublist("修复缩放问题"),

    "* 配置文件更新",
    F.String.Plater() .. ": 添加 " .. F.String.Class("野性射击", "HUNTER") .. " 到手动增益追踪",
    F.String.Plater() .. ": 添加 " .. F.String.Class("爆炸射击", "HUNTER") .. " 到手动增益追踪",
    F.String.ElvUI() .. ": 使萨满在经典时代中显示为蓝色",

    "* 文档",
    "更新 " .. TXUI.Title .. " WeakAuras 指南的链接",
    "更新至补丁 11.0.7",
    "更新至补丁 4.4.1",
    "更新至补丁 1.15.6",
    F.String.MinElv("13.83"),

    "* 设置重构",
    "允许渐变模式的背景亮度降至 0",
    "在经典时代的安装程序中添加 " .. F.String.Luxthos() .. " WeakAuras 的链接",
  },
}
