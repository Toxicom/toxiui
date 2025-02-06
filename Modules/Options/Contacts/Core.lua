local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local O = TXUI:GetModule("Options")

function O:Contacts()
  local options = self.options.contacts.args

  -- Reset order for new page
  self:ResetOrder()

  do
    -- ToxiUI Website Group
    local contactsWebsite = self:AddInlineDesc(options, {
      name = "网站",
    }, {
      name = "访问 " .. TXUI.Title .. " 网站以获取更多重要信息！\n\n",
    }).args

    -- ToxiUI Website URL
    contactsWebsite.websiteUrl = {
      order = self:GetOrder(),
      type = "input",
      width = "full",
      name = "",
      get = function()
        return I.Strings.Branding.Links.Website
      end,
    }

    -- Spacer
    self:AddSpacer(contactsWebsite)

    -- ToxiUI Logo
    contactsWebsite.websiteIcon = {
      order = self:GetOrder(),
      type = "description",
      name = "",
      image = function()
        return I.Media.Logos.Logo, F.Dpi(128), F.Dpi(64)
      end,
    }
  end

  -- Spacer
  self:AddTinySpacer(options)

  do
    -- ToxiUI GitHub Group
    local contactsGithub = self:AddInlineDesc(options, {
      name = "GitHub",
    }, {
      name = "访问 " .. TXUI.Title .. " GitHub 仓库以报告错误或获取最新更改！\n\n",
    }).args

    -- ToxiUI Website URL
    contactsGithub.githubUrl = {
      order = self:GetOrder(),
      type = "input",
      width = "full",
      name = "",
      get = function()
        return I.Strings.Branding.Links.Github
      end,
    }

    -- Spacer
    self:AddSpacer(contactsGithub)

    -- ToxiUI Logo
    contactsGithub.githubIcon = {
      order = self:GetOrder(),
      type = "description",
      name = "",
      image = function()
        return I.Media.Logos.Logo, F.Dpi(128), F.Dpi(64)
      end,
    }
  end

  -- Spacer
  self:AddTinySpacer(options)

  do
    -- ToxiUI Discord Group
    local contactsDiscord = self:AddInlineDesc(options, {
      name = "Discord",
    }, {
      name = "加入 " .. TXUI.Title .. " Discord 以获取支持！\n\n",
    }).args

    -- ToxiUI Discord URL
    contactsDiscord.discordUrl = {
      order = self:GetOrder(),
      type = "input",
      width = "full",
      name = "",
      get = function()
        return I.Strings.Branding.Links.Discord
      end,
    }

    -- Spacer
    self:AddSpacer(contactsDiscord)

    -- ToxiUI Discord Logo
    contactsDiscord.discordIcon = {
      order = self:GetOrder(),
      type = "description",
      name = "",
      image = function()
        return I.Media.Logos.Discord, F.Dpi(256), F.Dpi(64)
      end,
    }
  end

  -- Spacer
  self:AddTinySpacer(options)

  do
    -- ToxiUI YouTube Group
    local contactsYoutube = self:AddInlineDesc(options, {
      name = "YouTube",
    }, {
      name = "访问 " .. F.String.ToxiUI("Toxi") .. " 的 YouTube 频道\n\n",
    }).args

    -- ToxiUI YouTube URL
    contactsYoutube.youtubeUrl = {
      order = self:GetOrder(),
      type = "input",
      width = "full",
      name = "",
      get = function()
        return I.Strings.Branding.Links.Youtube
      end,
    }

    -- Spacer
    self:AddSpacer(contactsYoutube)

    -- ToxiUI YouTube Logo
    contactsYoutube.youtubeIcon = {
      order = self:GetOrder(),
      type = "description",
      name = "",
      image = function()
        return I.Media.Logos.Youtube, F.Dpi(256), F.Dpi(64)
      end,
    }
  end
end

O:AddCallback("Contacts")
