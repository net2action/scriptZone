return {
  no_consumer = false, 
  description = "this plug-in perform Authentication and inject JWT Token in Http Request Header, using following credential", 
  fields = {
            debug  =  {type = "boolean", default = false},
            weburl = { type = "string", required = true},
            username = { type = "string", required = true},
            password = { type = "string", required = true}
  }
}