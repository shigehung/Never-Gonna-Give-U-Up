--覇王眷竜・フレーミング・ソウルズ
--Supreme King Dragon Flaming Soul
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	--Take Control
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_CONTROL+CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetTarget(s.cttg)
	e1:SetOperation(s.ctop)
	c:RegisterEffect(e1)
	--Special Summmon When Battle
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_LEAVE_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(function(_,tp) return Duel.GetAttacker():IsControler(1-tp) end)
	e2:SetTarget(s.spgytg)
	e2:SetOperation(s.spgyop)
	c:RegisterEffect(e2)
	--Special Summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,2))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(TIMING_MAIN_END,TIMING_MAIN_END)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(s.spcost)
	e3:SetTarget(s.sptg)
	e3:SetOperation(s.spop)
	c:RegisterEffect(e3)
	--Attack Limit
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(0,LOCATION_MZONE)
	e4:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e4:SetValue(s.atklimit)
	c:RegisterEffect(e4)
	
end
s.listed_names={611000007}
s.listed_series={0x20f8}
--Take Control
function s.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xf8)
end
function s.ctfilter(c)
	return c:IsControlerCanBeChanged()
end
function s.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	local zone=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local csk=Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
	local ctc=Duel.IsExistingMatchingCard(s.ctfilter,tp,0,LOCATION_MZONE,1,nil) 
	if chk==0 then return zone>0 and csk and ctc end
	local gsk=Duel.GetMatchingGroup(s.cfilter,tp,LOCATION_ONFIELD,0,nil)
	local g=Duel.GetMatchingGroup(s.ctfilter,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,math.min(zone,#gsk,#g),1-tp,LOCATION_MZONE)
end
function s.ctop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=Duel.GetMatchingGroupCount(s.cfilter,tp,LOCATION_ONFIELD,0,nil)
	local g=Duel.GetMatchingGroup(s.ctfilter,tp,0,LOCATION_MZONE,nil)
	local zone=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ct>0 and #g>0 and zone>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
		local cg=Duel.SelectMatchingCard(tp,s.ctfilter,tp,0,LOCATION_ONFIELD,1,math.min(ct,#g,zone),nil)
		Duel.HintSelection(cg,true)
		for cct in aux.Next(cg) do
			if Duel.GetControl(cct,tp) then
				cct:RegisterFlagEffect(id,RESET_OVERLAY+RESET_LEAVE,0,1)
				--code
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_ADD_SETCODE)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e1:SetRange(LOCATION_MZONE)
				e1:SetValue(0x20f8)
				cct:RegisterEffect(e1)
				--Cannot be targeted by opponent's card effects
				local e2=Effect.CreateEffect(c)
				e2:SetDescription(3061)
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
				e2:SetProperty(EFFECT_FLAG_CLIENT_HINT)
				e2:SetValue(aux.tgoval)
				cct:RegisterEffect(e2)
			end
		end
		--Destroy and Inflict Damage
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
		e3:SetCode(EVENT_LEAVE_FIELD)
		e3:SetProperty(EFFECT_FLAG_CANNOT_NEGATE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SET_AVAILABLE)
		e3:SetCondition(s.descon)
		e3:SetOperation(s.desop)
		c:RegisterEffect(e3)
	end
end
function s.descon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousPosition(POS_FACEUP) and not c:IsLocation(LOCATION_DECK)
		and (not re or re:GetOwner()~=c)
end
function s.desfilter(c)
	return c:IsType(TYPE_MONSTER) and c:HasFlagEffect(id)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local dg=Duel.GetMatchingGroup(s.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if #dg>0 and Duel.Destroy(dg,REASON_EFFECT)>0 then
		local og=Duel.GetOperatedGroup()
		Duel.Damage(1-tp,og:GetSum(Card.GetBaseAttack)/2,REASON_EFFECT)
	end
end
--Special Summmon When Battle
function s.spgyfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:CheckUniqueOnField(tp,LOCATION_ONFIELD)
end
function s.spgytg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_GRAVE) and s.spgyfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(s.spgyfilter,tp,0,LOCATION_GRAVE,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,s.spgyfilter,tp,0,LOCATION_GRAVE,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function s.spgyop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local at=Duel.GetAttacker()
	if tc and tc:IsRelateToEffect(e) and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local ct=Duel.GetTurnCount()
		--Negate effect
		tc:NegateEffects(c)
		--Cannot destroyed battle
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e1:SetValue(1)
		tc:RegisterEffect(e1)
		--Reflect Battle Damage
		local e2=e1:Clone()
		e2:SetCode(EFFECT_REFLECT_BATTLE_DAMAGE)
		tc:RegisterEffect(e2)
		--Destroy
		aux.DelayedOperation(tc,PHASE_BATTLE,id,e,tp,function(ag) Duel.Destroy(ag,REASON_EFFECT) end,function() return Duel.GetTurnCount()==ct end)
		Duel.SpecialSummonComplete()
		if at and at:CanAttack() and not at:IsImmuneToEffect(e) then
			Duel.CalculateDamage(at,tc)
		end
	end
end
--Special Summmon
function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() end
	Duel.SendtoDeck(e:GetHandler(),nil,SEQ_DECKSHUFFLE,REASON_COST)
end
function s.spfilter(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(SET_SUPREME_KING_DRAGON) and c:IsType(TYPE_PENDULUM)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.GetLocationCountFromEx(tp,tp,e:GetHandler(),c)>1
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) and aux.CheckSummonGate(tp,2)
		and e:GetHandler():GetFlagEffect(id)==0 and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_EXTRA,0,2,nil,e,tp) end
	e:GetHandler():RegisterFlagEffect(id,RESET_CHAIN,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_EXTRA)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) or not aux.CheckSummonGate(tp,2) then return end
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(s.spfilter,tp,LOCATION_EXTRA,0,nil,e,tp,c)
	if #g>=2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,2,2,nil)
		if Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)~=0 then
			local ag=Duel.GetMatchingGroup(aux.FaceupFilter(Card.IsType,TYPE_RITUAL),tp,0,LOCATION_MZONE,nil)
			if #ag>0 then
				for tc in aux.Next(ag) do
					local e1=Effect.CreateEffect(c)
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetCode(EFFECT_SET_ATTACK_FINAL)
					e1:SetValue(0)
					e1:SetReset(RESET_EVENT|RESETS_STANDARD)
					tc:RegisterEffect(e1)
				end
			end
		end
	end
end
--Attack Limit
function s.atklimit(e,c)
	return c:IsFaceup() and c:IsType(TYPE_RITUAL) and c~=e:GetHandler()
end