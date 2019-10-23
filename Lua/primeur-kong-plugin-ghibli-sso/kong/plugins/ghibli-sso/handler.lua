local BasePlugin = require "kong.plugins.base_plugin"
local access = require "kong.plugins.ghibli-sso.access"


local GhibliHandler = BasePlugin:extend()

myJWT = nil

GhibliHandler.VERSION  = "1.0.0"
GhibliHandler.PRIORITY = 10





function GhibliHandler:new()
  GhibliHandler.super.new(self, "ghibli-sso")
  
end


function GhibliHandler:access(conf)

  local gnAuth = nil
  
  
  GhibliHandler.super.access(self)
  
  gnAuth = ngx.var.http_authorization
  if gnAuth ==  nil then
      if conf.debug then
         ngx.log(ngx.DEBUG,"-PRM -----> =AuthGhibli============> NOT Autenticated")
         ngx.header["AuthGhibli"] = "NOT Autenticated"
      end   
      access.execute(conf)
     
  else
      if conf.debug then
         ngx.log(ngx.DEBUG,"-PRM -----> =AuthGhibli============> Autenticated")
         ngx.header["AuthGhibli"] = "Autenticated"
      end   
  end 
  
   if conf.debug then
      ngx.log(ngx.DEBUG,"-PRM -----> current JWT :"..myJWT)
   end
    
end


return GhibliHandler