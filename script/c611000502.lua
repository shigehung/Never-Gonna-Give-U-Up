--The Wishes from SpiritWorld
local s,id=GetID()
function s.initial_effect(c)
	--Add code
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_ADD_CODE)
	e0:SetValue(10000050)
	c:RegisterEffect(e0)
	--Becomes banished card's effect
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,1))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_STANDBY_PHASE,TIMING_STANDBY_PHASE)
	--e1:SetCountLimit(1,{id,1})
	e1:SetCondition(function(_,tp)
						return Duel.IsExistingMatchingCard(aux.FaceupFilter(Card.IsCode,CARD_DARK_MAGICIAN,CARD_DARK_MAGICIAN_GIRL),tp,LOCATION_MZONE,0,1,nil)
					end)
	e1:SetCost(s.applycost)
	e1:SetTarget(s.applytg)
	e1:SetOperation(s.applyop)
	c:RegisterEffect(e1)
	--Shuffle 1 banished "Timaeus" to Deck, add this card to Hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,4))
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	--e2:SetCountLimit(1,{id,2})
	e2:SetTarget(s.tdtg)
	e2:SetOperation(s.tdop)
	c:RegisterEffect(e2)
end
s.listed_names={CARD_DARK_MAGICIAN,CARD_DARK_MAGICIAN_GIRL,611000507,1784686,3078380,80019195}
TIMAEUS,UNITED,LEGENDARY=611000507,3078380,80019195
local tgf_table={}
local legend_eff={}
function s.rmvfilter(c,e,tp)
	if not c:IsAbleToRemoveAsCost() then return false end
	if c:IsCode(TIMAEUS) then
		return c:CheckActivateEffect(true,true,false)~=nil
	elseif c:IsCode(UNITED) then
		local effs={c:GetCardEffect()}
		for _,eff in ipairs(effs) do
			if (eff:GetRange()&LOCATION_HAND)>0 then
			else
				local tg=eff:GetTarget()
				return tg and tg(eff,tp,Group.CreateGroup(),PLAYER_NONE,0,e,REASON_EFFECT,PLAYER_NONE,0)
			end
		end
	elseif c:IsCode(LEGENDARY) then
		local effs=c:GetEffect(EVENT_SPSUMMON_SUCCESS,EVENT_BE_BATTLE_TARGET)
		for _,eff in ipairs(effs) do
			local tg=eff:GetTarget()
			if tg and #tgf_table<2 and #legend_eff<2 then
				table.insert(tgf_table,tg)
				table.insert(legend_eff,eff)
			end
		end
		if (tgf_table[1] and tgf_table[1](effs[1],tp,Group.CreateGroup(),PLAYER_NONE,0,e,REASON_EFFECT,PLAYER_NONE,0) or
			tgf_table[2] and tgf_table[2](effs[1],tp,Group.CreateGroup(),PLAYER_NONE,0,e,REASON_EFFECT,PLAYER_NONE,0)) then
			return true
		end
	end
	return false
end
function s.applycost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.rmvfilter,tp,LOCATION_DECK|LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local sc=Duel.SelectMatchingCard(tp,s.rmvfilter,tp,LOCATION_DECK|LOCATION_GRAVE,0,1,1,nil,e,tp):GetFirst()
	Duel.Remove(sc,POS_FACEUP,REASON_COST)
	e:SetLabelObject(sc)
end
function s.applytg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local sc=e:GetLabelObject()
	if chkc and sc then
		return tg and tg(e,tp,eg,ep,ev,re,r,rp,0,chkc) or (tgf_table[1] and tgf_table[1](e,tp,eg,ep,ev,re,r,rp,0,chkc) or tgf_table[2] and tgf_table[2](e,tp,eg,ep,ev,re,r,rp,0,chkc))
	end
	if chk==0 then return true end
	if sc:IsCode(TIMAEUS) then
		local te=sc:CheckActivateEffect(true,true,false)
		e:SetLabel(te:GetLabel())
		e:SetLabelObject(te:GetLabelObject())
		e:SetProperty(te:IsHasProperty(EFFECT_FLAG_CARD_TARGET) and EFFECT_FLAG_CARD_TARGET or 0)
		local tg=te:GetTarget()
		if tg then
			tg(e,tp,eg,ep,ev,re,r,rp,1)
		end
		te:SetLabel(e:GetLabel())
		te:SetLabelObject(e:GetLabelObject())
		e:SetLabelObject(te)
	elseif sc:IsCode(UNITED) then
		local effs={sc:GetCardEffect()}
		for _,eff in ipairs(effs) do
			if (eff:GetRange()&LOCATION_HAND)>0 then
			else
				local tg=eff:GetTarget()
				if tg then
					tg(e,tp,eg,ep,ev,re,r,rp,1)
				end
				e:SetLabelObject(eff)
			end
		end
	else
		local b1,b2=tgf_table[1](e,tp,eg,ep,ev,re,r,rp,0,chkc),tgf_table[2](e,tp,eg,ep,ev,re,r,rp,0,chkc)
		local op=Duel.SelectEffect(tp,
		{b1,aux.Stringid(id,2)},
		{b2,aux.Stringid(id,3)})
		if op==1 then
			e:SetLabelObject(legend_eff[1])
			tgf_table[1](e,tp,eg,ep,ev,re,r,rp,1)
		else
			e:SetLabelObject(legend_eff[2])
			tgf_table[2](e,tp,eg,ep,ev,re,r,rp,1)
		end
	end
	Duel.ClearOperationInfo(0)
end
function s.applyop(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	if te then
		if te:GetHandler():IsCode(TIMAEUS) then
			e:SetLabel(te:GetLabel())
			e:SetLabelObject(te:GetLabelObject())
			local op=te:GetOperation()
			if op then op(e,tp,eg,ep,ev,re,r,rp) end
			te:SetLabel(e:GetLabel())
			te:SetLabelObject(e:GetLabelObject())
		else
			local op=te:GetOperation()
			if op then op(e,tp,eg,ep,ev,re,r,rp) end
		end
	end
	e:SetLabelObject(nil)
	e:SetLabel(0)
end
function s.thfilter(c)
	return c:IsFaceup() and c:IsCode(611000507,1784686,3078380,80019195) and c:IsAbleToDeck()
end
function s.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and s.thfilter(chkc) end
	if chk==0 then return e:GetHandler():IsAbleToHand()
		and Duel.IsExistingTarget(s.thfilter,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,s.thfilter,tp,LOCATION_REMOVED,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function s.tdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and Duel.SendtoDeck(tc,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)~=0 then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
	end
end