--Fusion-Pendulum face-up Extra Deck
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	--fusion summon
	Fusion.AddProcMix(c,true,true,CARD_DARK_MAGICIAN,{16178681,s.ffilter})
	--pendulum summon
	Pendulum.AddProcedure(c,false)
	--fusion summon from face-up extra
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetValue(SUMMON_TYPE_FUSION)
	e1:SetCondition(s.spcon)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
end
function s.ffilter(c,fc,sumtype,tp)
	return c:IsRace(RACE_DRAGON,fc,sumtype,tp) and c:IsType(TYPE_EFFECT,fc,sumtype,tp)
end
--fusion summon from face-up extra
function s.spconfilter1(c)
	return c:IsFaceup() and c:IsCanBeFusionMaterial() and c:IsAbleToRemoveAsCost() and c:IsCode(CARD_DARK_MAGICIAN)
end
function s.spconfilter2(c)
	return c:IsFaceup() and c:IsCanBeFusionMaterial() and c:IsAbleToRemoveAsCost() and (c:IsCode(16178681) or (c:IsRace(RACE_DRAGON) and c:IsType(TYPE_EFFECT)))
end
function s.spcon(e,c)
	if c==nil then return true end
	local c=e:GetHandler()
	local tp=e:GetHandlerPlayer()
	return c:IsFaceup() and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
		and Duel.IsExistingMatchingCard(s.spconfilter1,tp,LOCATION_ONFIELD,0,1,nil)
		and Duel.IsExistingMatchingCard(s.spconfilter2,tp,LOCATION_ONFIELD,0,1,nil)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local c=e:GetHandler()
	local mg1=Duel.SelectMatchingCard(tp,s.spconfilter1,tp,LOCATION_ONFIELD,0,1,1,nil,tp)
	local mg2=Duel.SelectMatchingCard(tp,s.spconfilter2,tp,LOCATION_ONFIELD,0,1,1,nil,tp)
	mg1:Merge(mg2)
	if mg1 then
		Duel.Remove(mg1,POS_FACEUP,REASON_COST+REASON_MATERIAL+REASON_FUSION)
		c:CompleteProcedure()
	end
end
--










