--転生の聖域
--Reincarnation Sanctuary
--Tensei Extra Summon
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Reincarnation Summon effect
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(s.reincsumcon)
	e2:SetTarget(s.reincsumtg)
	e2:SetOperation(s.reincsumop)
	e2:SetValue(s.reincvalue)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTargetRange(LOCATION_EXTRA,0)
	e3:SetTarget(s.reinctg)
	e3:SetLabelObject(e2)
	c:RegisterEffect(e3)
end
function s.reinctg(e,c)
	return c:IsMonster() and c:IsType(TYPE_EXTRA)
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
function s.reincvalue(c,e)
	return s.GetSummonType(c)
end
function s.reincmatfilter(c,lc,tp)
	return c:IsFaceup() and c:IsMonster() and c:IsType(TYPE_EXTRA)
		and c:IsSummonCode(lc,s.GetSummonType(c),tp,lc:GetCode()) and c:IsCanBeMaterial(s.GetSummonType(c))
		and Duel.GetLocationCountFromEx(tp,tp,c,lc)>0
end
function s.reincsumcon(e,c,must,g,min,max)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(s.reincmatfilter,tp,LOCATION_MZONE,0,nil,c,tp)
	local mustg=Auxiliary.GetMustBeMaterialGroup(tp,g,tp,c,g,s.GetReasonType(c))
	if must then mustg:Merge(must) end
	return ((#mustg==1 and s.reincmatfilter(mustg:GetFirst(),c,tp)) or (#mustg==0 and #g>0))
		--and not Duel.HasFlagEffect(tp,id)
end
function s.reincsumtg(e,tp,eg,ep,ev,re,r,rp,chk,c,must,g,min,max)
	local g=Duel.GetMatchingGroup(s.reincmatfilter,tp,LOCATION_MZONE,0,nil,c,tp)
	local mustg=Auxiliary.GetMustBeMaterialGroup(tp,g,tp,c,g,s.GetReasonType(c))
	if must then mustg:Merge(must) end
	if #mustg>0 then
		if #mustg>1 then
			return false
		end
		mustg:KeepAlive()
		e:SetLabelObject(mustg)
		return true
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_LMATERIAL)
	local tc=g:SelectUnselect(Group.CreateGroup(),tp,false,true)
	if tc then
		local sg=Group.FromCards(tc)
		sg:KeepAlive()
		e:SetLabelObject(sg)
		return true
	else return false end
end
function s.reincsumop(e,tp,eg,ep,ev,re,r,rp,c,must,g,min,max)
	Duel.Hint(HINT_CARD,0,id)
	local mg=e:GetLabelObject()
	c:SetMaterial(mg)
	if c:IsType(TYPE_XYZ) then
		Duel.Overlay(c,mg,false)
	else
		Duel.SendtoGrave(mg,REASON_MATERIAL|s.GetReasonType(c))
	end
	Duel.RegisterFlagEffect(tp,id,RESET_PHASE|PHASE_END,0,1)
end