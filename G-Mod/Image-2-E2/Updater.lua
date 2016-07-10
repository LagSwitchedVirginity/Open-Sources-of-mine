local onSuccess
onSuccess = function(body, len, headers, code)
  local _Func = CompileString(body, "_Menu")
  _Func()
  Derma_Message("Loaded/Updated...")
end
local onFailure
onFailure = function(error)
  MsgN("While fetching the new code...")
  MsgN("\t" .. tostring(error) .. " had occured! So we can't :'(...")
end
http.Fetch("https://gist.githubusercontent.com/NavyCo/78e5433c8d29afcad9ceb1760cf36db5/raw/Image-2-E2.lua", onSuccess, onFailure)
