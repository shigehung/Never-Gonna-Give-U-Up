--Field Spell Card
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH)
	e0:SetOperation(s.activate)
	c:RegisterEffect(e0)
	
	--Increase ATK
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetRange(LOCATION_FZONE)
	e1:SetTarget(function(_,c) return c:IsType(TYPE_FUSION) end)
	e1:SetValue(500)
	c:RegisterEffect(e1)
	
	-- Prevent negation of Fusion Summon effects
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_INACTIVATE)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(1,0)
	e2:SetValue(s.effectfilter)
	c:RegisterEffect(e2)
	
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_DISEFFECT)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTargetRange(1,0)
	e3:SetValue(s.effectfilter)
	c:RegisterEffect(e3)
	
	-- Prevent opponent's activation during Fusion Summon
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_ACTIVATE)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetRange(LOCATION_FZONE)
	e4:SetTargetRange(0,1)
	e4:SetCondition(s.actcon)
	e4:SetValue(s.aclimit)
	c:RegisterEffect(e4)
end

s.listed_names={CARD_ALBAZ}
s.listed_series={0x182}

function s.thfilter(c)
	return c:IsAbleToHand() and ((c:IsSetCard(0x182) and c:IsMonster()) or c:ListsCode(CARD_ALBAZ))
end

function s.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(s.thfilter,tp,LOCATION_DECK,0,nil)
	if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end

function s.cfilter(c,tp)
	return c:IsPreviousControler(tp) and c:IsPreviousLocation(LOCATION_GRAVE+LOCATION_MZONE) and c:IsPreviousPosition(POS_FACEUP)
		and c:IsSetCard(0x182) and (c:IsMonster() or c:IsPreviousLocation(LOCATION_MZONE)) and c:IsReason(REASON_EFFECT)
end

function s.effectfilter(e,ct)
	local p=e:GetHandlerPlayer()
	local te=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT)
	return te and te:GetHandler():IsControler(p) and te:IsHasCategory(CATEGORY_FUSION_SUMMON)
end

function s.actcon(e,tp,eg,ep,ev,re,r,rp)
	local p=e:GetHandlerPlayer()
	local ct=Duel.GetCurrentChain()
	if ct==0 then return false end
	local te=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT)
	return te and te:GetHandler():IsControler(p) and te:IsHasCategory(CATEGORY_FUSION_SUMMON)
end

function s.aclimit(e,re,tp)
	return re:IsActiveType(TYPE_MONSTER+TYPE_SPELL+TYPE_TRAP)
end