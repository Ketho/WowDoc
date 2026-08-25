import pywikibot

site = pywikibot.Site("en", "warcraftwiki")
url = 'https://warcraft.wiki.gg'

headers = {
    'User-Agent': 'KethoBot/1.0 (https://warcraft.wiki.gg/wiki/User:KethoBot)'
}


def uppercaseFirst(v):
	res = v[0].upper() + v[1:]
	return res

# do it manually sime pywikibot assumes pages are always case insensitive
def movePage(fromName, toName, reason):
	token = site.tokens['csrf']
	req = site.simple_request(**{
		'action': 'move',
		'from': f'API:{fromName}',
		'to': f'API:{toName}',
		'reason': reason,
		'token': token,
		'movetalk': True,
		'noredirect': True,
	})
	result = req.submit()
	print(result)

def main():
	apiNames = [
		"addframetext",
		"canaccessallvalues",
		"canaccesssecrets",
		"canaccesstable",
		"canaccessvalue",
		"debuglocals",
		"debugprofilestart",
		"debugprofilestop",
		"debugstack",
		"dropsecretaccess",
		"dumpobject",
		"forceinsecure",
		"geterrorhandler",
		"hasanysecretvalues",
		"hooksecurefunc",
		"issecrettable",
		"issecretvalue",
		"issecure",
		"issecurevalue",
		"issecurevariable",
		"mapvalues",
		"pcallwithenv",
		"scrub",
		"scrubsecretvalues",
		"secretwrap",
		"securecall",
		"securecallfunction",
		"securecallmethod",
		"securecopy",
		"secureexecuterange",
		"seterrorhandler",
		"setsecurehookforbidden",
		"settablesecurity",
	]

	for name in apiNames:
		old = uppercaseFirst(name)
		page = pywikibot.Page(site, f"API:{old}")
		if page.exists():
			movePage(old, name, 'fix uppercased function names')
		else:
			print(f"{old} does not exist")

		# try:
		# 	movePage(old, name, 'fix uppercased function names')
		# except pywikibot.APIError as err:
		# 	if err.code == "missingtitle":
		# 		pywikibot.warning(f'{old} does not exist, skipping.')
		# 		continue
		# 	raise

if __name__ == "__main__":
	main()
