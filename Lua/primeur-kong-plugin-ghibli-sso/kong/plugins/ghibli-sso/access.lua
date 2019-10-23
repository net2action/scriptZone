local _M = {}


function _M.execute(conf)

  local weburl= nil
  local gnAuth = nil
  local where = nil
  local http = require "socket.http"
  local ltn12 = require "ltn12"
  local json = require("JSON")
  
 if conf.debug then
        ngx.log(ngx.DEBUG,"-PRM -----> uri request = "..ngx.var.request_uri)
        
    end 

  local token = nil
  
   -- check if already authanticated, if no, perform authentication and inject token in request header
   gnAuth = ngx.var.http_authorization
   if gnAuth ==  nil then
   
    weburl=conf.weburl
    request_body = "username="..conf.username.."&password="..conf.password
    response_body = {}

    local res, code, response_headers = http.request{
        url = weburl,
        method = "POST", 
        headers = 
          {
              ["Accept"] = "application/json";
              ["Content-Type"] = "application/json";
              ["Content-Length"] = #request_body;
          },
          source = ltn12.source.string(request_body),
          sink = ltn12.sink.table(response_body),
    }
    if conf.debug then
        ngx.log(ngx.DEBUG,"-PRM ----->"..res)
        ngx.log(ngx.DEBUG,"-PRM -----> HTTP Reslut Code: "..code)
    end    
    if type(response_headers) == "table" then
      for k, v in pairs(response_headers) do 
        print(k, v)
      end
    end
 
    -- extract Json from ReponseBody
    for key, value in pairs(response_body) do
        token = value
    end
    -- inject Authorization into Request Headers
    ngx.req.set_header("Authorization", json:decode(token).token_type.." "..json:decode(token).access_token)
    myJWT=json:decode(token).token_type.." "..json:decode(token).access_token
    
     if conf.debug then
      ngx.log(ngx.DEBUG,"-PRM -----> result JWT="..json:decode(token).access_token)
      ngx.log(ngx.DEBUG,"-PRM -----> Headers")
      ngx.log(ngx.DEBUG,table.concat(ngx.header))
    end    
  else
      if conf.debug then
        ngx.log(DEBUG,"-PRM -----> ============ AuthGhibli! ============")
        ngx.header["AuthGhibli"] = "Autenticated"
      end  
  end
end

return _M