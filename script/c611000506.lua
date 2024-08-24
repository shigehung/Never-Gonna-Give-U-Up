--マジシャンズ・の儀式
--Magician's Ritual
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Ritual.CreateProc({handler=c,lvtype=RITPROC_GREATER,filter=s.filter,extrafil=s.extragroup,
								extraop=s.extraop,stage2=s.stage2,location=LOCATION_HAND+LOCATION_GRAVE,extratg=s.extratg})
	e1:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(s.con1)
	c:RegisterEffect(e1)
	local e2=Ritual.CreateProc({handler=c,lvtype=RITPROC_GREATER,filter=s.filter,extrafil=s.extragroup1,
								extraop=s.extraop1,stage2=s.stage2,location=LOCATION_HAND,extratg=s.extratg1})
	e2:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH)
	e2:SetCondition(s.con2)
	c:RegisterEffect(e2)
end
s.listed_series={0x40a2}
s.listed_names={CARD_DARK_MAGICIAN,CARD_DARK_MAGICIAN_GIRL}
function s.ckfilter(c)
	return c:IsCode(CARD_DARK_MAGICIAN) or c:IsCode(CARD_DARK_MAGICIAN_GIRL)
end
function s.con1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.ckfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,nil)
end
function s.con2(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(s.ckfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,nil)
end
function s.filter(c)
	return c:IsAttribute(ATTRIBUTE_LIGHT|ATTRIBUTE_DARK) and c:IsRace(RACE_SPELLCASTER)
end
function s.extragroup(e,tp,eg,ep,ev,re,r,rp,chk)
	return Duel.GetMatchingGroup(s.matfilter1,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil)
end
function s.extragroup1(e,tp,eg,ep,ev,re,r,rp,chk)
	return Duel.GetMatchingGroup(s.matfilter2,tp,LOCATION_DECK,0,nil)
end
function s.matfilter1(c)
	return c:IsMonster() and c:IsSetCard(0x40a2) and c:IsLevelAbove(1) and ((c:IsLocation(LOCATION_DECK) and c:IsAbleToGrave()) or (c:IsLocation(LOCATION_GRAVE) and c:IsAbleToRemove())) 
end
function s.matfilter2(c)
	return c:IsMonster() and c:IsSetCard(0x40a2) and c:IsLevelAbove(1) and c:IsLocation(LOCATION_DECK) and c:IsAbleToGrave() 
end
function s.extraop(mat,e,tp,eg,ep,ev,re,r,rp,tc)
	local mat2=mat:Filter(Card.IsLocation,nil,LOCATION_DECK)
	local mat3=mat:Filter(Card.IsLocation,nil,LOCATION_GRAVE)
	mat:Sub(mat2)
	mat:Sub(mat3)
	Duel.ReleaseRitualMaterial(mat)
	Duel.Remove(mat3,POS_FACEUP,REASON_EFFECT|REASON_MATERIAL|REASON_RITUAL,tp)
	Duel.SendtoGrave(mat2,REASON_EFFECT|REASON_MATERIAL|REASON_RITUAL)
end
function s.extraop1(mat,e,tp,eg,ep,ev,re,r,rp,tc)
	local mat2=mat:Filter(Card.IsLocation,nil,LOCATION_DECK)
	mat:Sub(mat2)
	Duel.ReleaseRitualMaterial(mat)
	Duel.SendtoGrave(mat2,REASON_EFFECT|REASON_MATERIAL|REASON_RITUAL)
end
function s.extratg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,5,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,5,tp,LOCATION_GRAVE)
end
function s.extratg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,5,tp,LOCATION_DECK)
end
function s.stage2(mat,e,tp,eg,ep,ev,re,r,rp,tc)
	tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,0))
end
