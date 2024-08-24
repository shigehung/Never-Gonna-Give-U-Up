--サイバネット・エレメンツ
--Cynet Elements
--Scripted by TriDung
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Change Attribute
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_DRAW+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_CUSTOM+id)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTarget(s.attritg)
	e2:SetOperation(s.attriop)
	c:RegisterEffect(e2)
	local g=Group.CreateGroup()
	g:KeepAlive()
	e2:SetLabelObject(g)
	--Mass register
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetLabelObject(e2)
	e3:SetOperation(s.regop)
	c:RegisterEffect(e3)
	--Register attributes
	aux.GlobalCheck(s,function()
		s.attr_list={}
		s.attr_list[0]=ATTRIBUTE_ALL
		s.attr_list[1]=ATTRIBUTE_ALL
		aux.AddValuesReset(function()
			s.attr_list[0]=ATTRIBUTE_ALL
			s.attr_list[1]=ATTRIBUTE_ALL
		end)
	end)
end
s.listed_series={0x118,0x577}
function s.tgfilter(c,e,tp)
	return c:IsSetCard(0x577) and c:IsControler(tp) and c:IsFaceup()
		and c:IsLocation(LOCATION_MZONE) and c:IsPreviousLocation(LOCATION_EXTRA)
		and c:IsCanBeEffectTarget(e)
end
function s.regop(e,tp,eg,ep,ev,re,r,rp)
	local tg=eg:Filter(s.tgfilter,nil,e,tp)
	if #tg>0 then
		for tc in aux.Next(tg) do
			tc:RegisterFlagEffect(id,RESET_CHAIN,0,1)
		end
		local g=e:GetLabelObject():GetLabelObject()
		if Duel.GetCurrentChain()==0 then g:Clear() end
		g:Merge(tg)
		g:Remove(function(c) return c:GetFlagEffect(id)==0 end,nil)
		e:GetLabelObject():SetLabelObject(g)
		Duel.RaiseSingleEvent(e:GetHandler(),EVENT_CUSTOM+id,e,0,tp,tp,0)
	end
end
function s.attritg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g=e:GetLabelObject():Filter(s.tgfilter,nil,e,tp)
	if chkc then return g:IsContains(chkc) and s.tgfilter(chkc,e,tp) end
	if chk==0 then return #g>0 and Duel.GetFlagEffect(tp,id)==0 end
	Duel.RegisterFlagEffect(tp,id,RESET_CHAIN,0,1)
	if #g==1 then
		Duel.SetTargetCard(g:GetFirst())
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		local tc=g:Select(tp,1,1,nil)
		Duel.SetTargetCard(tc)
	end
	Duel.SetPossibleOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function s.attriop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not c:IsRelateToEffect(e) then return end
	if tc and tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local att=Duel.AnnounceAttribute(tp,1,s.attr_list[tp])
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_ADD_ATTRIBUTE)
		e1:SetValue(att)
		e1:SetReset(RESET_PHASE+PHASE_END,2)
		tc:RegisterEffect(e1)
		s.attr_list[tp]=s.attr_list[tp]&~att
		if Duel.IsPlayerCanDraw(tp,1) and tc:IsLinkMonster() and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
			if Duel.Draw(tp,1,REASON_EFFECT)~=0 then
				local dc=Duel.GetOperatedGroup():GetFirst()
				if dc:IsSpellTrap() and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(id,3)) then
					Duel.BreakEffect()
					Duel.SSet(tp,dc,tp,false)
					local e1=Effect.CreateEffect(e:GetHandler())
					e1:SetType(EFFECT_TYPE_SINGLE)
					if dc:IsQuickPlaySpell() then
						e1:SetCode(EFFECT_QP_ACT_IN_SET_TURN)
					elseif dc:IsTrap() then
						e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
					end
					e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
					e1:SetReset(RESET_EVENT|RESETS_STANDARD)
					e1:SetDescription(aux.Stringid(id,4))
					dc:RegisterEffect(e1)
				end
				if dc:IsMonster() and Duel.IsPlayerCanSpecialSummon(tp,SUMMON_TYPE_SPECIAL,POS_FACEUP,tp,dc)
					and dc:IsLevelBelow(3) and dc:IsRace(RACE_CYBERSE) and Duel.SelectYesNo(tp,aux.Stringid(id,5)) then
					Duel.BreakEffect()
					Duel.SpecialSummon(dc,0,tp,tp,false,false,POS_FACEUP)
				end
			end
		end
		for _,str in aux.GetAttributeStrings(att) do
				c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,str)
		end
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(s.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	aux.RegisterClientHint(e:GetHandler(),nil,tp,1,0,aux.Stringid(id,6),nil)
	--lizard check
	aux.addTempLizardCheck(e:GetHandler(),tp,s.lizfilter)
end
function s.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsRace(RACE_CYBERSE) and c:IsLocation(LOCATION_EXTRA)
end
function s.lizfilter(e,c)
	return not c:IsOriginalRace(RACE_CYBERSE)
end