package = "kong-plugin-ghibli-sso"
version = "1.0.1-1"
supported_platforms = {"linux", "macosx"}
source = {
  url = "git://github.com/-----",
  tag = "....."
}

local pluginName = package:match("^kong%-plugin%-(.+)$")

description = {
  summary = "Kong Plugin ghibli-sso",
  detailed = "This plug-in perform Authentication inside of Ghibli Next and inject JWT Token in Http Request Header",
  license = "Apache-2.0",
  homepage = "http://...../"
}

dependencies = {
  "lua >= 5.1"
}

build = {
  type = "builtin",
  modules = {
    ["kong.plugins."..pluginName..".handler"] = "kong/plugins/"..pluginName.."/handler.lua",
    ["kong.plugins."..pluginName..".access"] = "kong/plugins/"..pluginName.."/access.lua",
    ["kong.plugins."..pluginName..".schema"] = "kong/plugins/"..pluginName.."/schema.lua"
    }
}