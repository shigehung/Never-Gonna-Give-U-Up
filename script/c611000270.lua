--リコレクションの扉
--The Door of Recollection
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	-- 3 Level 5 monsters
	Xyz.AddProcedure(c,nil,5,3)
	--Can use "Magicians" monsters as Level 5 materials
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE)
	e0:SetCode(EFFECT_XYZ_LEVEL)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetTargetRange(LOCATION_ALL,0)
	e0:SetTarget(function(e,c) return (c:IsMonster() and c:IsSetCard(0x40a2)) end)
	e0:SetValue(function(e,_,rc) return rc==e:GetHandler() and 5 or 0 end)
	c:RegisterEffect(e0)
	--Immune to Necrovalley
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_NECRO_VALLEY_IM)
	e2:SetRange(LOCATION_ONFIELD+LOCATION_GRAVE)
	e2:SetTargetRange(1,0)
	c:RegisterEffect(e2)
	--Return card from GY to Deck
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,{id,1})
	e3:SetCost(aux.dxmcostgen(1,s.mxmc,s.slwc))
	e3:SetTarget(s.rtdtg)
	e3:SetOperation(s.rtdsop)
	c:RegisterEffect(e3,false,REGISTER_FLAG_DETACH_XMAT)
end
s.listed_series={0x40a2}
function s.mxmc(e,tp)
	return Duel.GetMatchingGroupCount(Card.IsCanBeEffectTarget,tp,0,LOCATION_GRAVE,nil,e)
end
function s.slwc(e,og)
	e:SetLabel(#og)
end
function s.rtdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_GRAVE) end
	if chk==0 then return true end
	local ct=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_GRAVE,ct,ct,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,#g,0,0)
end
function s.rtdsop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetTargetCards(e)
	if #g>0 then
		Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	end
end