#include <rankme>
#include <cstrike>

#pragma newdecls required
#pragma semicolon 1

char g_szClantag[MAXPLAYERS+1][32];

public Plugin myinfo = 
{
	name = "RankMe Clantag",
	author = "maoling ( xQy ), Cruze.",
	description = "",
	version = "1.3.5",
	url = "http://steamcommunity.com/id/_xQy_/"
};

public void OnAllPluginsLoaded()
{
	if(!LibraryExists("rankme"))
		SetFailState("RankMe not found. Plugin won't work.");
	
	HookEvent("round_end", Event_RoundEnd);
}
public Action Event_RoundEnd(Handle event, const char[] name, bool dontBroadcast)
{
	for(int client = 1; client <= MaxClients; ++client)
	{
		if(!IsClientInGame(client))
			continue;
		
		if(!GetClientTeam(client))
			continue;
		
		CS_SetClientClanTag(client, g_szClantag[client]);
	}
}
public void OnLibraryRemoved(const char[] name)
{
	if(StrEqual(name, "rankme"))
		SetFailState("RankMe not found. Plugin won't work.");
}

public void OnClientPostAdminCheck(int client)
{
	CreateTimer(1.0, Timer_SetTag);
	strcopy(g_szClantag[client], 32, "");
}

public Action RankMe_OnPlayerLoaded(int client)
{
	RankMe_GetRank(client, GetClientRankCallback);
}

public int GetClientRankCallback(int client, int rank, any data)
{
	if(rank == 0)
		strcopy(g_szClantag[client], 32, "");
	else if(rank < 100)
		Format(g_szClantag[client], 32, "[Rank %d]", rank);
	else
		Format(g_szClantag[client], 32, "[R-%d]", rank);
}

public Action Timer_SetTag(Handle timer)
{	
	for(int client = 1; client <= MaxClients; ++client)
	{
		if(!IsClientInGame(client))
			continue;
		
		if(!GetClientTeam(client))
			continue;

		CS_SetClientClanTag(client, g_szClantag[client]);
	}
}
