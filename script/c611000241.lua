--Magician's Ladder
local s,id=GetID()
function s.initial_effect(c)
	--c:EnableReviveLimit()
	--Fusion Summon
	local params = {nil,matfilter=s.matfilter,extrafil=s.fextra,extraop=s.extraop,extratg=s.extratg}
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(2,{id,1})
	e1:SetTarget(Fusion.SummonEffTG(params))
	e1:SetOperation(Fusion.SummonEffOP(params))
	c:RegisterEffect(e1)
	--Non-Fusion Summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,2))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(2,{id,2})
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
end
s.listed_series={0x40a2}
s.listed_names={611000506}
--Fusion Summon
function s.matfilter(c)
	return (c:IsLocation(LOCATION_HAND+LOCATION_ONFIELD) and c:IsAbleToGrave()) or (c:IsLocation(LOCATION_GRAVE) and c:IsAbleToRemove()) or (c:IsLocation(LOCATION_REMOVED) and c:IsAbleToDeck())
end
function s.checkmat(tp,sg,fc)
	return ((fc:IsAttribute(ATTRIBUTE_LIGHT|ATTRIBUTE_DARK) and fc:IsRace(RACE_SPELLCASTER))
		or (fc:IsAttribute(ATTRIBUTE_DARK) and fc:IsRace(RACE_DRAGON)))
		or not sg:IsExists(Card.IsLocation,1,nil,LOCATION_GRAVE|LOCATION_REMOVED)
end
function s.fmfilter(c)
	return (c:IsMonster() and c:IsFaceup() and c:IsAbleToDeck() and c:IsLocation(LOCATION_REMOVED))
		or (c:IsMonster() and c:IsAbleToRemove() and c:IsLocation(LOCATION_GRAVE))
end
function s.fextra(e,tp,mg)
	if not Duel.IsPlayerAffectedByEffect(tp,CARD_SPIRIT_ELIMINATION) then
		return Duel.GetMatchingGroup(aux.NecroValleyFilter(Fusion.IsMonsterFilter(s.fmfilter)),tp,LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_GRAVE+LOCATION_REMOVED,nil),s.checkmat
	end
	return nil,s.checkmat
end
function s.extraop(e,tc,tp,sg)
	local rg1=sg:Filter(Card.IsLocation,nil,LOCATION_GRAVE)
	local rg2=sg:Filter(Card.IsLocation,nil,LOCATION_REMOVED)
	if #rg1>0 then
		Duel.Remove(rg1,POS_FACEUP,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
		sg:Sub(rg1)
	end
	if #rg2>0 then
		Duel.SendtoDeck(rg2,nil,2,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
		sg:Sub(rg2)
	end
end
function s.extratg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetPossibleOperationInfo(0,CATEGORY_REMOVE,nil,0,PLAYER_EITHER,LOCATION_GRAVE)
	Duel.SetPossibleOperationInfo(0,CATEGORY_TODECK,nil,0,PLAYER_EITHER,LOCATION_REMOVED)
end
--Overwrite "Duel.SendtoGrave" function to handle the custom material operations.
local gfunc=Duel.SendtoGrave
function Duel.SendtoGrave(c_g,reason,tp,rp)
	if reason&REASON_MATERIAL==0 or reason&(REASON_SYNCHRO|REASON_LINK)==0 then return gfunc(c_g,reason,tp,rp) end
	local function locfilter(c,loc)
		return c:GetFlagEffectLabel(id) and (c:GetFlagEffectLabel(id)&loc)~=0
	end
	local cg = type(c_g)=='Group' and c_g or Group.FromCards(c_g)
	local custom_g,g=cg:Split(locfilter,nil,LOCATION_GRAVE|LOCATION_REMOVED)
	local g1,g2=custom_g:Split(locfilter,nil,LOCATION_REMOVED)
	if #g1>0 then Duel.SendtoDeck(g1,nil,2,reason,rp) end
	if #g2>0 then Duel.Remove(g2,POS_FACEUP,reason,tp,rp) end
	return gfunc(g,reason,tp,rp)
end
--Non-Fusion Summon
function s.nfmatfilter(c,sc,tp)
	if not sc:IsSetCard(0x40a2) and (c:IsSetCard(0x40a2) and c:IsLocation(LOCATION_GRAVE|LOCATION_REMOVED)) then return false end
	if c:IsLocation(LOCATION_GRAVE) and not (c:IsSetCard(0x40a2) and c:IsAbleToRemove(tp,POS_FACEUP,REASON_MATERIAL)) then return false end
	if c:IsLocation(LOCATION_REMOVED) and not (c:IsFaceup() and c:IsSetCard(0x40a2) and c:IsAbleToDeck()) then return false end
	if c:IsLocation(LOCATION_MZONE) and not c:IsFaceup() then return false end
	return true
end
function s.spfilter(c,tp)
	if c:IsFaceup() or c:IsType(TYPE_FUSION) then return false end
	local grave = Duel.IsPlayerAffectedByEffect(tp,69832741) and 0 or LOCATION_GRAVE
	local mg=Duel.GetMatchingGroup(s.nfmatfilter,tp,LOCATION_HAND|LOCATION_MZONE|grave|LOCATION_REMOVED,0,nil,c,tp)
	local res=false
	if c:IsType(TYPE_SYNCHRO) then
		res=c:IsSynchroSummonable(nil,mg)
	elseif c:IsType(TYPE_XYZ) then
		res=c:IsXyzSummonable(nil,mg)
	elseif c:IsType(TYPE_LINK) then
		res=c:IsLinkSummonable(nil,mg)
	end
	return res
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_EXTRA,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sc=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,tp):GetFirst()
	if not sc then return end
	local grave = Duel.IsPlayerAffectedByEffect(tp,69832741) and 0 or LOCATION_GRAVE
	local mg=Duel.GetMatchingGroup(s.nfmatfilter,tp,LOCATION_HAND|LOCATION_MZONE|grave|LOCATION_REMOVED,0,nil,sc,tp)
	if not sc:IsType(TYPE_XYZ) then
		local reset={}
		for mc in mg:Filter(Card.IsLocation,nil,LOCATION_GRAVE|LOCATION_REMOVED):Iter() do
			table.insert(reset,mc:RegisterFlagEffect(id,RESET_EVENT|RESETS_REDIRECT,0,1,mc:GetLocation()))
		end
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_MOVE)
		e1:SetOperation(function(_e)
							for _,fe in ipairs(reset) do fe:Reset() end
							_e:Reset()
						end)
		sc:RegisterEffect(e1,true)
		if sc:IsType(TYPE_SYNCHRO) then
			Duel.SynchroSummon(tp,sc,nil,mg)
		elseif sc:IsType(TYPE_LINK) then
			Duel.LinkSummon(tp,sc,nil,mg)
		end
	else
		Duel.XyzSummon(tp,sc,nil,mg,1,99)
	end
end