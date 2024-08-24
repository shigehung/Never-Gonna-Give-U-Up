--ブレイク・ハイドライブ
--Break Hydradrive
--Scripted by TriDung
local s,id=GetID()
function s.initial_effect(c)
	--Negate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(s.negcon)
	e1:SetCost(s.negcost)
	e1:SetTarget(s.negtg)
	e1:SetOperation(s.negop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCondition(s.negcon2)
	e2:SetTarget(s.negtg2)
	c:RegisterEffect(e2)
end
s.listed_series={0x577}
function s.check(ev,re)
	return function(category,checkloc)
		if not checkloc and re:IsHasCategory(category) then return true end
		local ex1,g1,gc1,dp1,dv1=Duel.GetOperationInfo(ev,category)
		local ex2,g2,gc2,dp2,dv2=Duel.GetPossibleOperationInfo(ev,category)
		if not (ex1 or ex2) then return false end
		if category==CATEGORY_RELEASE then return true end
		local g=Group.CreateGroup()
		if g1 then g:Merge(g1) end
		if g2 then g:Merge(g2) end
		return (((dv1 or 0)|(dv2 or 0))&LOCATION_ALL)~=0 or (#g>0 and g:IsExists(Card.IsLocation,1,nil,LOCATION_ALL))
	end
end
function s.confilter(c)
	return c:IsFaceup() and c:IsMonster() and c:IsSetCard(0x577)
end
function s.negcon(e,tp,eg,ep,ev,re,r,rp)
	if not rp==1-tp or not Duel.IsExistingMatchingCard(s.confilter,tp,LOCATION_ONFIELD,0,1,nil) or not Duel.IsChainNegatable(ev) then return false end
	local checkfunc=s.check(ev,re)
	return checkfunc(CATEGORY_RELEASE,false) or checkfunc(CATEGORY_RELEASE,true)
end
function s.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToGraveAsCost() and c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function s.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,tp,0)
end
function s.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev)~=0 then
		Duel.Damage(1-tp,800,REASON_EFFECT)
	end
end
-------
function s.negfilter(c,e,tp)
	return c:IsReason(REASON_RELEASE)
end
function s.negcon2(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and Duel.IsExistingMatchingCard(s.confilter,tp,LOCATION_ONFIELD,0,1,nil) and Duel.IsChainNegatable(ev)
end
function s.negtg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return eg:IsContains(chkc) and s.negfilter(chkc,e,tp) end
	if chk==0 then return eg:IsExists(s.negfilter,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,tp,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,800)
end