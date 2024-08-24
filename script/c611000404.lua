--超魔導騎士－マジシャン・オブ・ミレニアム・アイズ
--Magician of Millennium-Eyes The Ultimate Wizard Knight
local s,id=GetID()
function s.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	Fusion.AddProcMix(c,true,true,CARD_DARK_MAGICIAN,{41578483,s.ffilter})
	--register effect
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetCode(EVENT_SPSUMMON_SUCCESS)
	e0:SetCondition(s.regcon)
	e0:SetOperation(s.regop)
	c:RegisterEffect(e0)
	--material count check
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_MATERIAL_CHECK)
	e1:SetValue(s.valcheck)
	e1:SetLabelObject(e0)
	c:RegisterEffect(e1)
	--Immune
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--Monster with same name as Xyz Material cannot attack
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_ATTACK)
	e4:SetTargetRange(0,LOCATION_MZONE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTarget(s.disatttg)
	c:RegisterEffect(e4)
	--Their effects on opponent's field/GY are negated
	local e5=e4:Clone()
	e5:SetCode(EFFECT_DISABLE)
	e5:SetTargetRange(0,LOCATION_ONFIELD+LOCATION_GRAVE)
	c:RegisterEffect(e5)
	--Their activated effects are negated
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EVENT_CHAIN_SOLVING)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCondition(s.discon)
	e6:SetOperation(s.disop)
	c:RegisterEffect(e6)
	--Gain ATK/DEF
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetCode(EFFECT_UPDATE_ATTACK)
	e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e7:SetRange(LOCATION_MZONE)
	e7:SetValue(s.atkval)
	c:RegisterEffect(e7)
	local e8=e7:Clone()
	e8:SetCode(EFFECT_UPDATE_DEFENSE)
	e8:SetValue(s.defval)
	c:RegisterEffect(e8)
	--Destruction replacement
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e9:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e9:SetCode(EFFECT_DESTROY_REPLACE)
	e9:SetRange(LOCATION_MZONE)
	e9:SetTarget(s.reptg)
	c:RegisterEffect(e9)

end
s.material={CARD_DARK_MAGICIAN,41578483}
s.listed_names={CARD_DARK_MAGICIAN,41578483}
s.material_setcode={0x1110,0x10a2}
--fusion material
function s.ffilter(c,fc,sumtype,tp)
	return c:IsAttribute(ATTRIBUTE_DARK,fc,sumtype,tp) and c:IsRace(RACE_SPELLCASTER,fc,sumtype,tp) and c:IsType(TYPE_FUSION,fc,sumtype,tp)
end
--material count check
function s.mcheck(c)
	return c:IsCode(41578483) or c:IsCode(CARD_DARK_MAGICIAN)
end
function s.valcheck(e,c)
	local g=c:GetMaterial()
	local ct=g:FilterCount(s.mcheck,nil)
	e:GetLabelObject():SetLabel(ct)
end
--register effect
function s.regcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_FUSION) and e:GetLabel()>0
end
function s.chkfilter(c,label)
	return c:GetFlagEffect(label)>0
end
function s.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=e:GetLabel()
	--Target and attach
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DISABLE+CATEGORY_NEGATE+CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(ct)
	e1:SetTarget(s.undertg)
	e1:SetOperation(s.underop)
	c:RegisterEffect(e1)
end
function s.underfilter(c)
	return not c:IsType(TYPE_TOKEN)
end
function s.undertg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD|LOCATION_GRAVE) and chkc:IsControler(1-tp) and s.underfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.underfilter,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,s.underfilter,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,1,1,nil)
end
function s.underop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		Duel.Overlay(c,tc,true)
		tc:CancelToGrave(true)
	end
end
--Cannot attack
function s.disatttg(e,c)
	local code=c:GetOriginalCode()
	return e:GetHandler():GetOverlayGroup():IsExists(Card.IsCode,1,nil,code)
end
--Their activated effects are negated
function s.discon(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	local c=e:GetHandler()
	local code=re:GetHandler():GetOriginalCodeRule()
	return rp==1-tp and c:GetOverlayGroup():IsExists(Card.IsCode,1,nil,code)
end
function s.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,id)
	Duel.NegateEffect(ev)
end
--Gain ATK/DEF
function s.nmonsfilter(c)
	return not c:IsMonster()
end
function s.atkfilter(c)
	return c:IsMonster() and c:GetAttack()>=0
end
function s.atkval(e,c)
	local g=e:GetHandler():GetOverlayGroup():Filter(s.atkfilter,nil)
	local ng=e:GetHandler():GetOverlayGroup():Filter(s.nmonsfilter,nil)
	return g:GetSum(Card.GetAttack)+(#ng*1000)
end
function s.deffilter(c)
	return c:IsMonster() and c:GetDefense()>=0
end
function s.defval(e,c)
	local g=e:GetHandler():GetOverlayGroup():Filter(s.deffilter,nil)
	local ng=e:GetHandler():GetOverlayGroup():Filter(s.nmonsfilter,nil)
	return g:GetSum(Card.GetDefense)+(#ng*1000)
end
--Destruction replacement
function s.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return not c:IsReason(REASON_REPLACE) and c:IsReason(REASON_EFFECT)
		and c:CheckRemoveOverlayCard(tp,1,REASON_EFFECT) end
	if Duel.SelectEffectYesNo(tp,c,96) then
		c:RemoveOverlayCard(tp,1,1,REASON_EFFECT)
		return true
	else return false end
end