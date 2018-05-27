local optionrow_mt = {
	__index = {
		create_actors = function(self, name)
			self.name=name

			-- this is a terrible way to do this
			local item_index = name:gsub("item", "")
			self.index = item_index

			local af = Def.ActorFrame{
				Name=name,
				InitCommand=function(subself)
					self.container = subself
					subself:diffusealpha(0):queuecommand("Hide2")
				end,
				OnCommand=cmd(y, item_index * 62),

				HideCommand=cmd( linear, 0.2; diffusealpha, 0; queuecommand, "Hide2"),
				Hide2Command=function(self) self:visible(false) end,
				UnhideCommand=function(self) self:visible(true):queuecommand("Unhide2") end,
				Unhide2Command=cmd( sleep, 0.3; linear, 0.2; diffusealpha, 1),


				-- helptext
				Def.BitmapText{
					Font="_miso",
					InitCommand=function(subself)
						self.helptext = subself
						subself:horizalign(left):zoom(0.9)
							:diffuse(ThemePrefs.Get("RainbowMode") and Color.White or Color.Black):diffusealpha(0)
					end,
					OnCommand=cmd(sleep, 0.13; linear, 0.05; ),
					GainFocusCommand=cmd(diffusealpha, 0.85 ),
					LoseFocusCommand=cmd(diffusealpha, 0.5 )
				},

				-- bg quad
				Def.Quad{
					InitCommand=function(subself)
						self.bgQuad = subself
						subself:horizalign(left):zoomto(200, 28):diffuse(Color.White):diffusealpha(0)
					end,
					OnCommand=cmd(y, 26),
					GainFocusCommand=cmd(diffusealpha, 1),
					LoseFocusCommand=cmd(diffusealpha, 0.5),
				},

				Def.ActorFrame{
					Name="Cursor",
					InitCommand=function(subself) self.cursor = subself end,
					OnCommand=function(self) self:y(26) end,
					LoseFocusCommand=cmd(diffusealpha, 0),
					GainFocusCommand=cmd(diffusealpha, 1),

					-- right arrow
					Def.ActorFrame{
						Name="RightArrow",
						OnCommand=cmd(x, 216),
						PressCommand=cmd(decelerate,0.05; zoom,0.7; glow,color("#ffffff22"); accelerate,0.05; zoom,1; glow, color("#ffffff00");),
						ExitRowCommand=function(self, params)
							self:y(-15)
							if params.PlayerNumber == PLAYER_2 then
								self:x(20)
							end
						end,
						SingleSongCanceledMessageCommand=cmd(rotationz, 0),
						BothPlayersAreReadyMessageCommand=cmd(sleep,0.2; linear,0.2; rotationz, 180),

						LoadActor("./img/arrow_glow.png")..{
							Name="RightArrowGlow",
							InitCommand=cmd(zoom,0.15),
							OnCommand=function(subself)
								subself:diffuseshift()
								if ThemePrefs.Get("RainbowMode") then
									subself:effectcolor1(1,1,1,0):effectcolor2(1,1,1,1)
								else
									subself:effectcolor1(0,0,0,0):effectcolor2(0,0,0,1)
								end
							end
						},
						LoadActor("./img/arrow.png")..{
							Name="RightArrow",
							InitCommand=cmd(zoom,0.15; diffuse, ThemePrefs.Get("RainbowMode") and Color.White or Color.Black ),
						}
					},

					-- left arrow
					Def.ActorFrame{
						Name="LeftArrow",
						OnCommand=cmd(x, -16),
						PressCommand=cmd(decelerate,0.05; zoom,0.7; glow,color("#ffffff22"); accelerate,0.05; zoom,1; glow, color("#ffffff00")),
						ExitRowCommand=function(self, params)
							self:y(-15)
							if params.PlayerNumber == PLAYER_1 then self:x(180) end
						end,
						SingleSongCanceledMessageCommand=cmd(rotationz, 0),
						BothPlayersAreReadyMessageCommand=cmd(sleep,0.2;linear,0.2; rotationz, 180),

						LoadActor("./img/arrow_glow.png")..{
							Name="LeftArrowGlow",
							InitCommand=cmd(zoom,0.15; rotationz, 180),
							OnCommand=function(subself)
								subself:diffuseshift()
								if ThemePrefs.Get("RainbowMode") then
									subself:effectcolor1(1,1,1,0):effectcolor2(1,1,1,1)
								else
									subself:effectcolor1(0,0,0,0):effectcolor2(0,0,0,1)
								end
							end
						},
						LoadActor("./img/arrow.png")..{
							Name="LeftArrow",
							InitCommand=cmd(zoom,0.15; diffuse, ThemePrefs.Get("RainbowMode") and Color.White or Color.Black; rotationz, 180),

						}
					}
				}
			}

			return af
		end,

		transform = function(self, item_index, num_items, has_focus)

			self.container:finishtweening()

			if has_focus then
				self.container:playcommand("GainFocus")
			else
				self.container:playcommand("LoseFocus")
			end
		end,

		set = function(self, optionrow)
			if not optionrow then return end
			self.helptext:settext( optionrow.helptext )
			if optionrow.helptext == "" then
				self.bgQuad:visible(false)
			end
		end
	}
}

return optionrow_mt