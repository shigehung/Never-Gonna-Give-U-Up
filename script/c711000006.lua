--Ultimate Monster
local s,id=GetID()
function s.initial_effect(c)
	--unaffected
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_ONFIELD)
	e1:SetValue(s.efilter)
	c:RegisterEffect(e1)
	--cannot be target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_ONFIELD)
	e2:SetValue(s.efilter)
	c:RegisterEffect(e2)
	--cannot be select
	local e3=e2:Clone()
	e3:SetCode(EFFECT_CANNOT_SELECT_EFFECT_TARGET)
	c:RegisterEffect(e3)
	--cannot be destroyed by effect
	local e4=e2:Clone()
	e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e4)
	--cannot be destroyed by battle
	local e5=e2:Clone()
	e5:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	c:RegisterEffect(e5)
	--cannot be tributed
	local e6=e2:Clone()
	e6:SetCode(EFFECT_CANNOT_RELEASE)
	c:RegisterEffect(e6)
	local e7=e2:Clone()
	e7:SetCode(EFFECT_UNRELEASABLE_SUM)
	c:RegisterEffect(e7)
	local e8=e2:Clone()
	e8:SetCode(EFFECT_UNRELEASABLE_NONSUM)
	c:RegisterEffect(e8)
		--cannot be used as cost
	local e9=e2:Clone()
	e9:SetCode(EFFECT_CANNOT_USE_AS_COST)
	c:RegisterEffect(e9)
	local e10=e2:Clone()
	e10:SetCode(EFFECT_CANNOT_TO_GRAVE_AS_COST)
	c:RegisterEffect(e10)
	--cannot return
	local e11=e2:Clone()
	e11:SetCode(EFFECT_CANNOT_TO_HAND)
	c:RegisterEffect(e11)
	local e12=e2:Clone()
	e12:SetCode(EFFECT_CANNOT_TO_DECK)
	c:RegisterEffect(e12)
	--cannot be remove
	local e13=e2:Clone()
	e13:SetCode(EFFECT_CANNOT_REMOVE)
	c:RegisterEffect(e13)
	--cannot to GY
	local e14=e2:Clone()
	e14:SetCode(EFFECT_CANNOT_TO_GRAVE)
	c:RegisterEffect(e14)
	--cannot place counter
	local e15=e2:Clone()
	e15:SetCode(EFFECT_CANNOT_PLACE_COUNTER)
	c:RegisterEffect(e15)
	--cannot change control
	local e16=e2:Clone()
	e16:SetCode(EFFECT_CANNOT_CHANGE_CONTROL)
	c:RegisterEffect(e16)
	--cannot change pos
	local e17=e2:Clone()
	e17:SetCode(EFFECT_CANNOT_CHANGE_POS_E)
	c:RegisterEffect(e17)
	--cannot be material
	local e18=e2:Clone()
	e18:SetCode(EFFECT_CANNOT_BE_MATERIAL)
	e18:SetValue(TYPE_FUSION+TYPE_RITUAL+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK+TYPE_PENDULUM)
	c:RegisterEffect(e18)
	--cannot affect by necro
	local e19=e2:Clone()
	e19:SetCode(EFFECT_NECRO_VALLEY_IM)
	c:RegisterEffect(e19)
	--cannot tribute by efffect
	local e20=e2:Clone()
	e20:SetCode(EFFECT_UNRELEASABLE_EFFECT)
	c:RegisterEffect(e20)
	local e21=e2:Clone()
	e21:SetCode(EFFECT_CANNOT_DISABLE)
	c:RegisterEffect(e21)
end
function s.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end





