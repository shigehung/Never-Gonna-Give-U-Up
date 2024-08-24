--マジシャンズ・ソード
--Magician's Sword
local s,id=GetID()
function s.initial_effect(c)
	--synchro summon
	Synchro.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsSetCard,0x40a2),1,1,Synchro.NonTunerEx(s.tfilter),1,99)
	c:EnableReviveLimit()
	--Set up to 3 "Magicians" or "DM"/"DMG" Spell/Trap directly from Deck, it can activate this turn
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.setcon)
	e1:SetCost(s.cost)
	e1:SetTarget(s.settg)
	e1:SetOperation(s.setop)
	c:RegisterEffect(e1)
	--Negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(s.negcon)
	e2:SetCost(s.negcost)
	e2:SetTarget(s.negtg)
	e2:SetOperation(s.negop)
	c:RegisterEffect(e2)
end
s.listed_series={0x40a2}
s.listed_names={CARD_DARK_MAGICIAN,CARD_DARK_MAGICIAN_GIRL}
function s.tfilter(c,lc,stype,tp)
	return c:GetOriginalAttribute(ATTRIBUTE_LIGHT|ATTRIBUTE_DARK) and c:GetOriginalRace(RACE_SPELLCASTER)
end
--Set up to 3 "Magicians" or "DM"/"DMG" Spell/Trap directly from Deck or GY, it can activate this turn
function s.setcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000) end
	Duel.PayLPCost(tp,1000)
end
function s.setfilter(c)
	return (c:IsSetCard(0x40a2) or c:ListsCode(CARD_DARK_MAGICIAN)) and c:IsSpellTrap() and c:IsSSetable()
end
function s.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.setfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
end
function s.setop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(s.setfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil)
	if #sg==0 then return end
	local ft=math.min(Duel.GetLocationCount(tp,LOCATION_SZONE),3)
	local rg=aux.SelectUnselectGroup(sg,e,tp,1,ft,aux.dncheck,1,tp,HINTMSG_SET)
	if #rg>0 and Duel.SSet(tp,rg)>0 then
		local c=e:GetHandler()
		for tc in rg:Iter() do
			local e1=Effect.CreateEffect(c)
			e1:SetDescription(aux.Stringid(id,2))
			e1:SetType(EFFECT_TYPE_SINGLE)
			if tc:IsQuickPlaySpell() then
				e1:SetCode(EFFECT_QP_ACT_IN_SET_TURN)
			elseif tc:IsTrap() then
				e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
			end
			e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
			e1:SetReset(RESET_EVENT|RESETS_STANDARD)
			tc:RegisterEffect(e1)
		end
	end
end
--Negate
function s.negcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsChainDisablable(ev)
end
function s.negcfilter(c)
	return c:IsSetCard(0x40a2) and c:IsMonster() and c:IsAbleToRemoveAsCost()
end
function s.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.negcfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,s.negcfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function s.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not re:GetHandler():IsStatus(STATUS_DISABLED) end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
	local g=Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,0,LOCATION_HAND,1,nil)
	Duel.SetPossibleOperationInfo(0,CATEGORY_DRAW,nil,1,tp,1)
	Duel.SetPossibleOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function s.negop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	local opt1=Duel.IsPlayerCanDraw(tp,1)
	local opt2=#g>0
	if (opt1 or opt2) and Duel.SelectYesNo(tp,aux.Stringid(id,5)) then
		local opt
		if opt1 and opt2 then
			opt=Duel.SelectOption(tp,aux.Stringid(id,3),aux.Stringid(id,4))
		elseif opt1 and not opt2 then
			opt=Duel.SelectOption(tp,aux.Stringid(id,3))
		elseif opt2 and not opt1 then
			opt=Duel.SelectOption(tp,aux.Stringid(id,4))+1
		end
		if opt==0 then
			Duel.BreakEffect()
			Duel.Draw(tp,1,REASON_EFFECT)
		elseif opt==1 then
			Duel.BreakEffect()
			local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
			if #g<=0 then return end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
			local tc=g:RandomSelect(tp,1,1,nil)
			Duel.SendtoDeck(tc,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
		end
	end
end