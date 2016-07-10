local Update_URL = "https://gist.githubusercontent.com/NavyCo/78e5433c8d29afcad9ceb1760cf36db5/raw/Image-2-E2.lua"
concommand.Add("NAVY_GenImage", function(PLYR, CMD, ARG, ARGS)
  local HexRGB
  HexRGB = function(hex)
    hex = string.gsub(hex, "#", "")
    return {
      tonumber("0x" .. string.sub(hex, 1, 2)),
      tonumber("0x" .. string.sub(hex, 3, 4)),
      tonumber("0x" .. string.sub(hex, 5, 6))
    }
  end
  if table.Count(ARG) == 0 then
    print("You fucktard! You need a URL!", "Arguments: \"URL\" \"FILE\"=\"NAVY_GenImage\" SCALE=1 RESO=32 PROP=0 SPEED=235")
  else
    local URL = ARG[1]
    local FILE
    if ARG[2] then
      FILE = ARG[2]
    else
      FILE = "NAVY_GenImage"
    end
    local SCALE
    if ARG[3] then
      SCALE = ARG[3]
    else
      SCALE = "1"
    end
    local RESO
    if ARG[4] then
      RESO = ARG[4]
    else
      RESO = "32"
    end
    local PROP
    if ARG[5] then
      PROP = ARG[5]
    else
      PROP = "0"
    end
    local SPEED
    if ARG[6] then
      SPEED = ARG[6]
    else
      SPEED = "235"
    end
    local req_onSuccess
    req_onSuccess = function(body, len, headers, code)
      local SCR = body
      if SCR == "Bad image type.  Please enter a URL to a GIF, JPG, JPEG, or PNG" then
        MsgN("Invalid [ Image-Type / URL ]")
      else
        SCR = string.Explode("<pre>", SCR)[2]
        SCR = string.Explode("</pre>", SCR)[1]
        SCR = string.Explode("\n", SCR)
        local PX = 0
        local RC = 0
        local O2 = ""
        local O = ""
        for RI, R in ipairs(SCR) do
          if R ~= "" then
            RC = RC + 1
            local Row = string.Explode("<span style=\"color:#", R)
            for PI, P in ipairs(Row) do
              if P ~= "" then
                local Pixel = string.Explode("\">#</span>", P)[1]
                PX = PX + 1
                local MDL = "models/sprops/cuboids/height06/size_1/cube_6x6x6.mdl"
                local ParentedTo = "PEnt"
                local Di = 6.0 - 0.25
                local PosX = 0
                local PosY = (PI * Di) * SCALE
                local PosZ = ((table.Count(SCR) * Di) * SCALE) - ((RI * Di) * SCALE)
                local Pos = "vec(" .. tostring(PosX) .. "," .. tostring(PosY) .. "," .. tostring(PosZ) .. ")+vec(0,0,35)+entity():pos()"
                if PROP == "0" then
                  if PX == 1 then
                    O2 = O2 .. "\nif(Index==" .. tostring(PX) .. "&&holoEntity(" .. tostring(PX) .. "):model()==\"\") { "
                  else
                    O2 = O2 .. " elseif(Index==" .. tostring(PX) .. "&&holoEntity(" .. tostring(PX) .. "):model()==\"\") { "
                  end
                  O2 = O2 .. "local Ent=holoCreate(" .. tostring(PX) .. "," .. tostring(Pos) .. ",vec(" .. tostring(SCALE) .. "),ang(vec(0,0,0)),vec(" .. tostring(HexRGB(Pixel)[1]) .. "," .. tostring(HexRGB(Pixel)[2]) .. "," .. tostring(HexRGB(Pixel)[3]) .. "),\"" .. tostring(MDL) .. "\"),holoMaterial(" .. tostring(PX) .. ",\"WTP/paint_2\")"
                  O2 = O2 .. ",holoParent(" .. tostring(PX) .. ",entity())"
                else
                  if PROP == "1" then
                    if PX == 1 then
                      O2 = O2 .. "\nif(Index==" .. tostring(PX) .. "&&Ents[" .. tostring(PX) .. ",array][2,entity]:model()==\"\") { "
                    else
                      O2 = O2 .. " elseif(Index==" .. tostring(PX) .. "&&Ents[" .. tostring(PX) .. ",array][2,entity]:model()==\"\") { "
                    end
                    O2 = O2 .. "local Ent=propSpawn(\"" .. tostring(MDL) .. "\"," .. tostring(Pos) .. ",ang(0,0,0),1),Ent:setColor(vec(" .. tostring(HexRGB(Pixel)[1]) .. "," .. tostring(HexRGB(Pixel)[2]) .. "," .. tostring(HexRGB(Pixel)[3]) .. "))"
                  end
                end
                O2 = O2 .. ",Ents:pushArray( array( " .. tostring(PX) .. ", Ent ) )"
                O2 = O2 .. "}"
              end
            end
          end
        end
        local Tits = (PX * SPEED) / 1e3
        local Tit = ((function()
          if Tits >= 60 then
            return tostring(Tits / 60) .. " Minutes"
          else
            return tostring(Tits) .. " Seconds"
          end
        end)())
        O = O .. "@persist [I Checked]:number [PEnt]:entity [Ents]:table"
        O = O .. "\nif(first()) {"
        O = O .. "Checked=0,propSpawnUndo(0),propSpawnEffect(0),enableConstraintUndo(0)"
        O = O .. ",print(_HUD_PRINTCENTER,\"Building Image\")"
        O = O .. ",print(_HUD_PRINTTALK,\"This will take... " .. tostring(Tit) .. "! | Pixels: " .. tostring(PX) .. " | Rows: " .. tostring(RC) .. "\")"
        O = O .. ",timer(\"build_tm\",1)"
        O = O .. ",runOnKeys(owner(),1)"
        O = O .. "}"
        O = O .. "\nfunction build(Index) {\t" .. tostring(O2) .. "\t}"
        O = O .. "\nif(clk(\"build_tm\")) {"
        O = O .. "\n\tI++,build(I),"
        O = O .. "\n\tif(I<=" .. tostring(PX) .. ") { timer(\"build_tm\"," .. tostring(SPEED) .. "),print(_HUD_PRINTCENTER,\"Image: \"+toString((I/" .. tostring(PX) .. ")*100)+\"% Built\"),setName(\"Image: \"+toString((I/" .. tostring(PX) .. ")*100)+\"% Built\") }"
        O = O .. "\n\telse {"
        O = O .. "\n\t\tprint(_HUD_PRINTTALK,\"Finished: Building Image\")"
        O = O .. "\n\t\tsetName(\"Press [E] to check for any errors! But be careful, it may cause an error!\")"
        O = O .. "\n\t}"
        O = O .. "\n} elseif(keyClk()) {\n\tlocal AE=owner():aimEntity()\n\tlocal KeyP=keyClkPressed()\n\tif(KeyP==\"e\"&&AE==entity()&&Checked==0) {\n\t\tChecked = 1\n\t\tfor (I2=1, " .. tostring(PX) .. ") {"
        O = O .. "\n\t\t\tif("
        if PROP == "0" then
          O = O .. "holoEntity(I2):model()==\"\")"
        else
          if PROP == "1" then
            O = O .. "Ents[I2,array][2,entity]:model()==\"\""
          end
        end
        O = O .. ") {"
        O = O .. "\n\t\t\tFEnt = Ents[1,array][2,entity]\n\t\t\tPEnt = Ents[I2-1,array][2,entity]\n\t\t\tEnt  = Ents[I2,array][2,entity]\n\t\t\tAEnt = Ents[I2+1,array][2,entity]\n\t\t\tprint(_HUD_PRINTTALK,\"Pixel#\"+I2+\" was found as missing! Attempting to replace!\")\n\t\t\tbuild(I2)"
        O = O .. "\n\t\t\t}"
        O = O .. "\n\t\t}"
        O = O .. "\n\t}"
        O = O .. "\n}"
        MsgN("Pixel Count: " .. tostring(PX), "\t", "Row Count: " .. tostring(RC), "\t", "Pixels Per Row " .. tostring(PX / RC), "\t", "Build Time: " .. tostring(Tit))
        file.Write("expression2/" .. tostring(FILE) .. ".txt", O)
      end
    end
    local req_onFailure
    req_onFailure = function(error)
      MsgN("While fetching the new code...")
      MsgN("\t" .. tostring(error) .. " had occured! So we can't :'(...")
    end
    http.Fetch("http://www.degraeve.com/img2txt-yay.php?url=" .. tostring(URL) .. "&mode=H&size=" .. tostring(RESO) .. "&charstr=%23&order=O&invert=N", req_onSuccess, req_onFailure)
    print("http://www.degraeve.com/img2txt-yay.php?url=" .. tostring(URL) .. "&mode=H&size=" .. tostring(RESO) .. "&charstr=%23&order=O&invert=N")
  end
end)
concommand.Add("NAVY_GenImage_Update", function()
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
  http.Fetch(Update_URL, onSuccess, onFailure)
end)
