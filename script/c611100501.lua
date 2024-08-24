--スフィア・フィールド
--Sphere Field
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	-- Turn player Special Summon 1 Fusion, Synchro, Xyz or Link monster from their Extra Deck
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e1:SetProperty(EFFECT_FLAG_BOTH_SIDE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_FZONE)
	e1:SetCost(s.spcost)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
end
function s.GetSummonType(c)
	local summon_type_table={
		[TYPE_FUSION] = SUMMON_TYPE_FUSION,
		[TYPE_SYNCHRO] = SUMMON_TYPE_SYNCHRO,
		[TYPE_XYZ] = SUMMON_TYPE_XYZ,
		[TYPE_LINK] = SUMMON_TYPE_LINK
	}
	return summon_type_table[c:GetType()&TYPE_EXTRA] or 0
end
function s.GetReasonType(c)
	local reason_type_table={
		[TYPE_RITUAL] = REASON_RITUAL,
		[TYPE_FUSION] = REASON_FUSION,
		[TYPE_SYNCHRO] = REASON_SYNCHRO,
		[TYPE_XYZ] = REASON_XYZ,
		[TYPE_LINK] = REASON_LINK
	}
	return reason_type_table[c:GetType()&TYPE_EXTRA] or 0
end
function s.rescon(sg,e,tp,mg)
	return Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,sg)
end
function s.costfilter(c)
	return c:IsMonster() and c:IsAbleToGraveAsCost()
end
function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(s.costfilter,tp,LOCATION_MZONE,0,nil)
	if chk==0 then return aux.SelectUnselectGroup(g,e,tp,2,2,s.rescon,0) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local sg=aux.SelectUnselectGroup(g,e,tp,2,2,s.rescon,1,tp,HINTMSG_TOGRAVE,s.rescon)
	Duel.SendtoGrave(sg,REASON_COST)
	sg:KeepAlive()
	e:SetLabelObject(sg)
end
function s.spfilter(c,e,tp,sg)
	local pg=aux.GetMustBeMaterialGroup(tp,Group.CreateGroup(),tp,c,nil,s.GetReasonType(c))
	return #pg<=0 and c:IsType(TYPE_EXTRA) and c:IsCanBeSpecialSummoned(e,s.GetSummonType(c),tp,false,false)
		and Duel.GetLocationCountFromEx(tp,tp,sg,c)>0
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local xyzmat=e:GetLabelObject()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sc=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp):GetFirst()
	if sc and Duel.SpecialSummon(sc,s.GetSummonType(sc),tp,tp,false,false,POS_FACEUP)>0 then
		if sc:IsType(TYPE_XYZ) and #xyzmat>0 then
			Duel.Overlay(sc,xyzmat)
		end
		sc:CompleteProcedure()
	end
	xyzmat:DeleteGroup()
end
