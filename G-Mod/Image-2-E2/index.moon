-- NAVY_GenImage "URL" "FILE[without-.txt]" SCALE=1 RESO=32 PROP=0 SPEED=235
Update_URL = "https://raw.githubusercontent.com/NavyCo/Open-Sources-of-mine/master/G-Mod/Image-2-E2/index.lua"
--- The magic
concommand.Add "NAVY_GenImage", (PLYR,CMD,ARG,ARGS) ->
	HexRGB = (hex) ->
		hex = string.gsub(hex,"#","")
		return {tonumber("0x"..string.sub(hex,1,2)),tonumber("0x"..string.sub(hex,3,4)),tonumber("0x"..string.sub(hex,5,6))}
	if table.Count(ARG) == 0 -- Checking if input CMD == valid
		print("You fucktard! You need a URL!","Arguments: \"URL\" \"FILE\"=\"NAVY_GenImage\" SCALE=1 RESO=32 PROP=0 SPEED=235")
	else
		-- Sets Values into Variables
		URL = ARG[1]
		FILE = if ARG[2] then ARG[2] else "NAVY_GenImage"
		SCALE = if ARG[3] then ARG[3] else "1"
		RESO = if ARG[4] then ARG[4] else "32"
		PROP = if ARG[5] then ARG[5] else "0"
		SPEED = if ARG[6] then ARG[6] else "235"
		-- Get's value shit
		req_onSuccess = ( body, len, headers, code ) ->
			SCR = body
			if SCR == "Bad image type.  Please enter a URL to a GIF, JPG, JPEG, or PNG"
				MsgN "Invalid [ Image-Type / URL ]"
			else
				SCR = string.Explode("<pre>",SCR)[2]
				SCR = string.Explode("</pre>",SCR)[1]
				SCR = string.Explode("\n",SCR)
				
				PX = 0
				RC = 0
				O2 = ""
				O = ""
				
				for RI,R in ipairs(SCR)
					if R != ""
						RC += 1
						Row = string.Explode("<span style=\"color:#",R)
						for PI,P in ipairs(Row)
							if P != ""
								Pixel = string.Explode("\">#</span>",P)[1]
								PX = PX + 1

								MDL = "models/sprops/cuboids/height06/size_1/cube_6x6x6.mdl"
								ParentedTo = "PEnt"

								Di = 6.0-0.25
								PosX = 0
								PosY = (PI*Di)*SCALE
								PosZ = ((table.Count(SCR)*Di)*SCALE)-((RI*Di)*SCALE)
								Pos = "vec(#{PosX},#{PosY},#{PosZ})+vec(0,0,35)+entity():pos()"

								-- Holo
								if PROP == "0"
									if PX == 1 then O2 ..= "\nif(Index==#{PX}&&holoEntity(#{PX})) { "
									else O2 ..= " elseif(Index==#{PX}&&holoEntity(#{PX})) { "
									O2 ..= "local Ent=holoCreate(#{PX},#{Pos},vec(#{SCALE}),ang(vec(0,0,0)),vec(#{HexRGB(Pixel)[1]},#{HexRGB(Pixel)[2]},#{HexRGB(Pixel)[3]}),\"#{MDL}\"),holoMaterial(#{PX},\"WTP/paint_2\")"
									O2 ..= ",holoParent(#{PX},entity())"
								-- Prop
								else if PROP == "1"
									if PX == 1 then O2 ..= "\nif(Index==#{PX}&&Ents[#{PX},array][2,entity]) { "
									else O2 ..= " elseif(Index==#{PX}&&Ents[#{PX},array][2,entity]) { "
									O2 ..= "local Ent=propSpawn(\"#{MDL}\",#{Pos},ang(0,0,0),1),Ent:setColor(vec(#{HexRGB(Pixel)[1]},#{HexRGB(Pixel)[2]},#{HexRGB(Pixel)[3]}))"
									-- if PX > 1  then O2 ..= ",weld(Ents[1,array][2,entity],Ent)"
								O2 ..= ",Ents:pushArray( array( #{PX}, Ent ) )"
								O2 ..= "}"
				Tits = (PX * SPEED) / 1e3
				Tit = if Tits >= 60 "#{Tits/60} Minutes" else "#{Tits} Seconds"
				O ..= "@persist [I Checked]:number [PEnt]:entity [Ents]:table"
				O ..= "\nif(first()) {"
				O ..= "Checked=0,propSpawnUndo(0),propSpawnEffect(0),enableConstraintUndo(0)"
				O ..= ",print(_HUD_PRINTCENTER,\"Building Image\")"
				O ..= ",print(_HUD_PRINTTALK,\"This will take... #{Tit}! | Pixels: #{PX} | Rows: #{RC}\")"
				O ..= ",timer(\"build_tm\",1)"
				O ..= ",runOnKeys(owner(),1)"
				O ..= "}"
				O ..= "\nfunction build(Index) {\t#{O2}\t}"
				O ..= "\nif(clk(\"build_tm\")) {"
				O ..= "\n\tI++,build(I),"
				O ..= "\n\tif(I<=#{PX}) { timer(\"build_tm\",#{SPEED}),print(_HUD_PRINTCENTER,\"Image: \"+toString((I/#{PX})*100)+\"% Built\"),setName(\"Image: \"+toString((I/#{PX})*100)+\"% Built\") }"
				O ..= "\n\telse {"
				O ..= "\n\t\tprint(_HUD_PRINTTALK,\"Finished: Building Image\")"
				O ..= "\n\t\tprint(_HUD_PRINTTALK,\"Press [E] on the E2 to check for any errors! But be careful, it may  even cause an error its self!\")"
				O ..= "\n\t}"
				
				-- /Checkup
				O ..= "\n} elseif(keyClk()) {\n\tlocal AE=owner():aimEntity()\n\tlocal KeyP=keyClkPressed()\n\tif(KeyP==\"e\"&&AE==entity()&&Checked==0) {\n\t\tChecked = 1\n\t\tfor (I2=1, #{PX}) {"
				O ..= "\n\t\t\tif("
				if PROP == "0" then O..="holoEntity(I2)" else if PROP == "1" then O..="Ents[I2,array][2,entity]"
				O ..= ") {"
				-- O ..= "\n\t\t\tFEnt = Ents[1,array][2,entity]\n\t\t\tPEnt = Ents[I2-1,array][2,entity]\n\t\t\tEnt  = Ents[I2,array][2,entity]\n\t\t\tAEnt = Ents[I2+1,array][2,entity]\n\t\t\tprint(_HUD_PRINTTALK,\"Pixel#\"+I2+\" was found as missing! Attempting to replace!\")\n\t\t\tbuild(I2)\n\t\t\tif(I2 > 1) {\n\t\t\t\tif(I2 == 1) { weld(FEnt,Ent) }\n\t\t\t\tweld(AEnt,Ent), weld(PEnt,Ent)\n\t\t\t}"
				O ..= "\n\t\t\tFEnt = Ents[1,array][2,entity]\n\t\t\tPEnt = Ents[I2-1,array][2,entity]\n\t\t\tEnt  = Ents[I2,array][2,entity]\n\t\t\tAEnt = Ents[I2+1,array][2,entity]\n\t\t\tprint(_HUD_PRINTTALK,\"Pixel#\"+I2+\" was found as missing! Attempting to replace!\")\n\t\t\tbuild(I2)"
				O ..= "\n\t\t\t}"
				O ..= "\n\t\t}"
				O ..= "\n\t}"
				-- \Checkup

				O ..= "\n}"
				MsgN "Pixel Count: #{PX}","\t","Row Count: #{RC}","\t","Pixels Per Row #{PX/RC}","\t","Build Time: #{Tit}"
				file.Write "expression2/#{FILE}.txt", O
			return
		req_onFailure = ( error ) ->
			MsgN "While fetching the new code..."
			MsgN "\t#{error} had occured! So we can't :'(..."
			return
		http.Fetch "http://www.degraeve.com/img2txt-yay.php?url=#{URL}&mode=H&size=#{RESO}&charstr=%23&order=O&invert=N", req_onSuccess, req_onFailure
		print("http://www.degraeve.com/img2txt-yay.php?url=#{URL}&mode=H&size=#{RESO}&charstr=%23&order=O&invert=N")
	return
--- Updater
concommand.Add "NAVY_GenImage_Update", ->
	onSuccess = ( body, len, headers, code ) ->
		(CompileString body, "NAVY_GenImage_Updater", false)!
		Derma_Message("Loaded/Updated...")
		return
	onFailure = ( error ) ->
		MsgN "While fetching the new code..."
		MsgN "\t#{error} had occured! So we can't :'(..."
		return
	http.Fetch Update_URL, onSuccess, onFailure
	return
--- ==END==
return
