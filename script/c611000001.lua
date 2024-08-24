--覇王龍ズァーク (Ultimate)
--Supreme King Z-ARC (Ultimate)
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	Pendulum.AddProcedure(c,true)
	--Fusion Material
	local fe=Effect.CreateEffect(c)
	fe:SetType(EFFECT_TYPE_SINGLE)
	fe:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	fe:SetCode(EFFECT_FUSION_MATERIAL)
	fe:SetCondition(s.fscon)
	c:RegisterEffect(fe)
	s.min_material_count=0
	s.max_material_count=0
	--Pendulum Summon
	Pendulum.AddProcedure(c,true)
	--Tōgō shōkan
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(id,0))
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetValue(SUMMON_TYPE_RITUAL+SUMMON_TYPE_FUSION+SUMMON_TYPE_SYNCHRO+SUMMON_TYPE_XYZ+SUMMON_TYPE_PENDULUM+SUMMON_TYPE_LINK)
	e0:SetCondition(s.lispcon)
	e0:SetTarget(s.lisptg)
	e0:SetOperation(s.lispop)
	c:RegisterEffect(e0)
	--Level/Rank
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_RANK_LEVEL_S)
	c:RegisterEffect(e1)
	--Treated as Link
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_ADD_TYPE)
	e2:SetValue(TYPE_LINK)
	c:RegisterEffect(e2)
	--Add Link Maker
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetCode(EFFECT_CHANGE_LINK_FINAL)
	e3:SetValue(8)
	c:RegisterEffect(e3)	
	--Link Arrow
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetCode(EFFECT_ADD_LINKMARKER)
	e4:SetValue(LINK_MARKER_TOP_LEFT+LINK_MARKER_LEFT+LINK_MARKER_BOTTOM_LEFT+LINK_MARKER_BOTTOM+LINK_MARKER_BOTTOM_RIGHT+LINK_MARKER_RIGHT+LINK_MARKER_TOP_RIGHT+LINK_MARKER_TOP)
	c:RegisterEffect(e4)
	--splimit
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e5:SetCode(EFFECT_SPSUMMON_CONDITION)
	e5:SetValue(s.splimit)
	c:RegisterEffect(e5)
	--Special Summon Pen
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(id,1))
	e6:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetRange(LOCATION_PZONE)
	e6:SetCost(s.spcostp)
	e6:SetTarget(s.sptgp)
	e6:SetOperation(s.spopp)
	c:RegisterEffect(e6)
	--Special Summon Face-Up Extra
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(id,2))
	e7:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e7:SetType(EFFECT_TYPE_FIELD)
	e7:SetCode(EFFECT_SPSUMMON_PROC)
	e7:SetRange(LOCATION_EXTRA)
	e7:SetValue(SUMMON_TYPE_PENDULUM)
	e7:SetCondition(s.spcon)
	c:RegisterEffect(e7)
	--Destroy and Damage
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(id,3))
	e8:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e8:SetCost(s.damcost)
	e8:SetTarget(s.damtg)
	e8:SetOperation(s.damop)
	c:RegisterEffect(e8)
	--indestructable/immune/intargetable
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_SINGLE)
	e9:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e9:SetRange(LOCATION_MZONE)
	e9:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e9:SetCondition(s.indcon)
	e9:SetValue(1)
	c:RegisterEffect(e9)
	local e10=e9:Clone()
	e10:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e10)
	local e11=e9:Clone()
	e11:SetCode(EFFECT_IMMUNE_EFFECT)
	e11:SetValue(s.imfilter)
	c:RegisterEffect(e11)
	local e12=e9:Clone()
	e12:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e12:SetValue(s.tgval)
	c:RegisterEffect(e12)
	--immune to Ritual/Fusion/Synchro/Xyz/Link/Pendulum
	local e13=Effect.CreateEffect(c)
	e13:SetType(EFFECT_TYPE_FIELD)
	e13:SetCode(EFFECT_IMMUNE_EFFECT)
	e13:SetRange(LOCATION_MZONE)
	e13:SetTargetRange(LOCATION_MZONE,0)
	e13:SetValue(s.efilter)
	c:RegisterEffect(e13)
	--Special Summon SK Dragon
	local e14=Effect.CreateEffect(c)
	e14:SetDescription(aux.Stringid(id,4))
	e14:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e14:SetProperty(EFFECT_FLAG_DELAY)
	e14:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e14:SetCode(EVENT_BATTLE_DESTROYING)
	e14:SetCondition(aux.bdocon)
	e14:SetTarget(s.sptg2)
	e14:SetOperation(s.spop2)
	c:RegisterEffect(e14)
	--Destroy Drawn Mzone
	local e15=Effect.CreateEffect(c)
	e15:SetDescription(aux.Stringid(13331639,0))
	e15:SetCategory(CATEGORY_DESTROY)
	e15:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e15:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e15:SetCode(EVENT_TO_HAND)
	e15:SetRange(LOCATION_MZONE)
	e15:SetCondition(s.descon)
	e15:SetTarget(s.destg)
	e15:SetOperation(s.desop)
	c:RegisterEffect(e15)
	local e16=e15:Clone()
	e16:SetDescription(aux.Stringid(13331639,0))
	e16:SetRange(LOCATION_PZONE)
	c:RegisterEffect(e16)
	--Place Pendulum Zone
	local e17=Effect.CreateEffect(c)
	e17:SetDescription(aux.Stringid(13331639,3))
	e17:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e17:SetCode(EVENT_DESTROYED)
	e17:SetProperty(EFFECT_FLAG_DELAY)
	e17:SetCondition(s.pencon)
	e17:SetTarget(s.pentg)
	e17:SetOperation(s.penop)
	c:RegisterEffect(e17)
	--Activate Limit
	local e18=Effect.CreateEffect(c)
	e18:SetType(EFFECT_TYPE_FIELD)
	e18:SetCode(EFFECT_CANNOT_ACTIVATE)
	e18:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e18:SetRange(LOCATION_PZONE)
	e18:SetTargetRange(0,1)
	e18:SetValue(s.limval)
	c:RegisterEffect(e18)

end
s.listed_series={0xf8,0x20f8}
s.listed_names={76794549}
--fusion material
function s.fscon(e,g,gc,chkfnf)
	if g==nil then return true end
	return false
end
--Tōgō shōkan
function s.matfilter1(c,sg) return c:IsFaceup() and c:IsRace(RACE_DRAGON) and c:IsCanBeRitualMaterial()  and c:IsType(TYPE_RITUAL) end
function s.matfilter2(c,sg) return c:IsFaceup() and c:IsRace(RACE_DRAGON) and c:IsCanBeFusionMaterial()  and c:IsType(TYPE_FUSION) end
function s.matfilter3(c,sg) return c:IsFaceup() and c:IsRace(RACE_DRAGON) and c:IsCanBeSynchroMaterial()  and c:IsType(TYPE_SYNCHRO) end
function s.matfilter4(c,sg) return c:IsFaceup() and c:IsRace(RACE_DRAGON) and c:IsCanBeXyzMaterial()  and c:IsType(TYPE_XYZ) end
function s.matfilter5(c,sg) return c:IsFaceup() and c:IsRace(RACE_DRAGON) and c:IsType(TYPE_PENDULUM) and not c:IsForbidden() end
function s.matfilter6(c,sg) return c:IsRace(RACE_DRAGON) and c:IsCanBeLinkMaterial()  and c:IsType(TYPE_LINK) and c:IsLink(3) end
function s.lirescon(sg,e,tp,mg)
	return aux.ChkfMMZ(1)(sg,e,tp,mg) 
		and sg:IsExists(s.matfilter1,1,nil,sg)
		and sg:IsExists(s.matfilter2,1,nil,sg)
		and sg:IsExists(s.matfilter3,1,nil,sg)
		and sg:IsExists(s.matfilter4,1,nil,sg)
		and sg:IsExists(s.matfilter5,1,nil,sg)
		and sg:IsExists(s.matfilter6,1,nil,sg)
end
function s.lispcon(e,c)
	local c=e:GetHandler()
	if c==nil then return true end
	local tp=c:GetControler()
	local rg1=Duel.GetMatchingGroup(s.matfilter1,tp,LOCATION_MZONE,0,c)
	local rg2=Duel.GetMatchingGroup(s.matfilter2,tp,LOCATION_MZONE,0,c)
	local rg3=Duel.GetMatchingGroup(s.matfilter3,tp,LOCATION_MZONE,0,c)
	local rg4=Duel.GetMatchingGroup(s.matfilter4,tp,LOCATION_MZONE,0,c)
	local rg5=Duel.GetMatchingGroup(s.matfilter5,tp,LOCATION_MZONE,0,c)
	local rg6=Duel.GetMatchingGroup(s.matfilter6,tp,LOCATION_MZONE,0,c)
	local rg=rg1:Clone()
	rg:Merge(rg2)
	rg:Merge(rg3)
	rg:Merge(rg4)
	rg:Merge(rg5)
	rg:Merge(rg6)
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1 and #rg1>0 and #rg2>0 and #rg3>0 and #rg4>0 and #rg5>0 and #rg6>0
		and aux.SelectUnselectGroup(rg,e,tp,6,6,s.lirescon,0)
end
function s.lisptg(e,tp,eg,ep,ev,re,r,rp,c)
	local c=e:GetHandler()
	local rg=Duel.GetMatchingGroup(s.matfilter1,tp,LOCATION_MZONE,0,c)
	rg:Merge(Duel.GetMatchingGroup(s.matfilter2,tp,LOCATION_MZONE,0,c))
	rg:Merge(Duel.GetMatchingGroup(s.matfilter3,tp,LOCATION_MZONE,0,c))
	rg:Merge(Duel.GetMatchingGroup(s.matfilter4,tp,LOCATION_MZONE,0,c))
	rg:Merge(Duel.GetMatchingGroup(s.matfilter5,tp,LOCATION_MZONE,0,c))
	rg:Merge(Duel.GetMatchingGroup(s.matfilter6,tp,LOCATION_MZONE,0,c))
	local g=aux.SelectUnselectGroup(rg,e,tp,6,6,s.lirescon,1,tp,534,nil,nil,true)
	if #g>0 then
		g:KeepAlive()
		e:SetLabelObject(g)
		return true
	end
	return false
end
function s.lispop(e,tp,eg,ep,ev,re,r,rp,c)
	local c=e:GetHandler()
	local g=e:GetLabelObject()
	if not g then return end
	c:SetMaterial(g)
	Duel.Remove(g,POS_FACEUP,REASON_COST+REASON_MATERIAL+REASON_RITUAL+REASON_FUSION+REASON_SYNCHRO+REASON_XYZ+REASON_LINK)
	c:CompleteProcedure()
	g:DeleteGroup()
end
--splimit
function s.splimit(e,se,sp,st)
	local code=Duel.GetChainInfo(0,CHAININFO_TRIGGERING_CODE)
	return se:GetHandler():IsCode(76794549) or code==76794549
end
--Special Summon Pen
function s.cfilter(c,ft,tp)
	return c:IsSetCard(0xf8) and (ft>0 or (c:IsControler(tp) and c:GetSequence()<5)) and (c:IsControler(tp) or c:IsFaceup())
end
function s.spcostp(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then return ft>-1 and Duel.CheckReleaseGroupCost(tp,s.cfilter,1,false,nil,nil,ft,tp) end
	local g=Duel.SelectReleaseGroupCost(tp,s.cfilter,1,1,false,nil,nil,ft,tp)
	Duel.Release(g,REASON_COST)
end
function s.sptgp(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,true,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function s.spopp(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP)
	end
end
--Special Summon Face-Up Extra
function s.spcon(e,c)
	if c==ni then return true end
	if not e:GetHandler():IsFaceup() then return end
	local tp=c:GetControler()
	local leftpc,rightpc=Duel.GetFieldCard(tp,LOCATION_PZONE,0),Duel.GetFieldCard(tp,LOCATION_PZONE,1)
	if leftpc==nil or rightpc==nil then return false end
	local leftscl,rightscl=leftpc:GetLeftScale(),rightpc:GetRightScale()
	local diffscale=math.abs(leftscl-rightscl)
	local maxscale=math.max(leftscl,rightscl)
	if diffscale>=2 and maxscale>12 then
		return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0,nil)==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	end
end
--Destroy and Damage
function s.damcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetAttackAnnouncedCount()==0 end
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_CANNOT_ATTACK)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_OATH)
	e4:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e4,true)
end
function s.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,e:GetHandler()) end
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,#sg,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,PLAYER_ALL,0)
end
function s.damop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,nil,tp,0,LOCATION_ONFIELD,1,15,nil)
	if Duel.Destroy(g,REASON_EFFECT)>0 then
		local dg=Duel.GetOperatedGroup()
		Duel.BreakEffect()
		local dam=dg:GetSum(Card.GetPreviousAttackOnField)
		Duel.Damage(1-tp,dam,REASON_EFFECT)
	end
end
--Indestructable/Immune/Intargetable
function s.indfilter(c,tpe)
	return (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup()) and c:IsType(tpe)
end
function s.indcon(e)
	return  Duel.IsExistingMatchingCard(s.indfilter,0,LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_GRAVE+LOCATION_REMOVED,1,nil,TYPE_RITUAL)
		or  Duel.IsExistingMatchingCard(s.indfilter,0,LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_GRAVE+LOCATION_REMOVED,1,nil,TYPE_FUSION)
		or  Duel.IsExistingMatchingCard(s.indfilter,0,LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_GRAVE+LOCATION_REMOVED,1,nil,TYPE_SYNCHRO)
		or  Duel.IsExistingMatchingCard(s.indfilter,0,LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_GRAVE+LOCATION_REMOVED,1,nil,TYPE_XYZ)
		or  Duel.IsExistingMatchingCard(s.indfilter,0,LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_GRAVE+LOCATION_REMOVED,1,nil,TYPE_LINK)
		or  Duel.IsExistingMatchingCard(s.indfilter,0,LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_GRAVE+LOCATION_REMOVED,1,nil,TYPE_PENDULUM)
end
function s.imfilter(e,te)
	if not te then return false end
	return te:IsHasCategory(CATEGORY_TOHAND+CATEGORY_DESTROY+CATEGORY_REMOVE+CATEGORY_TODECK+CATEGORY_RELEASE+CATEGORY_TOGRAVE)
end
function s.tgval(e,re,rp)
	return rp~=e:GetOwnerPlayer()
end
--immune to Ritual/Fusion/Synchro/Xyz/Link/Pendulum
function s.efilter(e,te)
	return te:IsActiveType(TYPE_RITUAL+TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK+TYPE_PENDULUM) and te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
--Special Summon SK Dragon
function s.spfilter(c,e,tp,rp)
	if c:IsLocation(LOCATION_EXTRA) and Duel.GetLocationCountFromEx(tp,rp,nil,c)<=0 then return false end
	return c:IsSetCard(0x20f8) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return loc~=0 and not Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_EXTRA,0,2,nil,e,tp,rp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_EXTRA)
end
function s.spop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_EXTRA,0,2,2,nil,e,tp,rp)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	end
end
--Destroy Drawn Mzone
function s.descon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()~=PHASE_DRAW and eg:IsExists(Card.IsControler,1,nil,1-tp)
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetCard(eg)
	local g=eg:Filter(Card.IsControler,nil,1-tp)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,0,0)
end
function s.desfilter(c,e,tp)
	return c:IsRelateToEffect(e) and c:IsControler(1-tp)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(s.desfilter,nil,e,tp)
	if #g>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end
--Place Pendulum Zone
function s.pencon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsFaceup()
end
function s.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckPendulumZones(tp) end
end
function s.penop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.CheckPendulumZones(tp) then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end
--Activate Limit
function s.limval(e,re,rp)
	local rc=re:GetHandler()
	return rc:IsLocation(LOCATION_MZONE) and re:IsActiveType(TYPE_MONSTER)
		and rc:IsType(TYPE_RITUAL+TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK)
end