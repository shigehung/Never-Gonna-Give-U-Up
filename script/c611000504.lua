--マジシャンズ・融合
--Magicians' Fusion
local s,id=GetID()
function s.initial_effect(c)
	local e1=Fusion.CreateSummonEff(c,aux.FilterBoolFunction(s.ffilter),nil,s.fextra,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,s.extratg)
	e1:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH)
	c:RegisterEffect(e1)
end
s.listed_names={CARD_DARK_MAGICIAN,CARD_DARK_MAGICIAN_GIRL}
s.listed_series={0xa2}
function s.ffilter(c)
	return (((c:IsAttribute(ATTRIBUTE_DARK) or c:IsAttribute(ATTRIBUTE_LIGHT)) and c:IsRace(RACE_SPELLCASTER)) or (c:IsAttribute(ATTRIBUTE_DARK) and c:IsRace(RACE_DRAGON)))
end
function s.checkmat(tp,sg,fc)
	return fc:ListsCodeAsMaterial(46986414,38033121) or not sg:IsExists(Card.IsLocation,1,nil,LOCATION_DECK)
end
function s.fextra(e,tp,mg)
	if Duel.IsPlayerAffectedByEffect(tp,CARD_SPIRIT_ELIMINATION) then return nil,s.checkmat end
	return Duel.GetMatchingGroup(Fusion.IsMonsterFilter(Card.IsAbleToGrave),tp,LOCATION_DECK,0,nil),s.checkmat
end
function s.extratg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetPossibleOperationInfo(0,CATEGORY_TOGRAVE,nil,0,tp,LOCATION_DECK)
end