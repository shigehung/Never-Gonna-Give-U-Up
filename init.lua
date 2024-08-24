if not effect_table then
	effect_table={}
end

Card.RegisterEffect=(function()
	local oldf=Card.RegisterEffect
	return function(c,e,forced,...)
		local reg_e=oldf(c,e,forced)
		if not reg_e or reg_e<=0 then return reg_e end
		local code=e:GetCode()
		if not effect_table[code] then
			effect_table[code]={}
		end
		if not effect_table[code][c] then
			effect_table[code][c]={}
		end
		table.insert(effect_table[code][c],e)
		return reg_e
	end
end)()

function Card.GetEffect(c,...)
	local code=... and {...} or nil
	if not code then
		local all_effects={}
		for _,co in pairs(effect_table) do
			if co[c] then
				for _,e in ipairs(co[c]) do
					table.insert(all_effects,e)
				end
			end
		end
		return all_effects
	elseif #code>1 then
		local effects_by_code={}
		for _,co in ipairs(code) do
			if effect_table[co] and effect_table[co][c] then
				for _,e in ipairs(effect_table[co][c]) do
					table.insert(effects_by_code,e)
				end
			end
		end
		return effects_by_code
	else
		code=code[1]
		if effect_table[code] and effect_table[code][c] then
			for _,e in ipairs(effect_table[code][c]) do
				return e
			end
		end
	end
	return nil
end
------------------------------------------------------------------------
function Card.GetLinkedCardsCustom(c)
	local zone = c:GetLinkedZone()
	local p = c:GetControler()
	
	local yg = Duel.GetCardsInZone(zone,p,LOCATION_ONFIELD)
	local og = Duel.GetCardsInZone(zone >> 16,1 - p,LOCATION_ONFIELD)
	
	return yg:Merge(og)
end

function Duel.GetCardsInZone(zone,tp,loc)
	local cards = Group.CreateGroup()
	
	if loc & LOCATION_ONFIELD == 0 then return cards end
	
	if loc & LOCATION_MZONE > 0 then
		local g = Duel.GetMatchingGroup(nil,tp,LOCATION_MZONE,0,nil):ToTable()
		g = Fill(g,7)
		g = SortCards(g, SortBySequence)
		local icheck = 0x1
		for _, card in ipairs(g) do
			
			if zone & icheck ~= 0 and not card.is_dummy then
				cards:AddCard(card)
			end
			icheck = icheck << 1
		end
	end
	
	if loc & LOCATION_SZONE > 0 then
		local g = Duel.GetMatchingGroup(nil,tp,LOCATION_SZONE,0,nil):ToTable()
		g = Fill(g,5)
		g = SortCards(g, SortBySequence)
		local icheck = 0x1 << 8
		for _, card in ipairs(g) do
			if zone & icheck ~= 0 and not card.is_dummy then
				cards:AddCard(card)
			end
			icheck = icheck << 1
		end
	end
	
	return cards
end

function Group.ToTable(g)
	local cards = {}
	for card in g:Iter() do
		table.insert(cards, card)
	end
	
	return cards
end

function SortBySequence(a,b)
	return a:GetSequence() > b:GetSequence()
end

function SortCards(cards,compare)
	local n = #cards
	for i = 1, n - 1 do
		local swapped = false
		for j = 1, n - i do
			if compare(cards[j], cards[j + 1]) then
				cards[j], cards[j + 1] = cards[j + 1], cards[j]
				swapped = true
			end
		end
		
		if not swapped then
			break
		end
	end
	
	return cards
end

function Fill(cards,size)
	local sequences = {}
	for _, card in ipairs(cards) do
		sequences[card:GetSequence()] = true
	end
	
	for i = 0, size - 1 do
		if not sequences[i] then
			local dummy = CreateDummyCard(i)
			table.insert(cards, dummy)
		end
	end
	
	return cards
end

function CreateDummyCard(sequence)
	local dummy = {}
	dummy.sequence = sequence
	dummy.is_dummy = true
	function dummy:GetSequence()
		return self.sequence
	end
	return dummy
end