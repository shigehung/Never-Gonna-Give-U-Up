--キメラ・ハイドライブ・ドラグリッド
--Chimera Hydradrive Dragrid
--Scripted by TriDung
local s,id=GetID()
local COUNTER_HD=0x577
function s.initial_effect(c)
	c:EnableReviveLimit()
	c:EnableCounterPermit(0x577)
	--link summon
	Link.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsType,TYPE_LINK),5,5,s.lcheck)
	--Place Counter
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(s.ctcon)
	e1:SetOperation(s.ctop)
	c:RegisterEffect(e1)
	--Special Summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_DICE+CATEGORY_TOEXTRA+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(TIMING_MAIN_END,TIMING_MAIN_END)
	e2:SetCondition(s.spcon)
	e2:SetCost(s.spcost)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
end
--			  Original  Customs   Earth	 Aqua	  Flame	 Windy	 Lightning Darkness
s.listed_names={511600365,521009751,521009752,521009753,521009754,521009755,521009756,521009757}
s.listed_series={0x577}
s.roll_dice=true
--link summon
function s.lcheck(g,lc,sumtype,tp)
	return g:CheckDifferentPropertyBinary(Card.GetAttribute,lc,sumtype,tp)
end
--Place Counter
function s.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonLocation()==LOCATION_EXTRA
end
function s.ctop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		c:AddCounter(0x577,1)
	end
end
--Special Summon
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsMainPhase() and e:GetHandler():IsInExtraMZone()
end
function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,COUNTER_HD,1,REASON_COST) end
	e:GetHandler():RemoveCounter(tp,COUNTER_HD,1,REASON_COST)
end
function s.dragridfilter(c,e,tp)
	return c:IsCode(511600365,521009751,521009752,521009753,521009754,521009755,521009756,521009757)
		and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local tged=Duel.IsExistingMatchingCard(s.dragridfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp)
	local tgod=Duel.IsPlayerCanSpecialSummonMonster(tp,521009752,0x577,0x4000021,4000,nil,nil,RACE_CYBERSE,nil,POS_FACEUP,tp,nil)
		or Duel.IsPlayerCanSpecialSummonMonster(tp,521009753,0x577,0x4000021,4000,nil,nil,RACE_CYBERSE,nil,POS_FACEUP,tp,nil)
		or Duel.IsPlayerCanSpecialSummonMonster(tp,521009754,0x577,0x4000021,4000,nil,nil,RACE_CYBERSE,nil,POS_FACEUP,tp,nil)
		or Duel.IsPlayerCanSpecialSummonMonster(tp,521009755,0x577,0x4000021,4000,nil,nil,RACE_CYBERSE,nil,POS_FACEUP,tp,nil)
		or Duel.IsPlayerCanSpecialSummonMonster(tp,521009756,0x577,0x4000021,4000,nil,nil,RACE_CYBERSE,nil,POS_FACEUP,tp,nil)
		or Duel.IsPlayerCanSpecialSummonMonster(tp,521009757,0x577,0x4000021,4000,nil,nil,RACE_CYBERSE,nil,POS_FACEUP,tp,nil)
	if chk==0 then return Duel.GetLocationCountFromEx(tp,tp,nil,c)+1>0 and (tged or tgod) end
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,c,1,0,0)
	if tged and tgod then
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	else
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0,0)
	end
	Duel.SetChainLimit(s.chlimit)
end
function s.chlimit(e,ep,tp)
	return tp==ep
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or not c:IsInExtraMZone() then return end
	local dice=Duel.TossDice(tp,1)
	local att,code
	if dice==1 then att=ATTRIBUTE_EARTH code=521009752 end
	if dice==2 then att=ATTRIBUTE_WATER code=521009753 end
	if dice==3 then att=ATTRIBUTE_FIRE code=521009754 end
	if dice==4 then att=ATTRIBUTE_WIND code=521009755 end
	if dice==5 then att=ATTRIBUTE_LIGHT code=521009756 end
	if dice==6 then att=ATTRIBUTE_DARK code=521009757 end
	local pcs=Duel.IsPlayerCanSpecialSummonMonster(tp,code,0x577,0x4000021,4000,nil,nil,RACE_CYBERSE,att,POS_FACEUP,tp,nil)
	local g=Duel.GetMatchingGroup(s.dragridfilter,tp,LOCATION_EXTRA,0,nil,e,tp)
	local ced=g:IsExists(Card.IsAttribute,1,nil,att)
	if pcs and ced then
		local sc=g:Filter(Card.IsAttribute,nil,att):Select(tp,1,1,nil)
		if Duel.SendtoDeck(c,nil,SEQ_DECKTOP,REASON_EFFECT)>0 then
			Duel.SpecialSummonStep(sc:GetFirst(),SUMMON_TYPE_LINK,tp,tp,true,true,POS_FACEUP,ZONES_EMZ)
			sc:GetFirst():CompleteProcedure()
		end
	elseif pcs and not ced then
		if Duel.SendtoDeck(c,nil,SEQ_DECKTOP,REASON_EFFECT)>0 then
			local token=Duel.CreateToken(tp,code)
			Duel.SendtoDeck(token,tp,0,REASON_RULE)
			Duel.SpecialSummonStep(token,SUMMON_TYPE_LINK,tp,tp,true,true,POS_FACEUP,ZONES_EMZ)
			token:CompleteProcedure()
		end
	else
		return
	end
	Duel.SpecialSummonComplete()
end