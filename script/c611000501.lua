--伝説のドラゴンの楽園
--The Paradise of Legendary Dragon
--Duel.LoadScript("c430.lua")
local s,id=GetID()
function s.initial_effect(c)
	--Add to Hand, or Set 1 "Timaeus" card
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.e1target)
	e1:SetOperation(s.e1activate)
	c:RegisterEffect(e1)
	--Change ATK/DEF
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e2:SetRange(LOCATION_FZONE) 
	e2:SetCondition(s.condition)
	e2:SetCost(s.cost)
	e2:SetOperation(s.e2activate)
	c:RegisterEffect(e2)
end
s.listed_names={CARD_DARK_MAGICIAN,611000502,89397517,46232525,11082056,1784686,3078380,80019195}
s.listed_series={0xa1}
--Add to Hand, or Set 1 "Timaeus" card
function s.thfilter(c)
	return (c:IsAbleToHand() or c:IsSSetable()) and (c:IsSetCard(0xa1) or c:IsCode(611000502,89397517,46232525,11082056,1784686,3078380,80019195)) and not c:IsCode(id)
end
function s.e1target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetPossibleOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function s.e1activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,2))
	local tc=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
	if not tc then return end
	aux.ToHandOrElse(tc,tp,
		Card.IsSSetable,
		function(c)
			Duel.SSet(tp,tc,tp,true)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			if tc:IsQuickPlaySpell() then
				e1:SetCode(EFFECT_QP_ACT_IN_SET_TURN)
			elseif tc:IsTrap() then
				e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
			end
			e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
			e1:SetReset(RESET_EVENT|RESETS_STANDARD)
			e1:SetDescription(aux.Stringid(id,4))
			tc:RegisterEffect(e1)
		end,
		aux.Stringid(id,3)
	)
end
--Change ATK/DEF
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	local bc=Duel.GetAttackTarget()
	if not bc then return false end
	local tc=Duel.GetAttacker()
	if not tc:IsControler(tp) then tc,bc=bc,tc end
	e:SetLabelObject(tc)
	return tc:IsControler(tp) and (tc:IsCode(CARD_DARK_MAGICIAN) or (tc:IsAttribute(ATTRIBUTE_DARK) and tc:IsRace(RACE_DRAGON) and tc:IsType(TYPE_FUSION))) and not bc:IsControler(tp)
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,500) end
	Duel.PayLPCost(tp,500)
end
function s.e2activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	local bc=tc:GetBattleTarget()
	if tc:IsRelateToBattle() and not tc:IsImmuneToEffect(e)
		and tc:IsControler(tp) and not bc:IsControler(tp) then
		local val = math.max(bc:GetAttack(),bc:GetDefense())
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(val)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DAMAGE_CAL)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e2:SetValue(1)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DAMAGE_CAL)
		tc:RegisterEffect(e2)
	end
end