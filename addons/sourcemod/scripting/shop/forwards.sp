GlobalForward h_fwdOnAuthorized,
	h_fwdOnMenuTitle,
	h_fwdOnItemDisplay,
	h_fwdOnItemDescription,
	h_fwdOnItemDraw,
	h_fwdOnItemSelect,
	h_fwdOnItemSelected,
	h_fwdOnItemToggled,
	h_fwdOnItemElapsed,
	h_fwdOnItemBuy,
	h_fwdOnItemSell,
	h_fwdOnClientLuckProcess,
	h_fwdOnClientShouldLuckItemChance,
	h_fwdOnClientItemLucked,
	h_fwdOnItemTransfer,
	h_fwdOnItemTransfered,
	h_fwdOnCreditsTransfer,
	h_fwdOnCreditsTransfered,
	h_fwdOnCreditsSet,
	h_fwdOnCreditsSetPost,
	h_fwdOnCreditsGiven,
	h_fwdOnCreditsGivenPost,
	h_fwdOnCreditsTaken,
	h_fwdOnCreditsTakenPost,
	h_fwdOnCategoryRegistered,
	h_fwdOnItemRegistered;

void Forward_OnPluginStart()
{
	h_fwdOnAuthorized = new GlobalForward("Shop_OnAuthorized", ET_Ignore, Param_Cell);
	h_fwdOnMenuTitle = new GlobalForward("Shop_OnMenuTitle", ET_Hook, Param_Cell, Param_Cell, Param_String, Param_String, Param_Cell);
	h_fwdOnItemBuy = new GlobalForward("Shop_OnItemBuy", ET_Hook, Param_Cell, Param_Cell, Param_String, Param_Cell, Param_String, Param_Cell, Param_CellByRef, Param_CellByRef, Param_CellByRef);
	h_fwdOnItemDraw = new GlobalForward("Shop_OnItemDraw", ET_Hook, Param_Cell, Param_Cell, Param_Cell, Param_Cell, Param_CellByRef);
	h_fwdOnItemSelect = new GlobalForward("Shop_OnItemSelect", ET_Hook, Param_Cell, Param_Cell, Param_Cell, Param_Cell);
	h_fwdOnItemSelected = new GlobalForward("Shop_OnItemSelected", ET_Ignore, Param_Cell, Param_Cell, Param_Cell, Param_Cell);
	h_fwdOnItemDisplay = new GlobalForward("Shop_OnItemDisplay", ET_Hook, Param_Cell, Param_Cell, Param_Cell, Param_Cell, Param_String, Param_String, Param_Cell);
	h_fwdOnItemDescription = new GlobalForward("Shop_OnItemDescription", ET_Hook, Param_Cell, Param_Cell, Param_Cell, Param_Cell, Param_String, Param_String, Param_Cell);
	h_fwdOnItemSell = new GlobalForward("Shop_OnItemSell", ET_Hook, Param_Cell, Param_Cell, Param_String, Param_Cell, Param_String, Param_Cell, Param_CellByRef);
	h_fwdOnItemToggled = new GlobalForward("Shop_OnItemToggled", ET_Ignore, Param_Cell, Param_Cell, Param_String, Param_Cell, Param_String, Param_Cell);
	h_fwdOnItemElapsed = new GlobalForward("Shop_OnItemElapsed", ET_Ignore, Param_Cell, Param_Cell, Param_String, Param_Cell, Param_String);
	h_fwdOnClientLuckProcess = new GlobalForward("Shop_OnClientLuckProcess", ET_Hook, Param_Cell);
	h_fwdOnClientShouldLuckItemChance = new GlobalForward("Shop_OnClientShouldLuckItemChance", ET_Hook, Param_Cell, Param_Cell, Param_CellByRef);
	h_fwdOnClientItemLucked = new GlobalForward("Shop_OnClientItemLucked", ET_Ignore, Param_Cell, Param_Cell);
	h_fwdOnItemTransfer = new GlobalForward("Shop_OnItemTransfer", ET_Hook, Param_Cell, Param_Cell, Param_Cell);
	h_fwdOnItemTransfered = new GlobalForward("Shop_OnItemTransfered", ET_Ignore, Param_Cell, Param_Cell, Param_Cell);
	h_fwdOnCreditsTransfer = new GlobalForward("Shop_OnCreditsTransfer", ET_Hook, Param_Cell, Param_Cell, Param_CellByRef, Param_CellByRef, Param_CellByRef, Param_Cell);
	h_fwdOnCreditsTransfered = new GlobalForward("Shop_OnCreditsTransfered", ET_Ignore, Param_Cell, Param_Cell, Param_Cell, Param_Cell, Param_Cell);
	h_fwdOnCreditsSet = new GlobalForward("Shop_OnCreditsSet", ET_Hook, Param_Cell, Param_CellByRef, Param_Cell);
	h_fwdOnCreditsSetPost = new GlobalForward("Shop_OnCreditsSet_Post", ET_Ignore, Param_Cell, Param_Cell, Param_Cell);
	h_fwdOnCreditsGiven = new GlobalForward("Shop_OnCreditsGiven", ET_Hook, Param_Cell, Param_CellByRef, Param_Cell);
	h_fwdOnCreditsGivenPost = new GlobalForward("Shop_OnCreditsGiven_Post", ET_Ignore, Param_Cell, Param_Cell, Param_Cell);
	h_fwdOnCreditsTaken = new GlobalForward("Shop_OnCreditsTaken", ET_Hook, Param_Cell, Param_CellByRef, Param_Cell);
	h_fwdOnCreditsTakenPost = new GlobalForward("Shop_OnCreditsTaken_Post", ET_Ignore, Param_Cell, Param_Cell, Param_Cell);
	h_fwdOnCategoryRegistered = new GlobalForward("Shop_OnCategoryRegistered", ET_Ignore, Param_Cell, Param_String);
	h_fwdOnItemRegistered = new GlobalForward("Shop_OnItemRegistered", ET_Ignore, Param_Cell, Param_String, Param_Cell, Param_String);
}

bool Forward_OnItemTransfer(int client, int target, int item_id)
{
	bool result = true;
	
	Call_StartForward(h_fwdOnItemTransfer);
	Call_PushCell(client);
	Call_PushCell(target);
	Call_PushCell(item_id);
	Call_Finish(result);
	
	return result;
}

void Forward_OnItemTransfered(int client, int target, int item_id)
{
	Call_StartForward(h_fwdOnItemTransfered);
	Call_PushCell(client);
	Call_PushCell(target);
	Call_PushCell(item_id);
	Call_Finish();
}

Action Forward_OnCreditsTransfer(int client, int target, int &credits_give, int &credits_remove, int &credits_commission, bool bPercent)
{
	Action result = Plugin_Continue;
	
	Call_StartForward(h_fwdOnCreditsTransfer);
	Call_PushCell(client);
	Call_PushCell(target);
	Call_PushCellRef(credits_give);
	Call_PushCellRef(credits_remove);
	Call_PushCellRef(credits_commission);
	Call_PushCell(bPercent);
	Call_Finish(result);
	
	return result;
}

void Forward_OnCreditsTransfered(int client, int target, int credits_give, int credits_remove, int credits_commission)
{
	Call_StartForward(h_fwdOnCreditsTransfered);
	Call_PushCell(client);
	Call_PushCell(target);
	Call_PushCell(credits_give);
	Call_PushCell(credits_remove);
	Call_PushCell(credits_commission);
	Call_Finish();
}

bool Forward_OnClientLuckProcess(int client)
{
	bool result = true;
	
	Call_StartForward(h_fwdOnClientLuckProcess);
	Call_PushCell(client);
	Call_Finish(result);
	
	return result;
}

Action Forward_OnClientShouldLuckItemChance(int client, int item_id, int &iLuckChance)
{
	Action result = Plugin_Continue;
	
	Call_StartForward(h_fwdOnClientShouldLuckItemChance);
	Call_PushCell(client);
	Call_PushCell(item_id);
	Call_PushCellRef(iLuckChance);
	Call_Finish(result);
	
	return result;
}
	

void Forward_OnClientItemLucked(int client, int item_id)
{
	Call_StartForward(h_fwdOnClientItemLucked);
	Call_PushCell(client);
	Call_PushCell(item_id);
	Call_Finish();
}

Action Forward_OnItemDraw(int client, ShopMenu menu_action, int category_id, int item_id, bool &disabled)
{
	Action result = Plugin_Continue;
	bool call_disable = disabled;
	
	Call_StartForward(h_fwdOnItemDraw);
	Call_PushCell(client);
	Call_PushCell(menu_action);
	Call_PushCell(category_id);
	Call_PushCell(item_id);
	Call_PushCellRef(call_disable);
	Call_Finish(result);

	if(result == Plugin_Changed) 
	{
		disabled = call_disable;
	}
	
	return result;
}

Action Forward_OnItemSelect(int client, ShopMenu menu_action, int category_id, int item_id)
{
	Action result = Plugin_Continue;
	
	Call_StartForward(h_fwdOnItemSelect);
	Call_PushCell(client);
	Call_PushCell(menu_action);
	Call_PushCell(category_id);
	Call_PushCell(item_id);
	Call_Finish(result);
	
	return result;
}

void Forward_OnItemSelected(int client, ShopMenu menu_action, int category_id, int item_id)
{
	Call_StartForward(h_fwdOnItemSelected);
	Call_PushCell(client);
	Call_PushCell(menu_action);
	Call_PushCell(category_id);
	Call_PushCell(item_id);
	Call_Finish();
}

bool Forward_OnItemDisplay(int client, ShopMenu menu_action, int category_id, int item_id, const char[] display, char[] buffer, int maxlength)
{
	bool result = false;
	
	Call_StartForward(h_fwdOnItemDisplay);
	Call_PushCell(client);
	Call_PushCell(menu_action);
	Call_PushCell(category_id);
	Call_PushCell(item_id);
	Call_PushString(display);
	Call_PushStringEx(buffer, maxlength, SM_PARAM_STRING_UTF8|SM_PARAM_STRING_COPY, SM_PARAM_COPYBACK);
	Call_PushCell(maxlength);
	Call_Finish(result);
	
	if (!result)
	{
		strcopy(buffer, maxlength, display);
	}
	
	return result;
}

bool Forward_OnItemDescription(int client, ShopMenu menu_action, int category_id, int item_id, const char[] display, char[] buffer, int maxlength)
{
	bool result = false;
	
	Call_StartForward(h_fwdOnItemDescription);
	Call_PushCell(client);
	Call_PushCell(menu_action);
	Call_PushCell(category_id);
	Call_PushCell(item_id);
	Call_PushString(display);
	Call_PushStringEx(buffer, maxlength, SM_PARAM_STRING_UTF8|SM_PARAM_STRING_COPY, SM_PARAM_COPYBACK);
	Call_PushCell(maxlength);
	Call_Finish(result);
	
	if (!result)
	{
		strcopy(buffer, maxlength, display);
	}
	
	return result;
}

Action Forward_OnCreditsTaken(int client, int &credits, int by_who)
{
	Action result = Plugin_Continue;
	
	Call_StartForward(h_fwdOnCreditsTaken);
	Call_PushCell(client);
	Call_PushCellRef(credits);
	Call_PushCell(by_who);
	Call_Finish(result);
	
	return result;
}

void Forward_OnCreditsTaken_Post(int client, int credits, int by_who)
{
	Call_StartForward(h_fwdOnCreditsTakenPost);
	Call_PushCell(client);
	Call_PushCell(credits);
	Call_PushCell(by_who);
	Call_Finish();
}

Action Forward_OnCreditsSet(int client, int &credits, int by_who)
{
	Action result = Plugin_Continue;
	
	Call_StartForward(h_fwdOnCreditsSet);
	Call_PushCell(client);
	Call_PushCellRef(credits);
	Call_PushCell(by_who);
	Call_Finish(result);
	
	return result;
}

void Forward_OnCreditsSet_Post(int client, int credits, int by_who)
{
	Call_StartForward(h_fwdOnCreditsSetPost);
	Call_PushCell(client);
	Call_PushCell(credits);
	Call_PushCell(by_who);
	Call_Finish();
}

Action Forward_OnCreditsGiven(int client, int &credits, int by_who)
{
	Action result = Plugin_Continue;
	
	Call_StartForward(h_fwdOnCreditsGiven);
	Call_PushCell(client);
	Call_PushCellRef(credits);
	Call_PushCell(by_who);
	Call_Finish(result);
	
	return result;
}

void Forward_OnCreditsGiven_Post(int client, int credits, int by_who)
{
	Call_StartForward(h_fwdOnCreditsGivenPost);
	Call_PushCell(client);
	Call_PushCell(credits);
	Call_PushCell(by_who);
	Call_Finish();
}

void Forward_OnAuthorized(int client)
{
	Call_StartForward(h_fwdOnAuthorized);
	Call_PushCell(client);
	Call_Finish();
}

void Forward_OnItemElapsed(int client, int category_id, const char[] category, int item_id, const char[] item)
{
	Call_StartForward(h_fwdOnItemElapsed);
	Call_PushCell(client);
	Call_PushCell(category_id);
	Call_PushString(category);
	Call_PushCell(item_id);
	Call_PushString(item);
	Call_Finish();
}

void Forward_OnItemToggled(int client, int category_id, const char[] category, int item_id, const char[] item, ToggleState toggle)
{
	Call_StartForward(h_fwdOnItemToggled);
	Call_PushCell(client);
	Call_PushCell(category_id);
	Call_PushString(category);
	Call_PushCell(item_id);
	Call_PushString(item);
	Call_PushCell(toggle);
	Call_Finish();
}

void Forward_NotifyShopLoaded()
{
	Handle plugin;
	
	Handle myhandle = GetMyHandle();
	Handle hIter = GetPluginIterator();
	
	while (MorePlugins(hIter))
	{
		plugin = ReadPlugin(hIter);
		
		if (plugin == myhandle || GetPluginStatus(plugin) != Plugin_Running)
		{
			continue;
		}
		
		Function func = GetFunctionByName(plugin, "Shop_Started");
		
		if (IsCallValid(plugin, func))
		{
			Call_StartFunction(plugin, func);
			Call_Finish();
		}
	}
	
	delete hIter;
}

void Forward_OnMenuTitle(int client, ShopMenu menu_action, const char[] title, char[] buffer, int maxlength)
{
	bool result = false;
	
	Call_StartForward(h_fwdOnMenuTitle);
	Call_PushCell(client);
	Call_PushCell(menu_action);
	Call_PushString(title);
	Call_PushStringEx(buffer, maxlength, SM_PARAM_STRING_UTF8|SM_PARAM_STRING_COPY, SM_PARAM_COPYBACK);
	Call_PushCell(maxlength);
	Call_Finish(result);
	
	if (!result)
		strcopy(buffer, maxlength, title);
	
	StrCat(buffer, maxlength, "\n ");
}

Action Forward_OnItemBuy(int client, int category_id, const char[] category, int item_id, const char[] item, ItemType type, int &price, int &sell_price, int &value)
{
	Action result = Plugin_Continue;
	
	Call_StartForward(h_fwdOnItemBuy);
	Call_PushCell(client);
	Call_PushCell(category_id);
	Call_PushString(category);
	Call_PushCell(item_id);
	Call_PushString(item);
	Call_PushCell(type);
	Call_PushCellRef(price);
	Call_PushCellRef(sell_price);
	Call_PushCellRef(value);
	Call_Finish(result);
	
	return result;
}

Action Forward_OnItemSell(int client, int category_id, const char[] category, int item_id, const char[] item, ItemType type, int &sell_price)
{
	Action result = Plugin_Continue;
	
	Call_StartForward(h_fwdOnItemSell);
	Call_PushCell(client);
	Call_PushCell(category_id);
	Call_PushString(category);
	Call_PushCell(item_id);
	Call_PushString(item);
	Call_PushCell(type);
	Call_PushCellRef(sell_price);
	Call_Finish(result);
	
	return result;
}

void Forward_OnCategoryRegistered(int category_id, const char[] category)
{
	Call_StartForward(h_fwdOnCategoryRegistered);
	Call_PushCell(category_id);
	Call_PushString(category);
	Call_Finish();
}

void Forward_OnItemRegistered(int category_id, const char[] category, int item_id, const char[] item)
{
	Call_StartForward(h_fwdOnItemRegistered);
	Call_PushCell(category_id);
	Call_PushString(category);
	Call_PushCell(item_id);
	Call_PushString(item);
	Call_Finish();
}