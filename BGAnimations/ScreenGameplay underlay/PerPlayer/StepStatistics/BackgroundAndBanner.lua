local player = ...

local af = Def.ActorFrame{}

af[#af+1] = Def.Quad{
	InitCommand=function(self)
		self:diffuse(Color.Black)
			:zoomto(_screen.w/2,_screen.h)

		if ThemePrefs.Get("TransparentStats") then
			self:diffusealpha(0.0)
		else
			self:diffusealpha(0.95)
		end

		if (PREFSMAN:GetPreference("Center1Player") and IsUsingWideScreen()) then
			-- 16:9 aspect ratio (approximately 1.7778)
			if GetScreenAspectRatio() > 1.7 then
				self:xy(44 * (player==PLAYER_1 and 1 or -1), -20)

			-- if 16:10 aspect ratio
			else
				self:zoomto(_screen.w/2, _screen.h * 1.015)
				self:xy(36 * (player==PLAYER_1 and 1 or -1), -50)
			end
		end

		if SL.Global.GameMode == "StomperZ" then
			self:y(-40)
		end
	end
}

af[#af+1] = Def.Banner{
	InitCommand=function(self)
		self:LoadFromSong( GAMESTATE:GetCurrentSong() )
			:setsize(418,164)
			:zoom(0.4)
			:xy(-70, -200)
	end
}

return af
