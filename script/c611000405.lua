--超魔導竜騎士－ドラグーン・オブ・オッドアイズ
--Dragoon of Odd-Eyes The Ultimate Magical Dragon Knight
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	--fusion material
	Fusion.AddProcMix(c,true,true,CARD_DARK_MAGICIAN,{16178681,s.ffilter})
	--pendulum summon
	Pendulum.AddProcedure(c,false)
	--fusion summon from face-up extra
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(id,0))
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetValue(SUMMON_TYPE_FUSION)
	e0:SetCondition(s.selfspcon)
	e0:SetOperation(s.selfspop)
	c:RegisterEffect(e0)
	--register effect
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(s.regcon)
	e1:SetOperation(s.regop)
	c:RegisterEffect(e1)
	--material count check
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_MATERIAL_CHECK)
	e2:SetValue(s.valcheck)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2)
	--Immune
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	--Place itself into pendulum zone
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(id,1))
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_DESTROYED)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetCondition(s.pencon)
	e5:SetTarget(s.pentg)
	e5:SetOperation(s.penop)
	c:RegisterEffect(e5)
	--special summon material
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(id,2))
	e6:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e6:SetRange(LOCATION_PZONE)
	e6:SetCode(EVENT_TO_GRAVE)
	e6:SetCost(s.spcost)
	e6:SetTarget(s.sptg)
	e6:SetOperation(s.spop)
	c:RegisterEffect(e6)
end
s.material={CARD_DARK_MAGICIAN,16178681}
s.listed_names={CARD_DARK_MAGICIAN,16178681}
s.material_setcode={0x99,0x10a2}
--fusion material
function s.ffilter(c,fc,sumtype,tp)
	return c:IsRace(RACE_DRAGON,fc,sumtype,tp) and c:IsType(TYPE_EFFECT,fc,sumtype,tp)
end
--fusion summon from face-up extra
function s.spconfilter1(c)
	return c:IsFaceup() and c:IsCanBeFusionMaterial() and c:IsAbleToRemoveAsCost() and c:IsCode(CARD_DARK_MAGICIAN) end
function s.spconfilter2(c)
	return c:IsFaceup() and c:IsCanBeFusionMaterial() and c:IsAbleToRemoveAsCost() and (c:IsCode(16178681) or (c:IsRace(RACE_DRAGON) and c:IsType(TYPE_EFFECT))) end
function s.selfspcon(e,c)
	if c==nil then return true end
	local c=e:GetHandler()
	local tp=e:GetHandlerPlayer()
	return c:IsFaceup() and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
		and Duel.IsExistingMatchingCard(s.spconfilter1,tp,LOCATION_ONFIELD,0,1,nil)
		and Duel.IsExistingMatchingCard(s.spconfilter2,tp,LOCATION_ONFIELD,0,1,nil)
end
function s.selfspop(e,tp,eg,ep,ev,re,r,rp,c)
	local c=e:GetHandler()
	local mg1=Duel.SelectMatchingCard(tp,s.spconfilter1,tp,LOCATION_ONFIELD,0,1,1,nil,tp)
	local mg2=Duel.SelectMatchingCard(tp,s.spconfilter2,tp,LOCATION_ONFIELD,0,1,1,nil,tp)
	mg1:Merge(mg2)
	if mg1 then
		c:SetMaterial(mg1)
		Duel.Remove(mg1,POS_FACEUP,REASON_COST+REASON_MATERIAL+REASON_FUSION)
		c:CompleteProcedure()
	end
end
--material count check
function s.mcheck(c)
	return c:IsCode(16178681) or c:IsCode(CARD_DARK_MAGICIAN)
end
function s.valcheck(e,c)
	local g=c:GetMaterial()
	local ct=g:FilterCount(s.mcheck,nil)
	e:GetLabelObject():SetLabel(ct)
end
--register effect
function s.regcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_FUSION) and e:GetLabel()>0
end
function s.chkfilter(c,label)
	return c:GetFlagEffect(label)>0
end
function s.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=e:GetLabel()
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e1:SetDescription(aux.Stringid(id,3))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetReset(RESET_EVENT+(RESETS_STANDARD&~(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)))
	e1:SetCountLimit(ct)
	e1:SetTarget(s.adctg)
	e1:SetOperation(s.adcop)
	c:RegisterEffect(e1)
end
function s.adctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_ATKCHANGE,e:GetHandler(),1,tp,0)
	Duel.SetOperationInfo(0,CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE,nil,1,1-tp,LOCATION_MZONE)
end
function s.adcop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.SelectMatchingCard(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,nil)
	local tc=g:GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	if c:IsFaceup() and c:IsRelateToEffect(e) and tc then
		e:GetHandler():RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
		local addattack=e:GetHandler():GetFlagEffect(id)
		Duel.HintSelection(g,true)
		local atkc=c:GetBaseAttack()
		--Opponent's monster gain ATK/DEF
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD_DISABLE+RESET_PHASE+PHASE_END,2)
		e1:SetValue(atkc)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		tc:RegisterEffect(e2)
		--ATK become 0
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_SET_ATTACK)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD_DISABLE+RESET_PHASE+PHASE_END,2)
		e3:SetValue(0)
		c:RegisterEffect(e3)
		--Additional Attack
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetCode(EFFECT_EXTRA_ATTACK)
		e4:SetValue(addattack)
		e4:SetReset(RESET_EVENT+RESETS_STANDARD_DISABLE+RESET_PHASE+PHASE_END,2)
		c:RegisterEffect(e4)
		--Opponent take battle damage
		local e5=Effect.CreateEffect(c)
		e5:SetType(EFFECT_TYPE_SINGLE)
		e5:SetCode(EFFECT_REFLECT_BATTLE_DAMAGE)
		e5:SetReset(RESET_EVENT+RESETS_STANDARD_DISABLE+RESET_PHASE+PHASE_END,2)
		e5:SetValue(1)
		c:RegisterEffect(e5)
		--Cannot target for attack
		local e6=Effect.CreateEffect(c)
		e6:SetType(EFFECT_TYPE_FIELD)
		e6:SetRange(LOCATION_MZONE)
		e6:SetTargetRange(0,LOCATION_MZONE)
		e6:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
		e6:SetValue(s.atlimit)
		c:RegisterEffect(e6)
	end
end
function s.atlimit(e,c)
	return c~=e:GetHandler()
end
--Place itself into pendulum zone
function s.pencon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsFaceup()
end
function s.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckPendulumZones(tp) end
end
function s.penop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.CheckPendulumZones(tp) then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end
--special summon material
function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToExtraAsCost() end
	Duel.SendtoExtraP(c,nil,REASON_COST)
end
function s.spfilter(c,e,tp,code)
	return c:IsFaceup() and c:IsCode(code) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.spfilter1(c,e,tp,code)
	return c:IsFaceup() and (c:IsCode(16178681) or (c:IsRace(RACE_DRAGON) and c:IsType(TYPE_EFFECT))) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>2
		and Duel.IsExistingTarget(aux.NecroValleyFilter(s.spfilter),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp,CARD_DARK_MAGICIAN)
		and Duel.IsExistingTarget(aux.NecroValleyFilter(s.spfilter1),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp)
		and not Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g1=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp,CARD_DARK_MAGICIAN)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g2=Duel.SelectMatchingCard(tp,s.spfilter1,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp)
	g1:Merge(g2)
	Duel.SetTargetCard(g1)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g1,2,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local g=Duel.GetTargetCards(e)
	if ft<=0 or #g==0 or #g>1 and Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) then return end
	if #g<=ft then
		for tc in g:Iter() do
			if Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP) then
				--Negated effect
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_DISABLE)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				tc:RegisterEffect(e1,true)
				local e2=Effect.CreateEffect(e:GetHandler())
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetCode(EFFECT_DISABLE_EFFECT)
				e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				tc:RegisterEffect(e2,true)
				--Cannot attack
				local e3=Effect.CreateEffect(e:GetHandler())
				e3:SetDescription(3206)
				e3:SetProperty(EFFECT_FLAG_CLIENT_HINT)
				e3:SetType(EFFECT_TYPE_SINGLE)
				e3:SetCode(EFFECT_CANNOT_ATTACK)
				e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				tc:RegisterEffect(e3)
			end
		end
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,ft,ft,nil)
		if Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP) then
			--Negated effect
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			sg:RegisterEffect(e1,true)
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			sg:RegisterEffect(e2,true)
			--Cannot attack
			local e3=Effect.CreateEffect(e:GetHandler())
			e3:SetDescription(3206)
			e3:SetProperty(EFFECT_FLAG_CLIENT_HINT)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_CANNOT_ATTACK)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			sg:RegisterEffect(e3)
		end
		g:Sub(sg)
		Duel.SendtoGrave(g,REASON_RULE)
	end
end