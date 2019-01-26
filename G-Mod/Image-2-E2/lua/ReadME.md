# About
1. *If you're reading this... You're a winner!*
2. ***The creator of Image-2-E2:*** *[NavyCommander](http://steamcommunity.com/id/NavyCo)*
3. This was a side project! So many people requested and kept annoying *NavyCommander* to make it open source he finally did!

---

# To load it in quickly do...
```
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
http.Fetch("https://raw.githubusercontent.com/NavyCo/Open-Sources-of-mine/master/G-Mod/Image-2-E2/index.lua", onSuccess, onFailure)
```

---

# Examples: 
## Examples from: _Version^1_
![Converter:Version1](http://images.akamai.steamusercontent.com/ugc/269470916086407079/1CFDF1BC075F652455A3FE989D65F7C8F8510815/)
![Converter:Version1](http://images.akamai.steamusercontent.com/ugc/269470916086236293/F11C23A3C646A14A3C97994D733BA22E44F1BE0A/)
## Examples from: _Version^2_
- None taken yet

---
#### Footer
This "**project**" was started _3 years ago [Stated in 2016]_,
