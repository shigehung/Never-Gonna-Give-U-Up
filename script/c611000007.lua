local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Ritual.AddProcGreater({handler=c,lvtype=RITPROC_GREATER,filter=s.ritualfil,extrafil=s.extrafil,extraop=s.extraop,location=LOCATION_DECK|LOCATION_HAND|LOCATION_GRAVE,extratg=s.extratg})
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_RELEASE)
	c:RegisterEffect(e1)
	--Deck
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_DECK+LOCATION_HAND)
	e2:SetCondition(s.deckcon)
	e2:SetOperation(s.deckop)
	c:RegisterEffect(e2)
end
s.listed_series={0x20f8}
s.listed_names={13331639,611000001}
s.fit_monster={611000004,611000005}
--Activate
function s.ritualfil(c)
	return c:IsSetCard(0x20f8) and c:IsRitualMonster()
end
function s.mfilter(c)
	return c:IsFaceup() and c:HasLevel() and c:IsType(TYPE_PENDULUM) and c:IsSetCard(0x20f8) and c:IsAbleToExtra()
end
function s.ckfilter(c,e,tp)
	return c:IsCode(13331639,611000001) and c:IsFaceup()
end
function s.extrafil(e,tp,eg,ep,ev,re,r,rp,chk)
	if Duel.IsExistingMatchingCard(s.ckfilter,tp,LOCATION_MZONE,0,1,nil,e,tp) then
		return Duel.GetMatchingGroup(s.mfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
	end
	return Group.CreateGroup()
end
function s.extraop(mg,e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local mat2=mg:Filter(Card.IsLocation,nil,LOCATION_GRAVE+LOCATION_REMOVED):Filter(s.mfilter,nil)
	mg:Sub(mat2)
	Duel.ReleaseRitualMaterial(mg)
	Duel.SendtoExtraP(mat2,nil,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL)
	if c:IsRelateToEffect(e) and not c:IsLocation(LOCATION_DECK) and not c:IsHasEffect(EFFECT_CANNOT_TO_DECK) then
		c:CancelToGrave()
		Duel.SendtoDeck(c,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	end
end
function s.extratg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetPossibleOperationInfo(0,CATEGORY_TOEXTRA,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
end
--Deck
function s.deckfilter(c,tp)
	return c:IsType(TYPE_RITUAL) and c:IsControler(1-tp) and c:IsSummonType(SUMMON_TYPE_RITUAL)
end
function s.deckcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.ckfilter,tp,LOCATION_MZONE,0,1,nil,e,tp) and eg:IsExists(s.deckfilter,1,nil,tp)
end
function s.deckop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
		local tpe=c:GetType()
		local te=c:GetActivateEffect()
		local tg=te:GetTarget()
		local co=te:GetCost()
		local op=te:GetOperation()
		e:SetCategory(te:GetCategory())
		e:SetProperty(te:GetProperty())
		Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		Duel.Hint(HINT_CARD,0,c:GetCode())
		c:CreateEffectRelation(te)
		if co then co(te,tp,eg,ep,ev,re,r,rp,1) end
		if tg then tg(te,tp,eg,ep,ev,re,r,rp,1) end
		if op then op(te,tp,eg,ep,ev,re,r,rp) end
		c:ReleaseEffectRelation(te)
	end
end