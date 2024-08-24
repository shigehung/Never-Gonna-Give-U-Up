--Custom Archtype
if not CustomArchetype then
	CustomArchetype = {}
	local MakeCheck=function(setcodes,archtable,extrafuncs)
	return function(c,sc,sumtype,playerid)
	sumtype=sumtype or 0
			playerid=playerid or PLAYER_NONE
			if extrafuncs then
				for _,func in pairs(extrafuncs) do
					if Card[func](c,sc,sumtype,playerid) then return true end
				end
			end
			if setcodes then
				for _,setcode in pairs(setcodes) do
					if c:IsSetCard(setcode,sc,sumtype,playerid) then return true end
				end
			end
			if archtable then
				if c:IsSummonCode(sc,sumtype,playerid,table.unpack(archtable)) then return true end
			end
			return false
		end
	end
	
	--The Eye of Timaeus (Anime)
	--Legend of Heart (Anime)
	--Timaeus the United Dragon
	--Legendary Knight Timaeus
	--Legendary Knight Timaeus(Anime)
	--Timaeus the Knight of Destiny
	--Timaeus the Knight of Destiny(Anime)
	--The Eye of Timaeus
	CustomArchetype.Timaeus={
	3078380,80019195,170000202,170000152,1784686,611000113
	}
	Card.IsTimaeus=MakeCheck(CustomArchetype.Timaeus)
end