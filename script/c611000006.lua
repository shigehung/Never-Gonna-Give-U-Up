--アストログラフ・マジシャン (Ultimate)
--Astrograph Sorcerer (Ultimate)
local s,id=GetID()
function s.initial_effect(c)
	Pendulum.AddProcedure(c)
	--Special Summon itself
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_DESTROYED)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_HAND)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	--Special Summon Supreme King Z-Arc
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(s.zarccost)
	e2:SetTarget(s.zarctg)
	e2:SetOperation(s.zarcop)
	c:RegisterEffect(e2)
	--Place or Special summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,2))
	e3:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_PZONE)
	e3:SetTarget(s.rptg)
	e3:SetOperation(s.rpop)
	c:RegisterEffect(e3)
end
--Name =		Zarc,	Ritual_D  Fusion_D Synchro_D Xyz_D,  Link_D	Pen_D	Stagazer Timegazer
s.listed_names={13331639,611000004,41209827,82044279,16195942,611000002,16178681,94415058,20409757}
s.listed_series={0x10f2,0x2073,0x2017,0x1046}
local ZARC_LOC=LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_EXTRA+LOCATION_DECK+LOCATION_HAND
--Special Summon itself
function s.spcfilter(c,e,tp)
	return c:IsPreviousControler(tp) and c:IsPreviousLocation(LOCATION_ONFIELD)
		and ((c:IsCanBeEffectTarget(e) and (c:IsLocation(LOCATION_SZONE+LOCATION_GRAVE+LOCATION_MZONE) or (c:IsLocation(LOCATION_REMOVED) and c:IsFaceup()))) or (c:IsLocation(LOCATION_HAND+LOCATION_DECK) or (c:IsLocation(LOCATION_EXTRA) and c:IsFaceup())))
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return eg:IsExists(s.spcfilter,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,1,tp,false,false) end
	local g=eg:Filter(s.spcfilter,nil,e,tp)
	Duel.SetTargetCard(g)
	if g:FilterCount(Card.IsLocation,nil,LOCATION_GRAVE)>0 then
		Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g:Filter(Card.IsLocation,nil,LOCATION_GRAVE),g:FilterCount(Card.IsLocation,nil,LOCATION_GRAVE),tp,LOCATION_GRAVE)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,tp,LOCATION_HAND)
end
function s.spcfilterchk(c,tp)
	return c:IsPreviousControler(tp) and c:IsPreviousLocation(LOCATION_ONFIELD)
		and (c:IsLocation(LOCATION_SZONE+LOCATION_GRAVE+LOCATION_MZONE) or (c:IsLocation(LOCATION_REMOVED) and c:IsFaceup())) or (c:IsLocation(LOCATION_HAND+LOCATION_DECK) or (c:IsLocation(LOCATION_EXTRA) and c:IsFaceup())) and not Duel.GetFieldCard(tp,c:GetPreviousLocation(),c:GetPreviousSequence())
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local g=Duel.GetTargetCards(e)
	local freezone=true
	for tc in g:Iter() do
		if Duel.GetFieldCard(tp,tc:GetPreviousLocation(),tc:GetPreviousSequence()) then freezone=false end
	end
	if Duel.SpecialSummon(c,1,tp,tp,false,false,POS_FACEUP)>0 and #g>0 and freezone==true and Duel.SelectEffectYesNo(tp,c) then
		g:KeepAlive()
		--spsummon
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
		e1:SetCode(EVENT_CUSTOM+id)
		e1:SetLabelObject(g)
		e1:SetTarget(s.rettg)
		e1:SetOperation(s.retop)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
		Duel.RaiseSingleEvent(c,EVENT_CUSTOM+id,e,r,tp,tp,0)
	end
end
function s.rettg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=e:GetLabelObject()
	Duel.SetTargetCard(g)
	g:DeleteGroup()
end
function s.retop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetTargetCards(e):Filter(s.spcfilterchk,nil,tp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_BECOME_LINKED_ZONE)
	e1:SetValue(0xffffff)
	Duel.RegisterEffect(e1,tp)
	for tc in aux.Next(g) do
		if tc:IsPreviousLocation(LOCATION_PZONE) then
			local seq=0
			if tc:GetPreviousSequence()==7 or tc:GetPreviousSequence()==6 then seq=1 end
			Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,tc:GetPreviousPosition(),true,(1<<seq))
		else
			Duel.MoveToField(tc,tp,tp,tc:GetPreviousLocation(),tc:GetPreviousPosition(),true,(1<<tc:GetPreviousSequence()))
		end
	end
	e1:Reset()
end
--Special Summon Supreme King Z-Arc
function s.zarccost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function s.zarcspfilter(c,e,tp,sg)
	return c:IsCode(13331639) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,sg+e:GetHandler(),c)>0
end
function s.chk(c,sg,g,code,...)
	if not c:IsCode(code) then return false end
	local res
	if ... then
		g:AddCard(c)
		res=sg:IsExists(s.chk,1,g,sg,g,...)
		g:RemoveCard(c)
	else
		res=true
	end
	return res
end
function s.rescon(sg,e,tp,mg)
	return sg:IsExists(s.chk,1,nil,sg,Group.CreateGroup(),611000004,41209827,82044279,16195942,611000002,16178681) and Duel.GetLocationCountFromEx(tp,tp,sg+e:GetHandler(),TYPE_FUSION)>0
end
function s.zarctg(e,tp,eg,ep,ev,re,r,rp,chk)
	local rg=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,ZARC_LOC,0,nil)
	local g1=rg:Filter(Card.IsCode,nil,611000004)
	local g2=rg:Filter(Card.IsCode,nil,41209827)
	local g3=rg:Filter(Card.IsCode,nil,82044279)
	local g4=rg:Filter(Card.IsCode,nil,16195942)
	local g5=rg:Filter(Card.IsCode,nil,611000002)
	local g6=rg:Filter(Card.IsCode,nil,16178681)
	local g=g1:Clone()
	g:Merge(g2)
	g:Merge(g3)
	g:Merge(g4)
	g:Merge(g5)
	g:Merge(g6)
	if chk==0 then return #g1>0 and #g2>0 and #g3>0 and #g4>0 and #g5>0 and #g6>0 and Duel.IsExistingMatchingCard(s.zarcspfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,g) and aux.SelectUnselectGroup(g,e,tp,6,6,s.rescon,0) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,6,tp,ZARC_LOC)
end
function s.zarcop(e,tp,eg,ep,ev,re,r,rp)
	local rg=Duel.GetMatchingGroup(aux.NecroValleyFilter(Card.IsAbleToRemove),tp,ZARC_LOC,0,nil):Filter(Card.IsCode,nil,611000004,41209827,82044279,16195942,611000002,16178681)
	local g=aux.SelectUnselectGroup(rg,e,tp,6,6,s.rescon,1,tp,HINTMSG_REMOVE,nil,nil,true)
	if Duel.Remove(g,POS_FACEUP,REASON_EFFECT)>3 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tc=Duel.SelectMatchingCard(tp,s.zarcspfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,g):GetFirst()
		if tc and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)>0 and tc:IsOriginalCode(611000001) then
			tc:CompleteProcedure()
		end
	end
	g:DeleteGroup()
end
--Place or Special summon
function s.rpfilter(c,e,tp) return (c:IsCode(94415058) or c:IsCode(20409757)) and not c:IsForbidden() end
function s.rptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(s.rpfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,nil,e,tp)
	if chk==0 then
		return aux.SelectUnselectGroup(g,e,tp,1,2,aux.dncheck,0)
	end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
	Duel.SetPossibleOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE)
end
function s.rpop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if not Duel.IsExistingMatchingCard(s.rpfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) then return end
	if Duel.IsExistingMatchingCard(nil,tp,LOCATION_PZONE,0,1,e:GetHandler()) then e:SetLabel(1) else e:SetLabel(0) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELF)
	--local g=Duel.SelectMatchingCard(tp,s.rpfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,2,nil,e,tp)
	local g=Duel.GetMatchingGroup(s.rpfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,nil,e,tp)
	local sg=aux.SelectUnselectGroup(g,e,tp,1,2,aux.dncheck,1,tp)
	if e:GetLabel()==0 and Duel.Destroy(c,REASON_EFFECT)>0 then
		tc=sg:GetFirst()
		while(tc)
		do
			local op=0
			if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and tc:IsCanBeSpecialSummoned(e,0,tp,false,false) then
				op=Duel.SelectOption(tp,aux.Stringid(id,3),aux.Stringid(id,4))
			else
				op=Duel.SelectOption(tp,aux.Stringid(id,3))
			end
			if op==0 then
				Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
			else
				Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
			end
			tc=sg:GetNext()
		end
	else --IsExisting in other pen zone
		local dg=Duel.GetFieldGroup(tp,LOCATION_PZONE,0)
		if Duel.SelectYesNo(tp,aux.Stringid(id,5)) then
			if Duel.Destroy(dg,REASON_EFFECT)~=2 then return end
			tc=sg:GetFirst()
			while(tc)
			do
				local op=0
				if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and tc:IsCanBeSpecialSummoned(e,0,tp,false,false) then
					op=Duel.SelectOption(tp,aux.Stringid(id,3),aux.Stringid(id,4))
				else
					op=Duel.SelectOption(tp,aux.Stringid(id,3))
				end
				if op==0 then
					Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
				else
					Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
				end
				tc=sg:GetNext()
			end
		else --non-destroy
			if Duel.Destroy(c,REASON_EFFECT)>0 then
				if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
					tc=sg:GetFirst()
					while(tc)
					do
						local op=0
						if Duel.GetFieldGroupCount(tp,LOCATION_PZONE,0)==1 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and tc:IsCanBeSpecialSummoned(e,0,tp,false,false) then
							op=Duel.SelectOption(tp,aux.Stringid(id,4),aux.Stringid(id,3))
						elseif Duel.GetFieldGroupCount(tp,LOCATION_PZONE,0)==2 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and tc:IsCanBeSpecialSummoned(e,0,tp,false,false) then
							op=Duel.SelectOption(tp,aux.Stringid(id,4))
						else
							break
						end
						if op==0 then
							Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
						else
							Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
						end
						tc=sg:GetNext()
					end
				else
					local g=Duel.SelectMatchingCard(tp,s.rpfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
					tc=g:GetFirst()
					Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
				end
			end
		end
	end
	g:DeleteGroup()
	sg:DeleteGroup()
end