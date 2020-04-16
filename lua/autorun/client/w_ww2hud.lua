WW2_HUD = { };

local wi = ScrW()
local he = ScrH()

local string = string
local surface = surface
local math = math
local Color = Color
local tostring = tostring
local hediv = he/116
local widiv = wi/32
 
local function clr( color ) return color.r, color.g, color.b, color.a; end

local configranks = {

	["vip"] = "icon16/user.png",
	["vipplus"] = "icon16/user_add.png",
	["vipultimate"] = "icon16/user_orange.png",
	["enforcer"] = "icon16/award_star_bronze_1.png",
	["moderator"] = "icon16/award_star_silver_1.png",
	["admin"] = "icon16/award_star_add.png",
	["superadmin"] = "icon16/shield.png",
	["headadmin"] = "icon16/shield_add.png",
	["networkmanager"] = "icon16/application_osx_terminal.png"
	

}

surface.CreateFont( "W_HUD_L", {
	font = "Blockletter", 
	extended = false,
	size = ScreenScale( 16 ),
	weight = 50,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
} ) 

surface.CreateFont( "W_HUD_XL", {
	font = "Blockletter", 
	extended = false,
	size = ScreenScale( 55 ),
	weight = 50,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
} ) 


surface.CreateFont( "W_HUD_M", {
	font = "Blockletter", 
	extended = false,
	size = ScreenScale( 9 ),
	weight = 100,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
} ) 
surface.CreateFont( "W_HUD_S", {
	font = "Blockletter", 
	extended = false,
	size = ScreenScale( 5 ),
	weight = 300,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
} ) 

function draw.OutlinedBox( x, y, w, h, thickness, clr )
	surface.SetDrawColor( clr )
	for i=0, thickness - 1 do
		surface.DrawOutlinedRect( x + i, y + i, w - i * 2, h - i * 2 )
	end
end

local blur = Material( "pp/blurscreen" )

local function drawBlur( x, y, w, h, layers, density, alpha )

	surface.SetDrawColor( 0, 0, 200, 255 )

	
	surface.SetMaterial( blur )



	for i = 1, layers do

		blur:SetFloat( "$blur", ( i / layers ) * density )

		blur:Recompute()



		render.UpdateScreenEffectTexture()

		render.SetScissorRect( x, y, x + w, y + h, true )

			surface.DrawTexturedRect( 0, 0, wi, he )

		render.SetScissorRect( 0, 0, 0, 0, false )

	end

end

local color_white = color_white
local avatar = avatar or nil
local smoothhealth = 0
local smootharmor = 0
local smoothhunger = 0
local barpos = (wi/4.5)
local indent = wi/2.5
local backcol = Color(52, 152, 255,20)
local backcol2 = Color(10,10,10,150)
hook.Add("InitPostEntity", "W_HUDLoad", function()
local client = LocalPlayer()
local function W_HudPaint()

	local hp = math.Clamp(LocalPlayer():Health(), 0, 100)	-- clamps the health to [0, 100] meaning it will not go above 100 or below 0
	
	if not avatar then 
		avatar = vgui.Create( "AvatarImage", Panel )
		avatar:SetSize( 64, 64 )
		avatar:SetPos( wi/2.9, he/1.065 )
		avatar:SetPlayer( LocalPlayer(), 64 )
		print("a")
		
	end
	
	local armor = math.Clamp(LocalPlayer():Armor(), 0, 255)
	
	local hunger = math.Clamp( LocalPlayer():getDarkRPVar("Energy") or 0, 0, 100)
	
	smoothhealth = math.Approach(smoothhealth, hp, 100*FrameTime())
	smootharmor = math.Approach(smootharmor, armor ,100*FrameTime())
	smoothhunger = math.Approach(smoothhunger, hunger ,100*FrameTime())
	
	local equationhealth = barpos*(smoothhealth/100)
	local equationarmor = barpos*(smootharmor/255)
	local equationhunger = barpos*(smoothhunger/100)
	-- HUD Basic Design
	
	drawBlur(wi/3, he-he/14, wi/3, he/14, 3, 6, 255 )
	draw.RoundedBox( 4, wi/3, he-he/14, wi/3, he/14, backcol )
	
	--draw.OutlinedBox( 0, he-he/7.5, wi/5, he/7.5,1.5, Color(225,225,255,225) )
	
	-- Main Details
	draw.SimpleText(client:Nick(), "W_HUD_L", wi/2.4, he/1.07, color_white)
	draw.SimpleText("   " .. client.DarkRPVars.job or "Loading", "W_HUD_M", wi/1.51, he/1.07, color_white, TEXT_ALIGN_RIGHT)
	draw.SimpleText("   "   ..   DarkRP.formatMoney(client.DarkRPVars.money), "W_HUD_M", wi/1.51, he/1.053, Color(218,165,32), TEXT_ALIGN_RIGHT)
	surface.SetDrawColor(color_white)
	surface.DrawLine(wi/2.55,he-he/14,wi/2.55,he)
	surface.SetMaterial(Material(configranks[LocalPlayer():GetUserGroup()] or "icon16/shield.png"))
	surface.DrawTexturedRect(indent, he/1.06, 26, 24)
	--draw.SimpleText(, "W_HUD_M", 13, (he/1.13+he/40))
	--team.GetColor(LocalPlayer():Team())
--	draw.SimpleText(DarkRP.formatMoney(client.DarkRPVars.money), "W_HUD_M", 13, (he/1.13+he/32*2))
	---------------------------------------------------------------------------------------
	-- Health bar and Icon
	---------------------------------------------------------------------------------------

	draw.RoundedBox( 0, indent-1, (he/1.03)-1, barpos+2, he/80+2, backcol )
	draw.RoundedBox( 0, indent, (he/1.03), equationhealth, he/80, Color(200,0,0) )
	
	draw.SimpleText(client:Health(), "W_HUD_S", indent+(wi/4.5/2), (he/1.033))
	---------------------------------------------------------------------------------------
	-- Armor bar and Icon surface.DrawRect(14, (he/1.13+he/32*3.05)+1, 16, 16)
	---------------------------------------------------------------------------------------
	surface.SetDrawColor(color_white)
--	surface.SetMaterial(Material("shield.png"))
	--surface.DrawTexturedRect(18, he/1.03, 18, 20)
	draw.RoundedBox( 0, indent-1, (he/1.014)-1 , barpos+2, he/80+2, backcol )
	draw.RoundedBox( 0, indent, (he/1.014) , equationarmor, he/80, Color(0,200,200) )
	draw.SimpleText(client:Armor(), "W_HUD_S", indent+(wi/4.5/2), (he/1.0152))
	--------------------------------------------------------------------------------------- Color(52, 146, 235)
end


hook.Add("HUDPaint", "W_HudPaint", W_HudPaint)
end)
local hide = {

	["CHudAmmo"] = false,
	["CHudSecondaryAmmo"] = false,


	["CHudHealth"] = true,
	["CHudBattery"] = true,
	["DarkRP_LocalPlayerHUD"] = true,
	
}

local function DisplayNotify(msg)
    local txt = msg:ReadString()
    GAMEMODE:AddNotify(txt, msg:ReadShort(), msg:ReadLong())
    surface.PlaySound("buttons/lightswitch2.wav")

    MsgC(Color(255, 20, 20, 255), "[RoleplayRP] ", Color(200, 200, 200, 255), txt, "\n")
end
usermessage.Hook("_Notify", DisplayNotify)

hook.Add( "HUDShouldDraw", "HideHUD", function( name )
	if ( hide[ name ] ) then return false end

end )

RunConsoleCommand( "hud_quickinfo" , "0" )

AddCSLuaFile()