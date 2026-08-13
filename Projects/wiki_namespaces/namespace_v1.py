from lupa import LuaRuntime
import pywikibot
import requests

lua = LuaRuntime(unpack_returned_tuples=True)
site = pywikibot.Site("en", "warcraftwiki")

def main():
	lua_table = read_lua("https://raw.githubusercontent.com/Ketho/BlizzardInterfaceResources/refs/heads/mainline/Resources/GlobalAPI.lua")
	namespaces = get_namespaces(lua_table)
	for name in namespaces:
		save_page(name, f"#REDIRECT [[Category:API_namespaces/{name}]]", "Redirect to namespace category")

def read_lua(path):
	if path.startswith('https://'):
		response = requests.get(path)
		response.raise_for_status()
		lua_code = response.text
	else:
		with open(path, 'r', encoding='utf-8') as f:
			lua_code = f.read()

	wrapped_code = f"""
	function __py_loader()
		{lua_code}
	end
	"""

	lua.execute(wrapped_code)
	result = lua.eval("__py_loader()")
	return result

def get_namespaces(result):
	global_api = result[1]

	apis = set()
	for value in global_api.values():
		if isinstance(value, str) and value.startswith('C_'):
			namespace = value.split('.')[0]
			apis.add(namespace)
	apis = sorted(apis)
	return apis

def save_page(title, text, summary):
	page = pywikibot.Page(site, title)
	page.text = text
	page.save(summary=summary)

if __name__ == "__main__":
	main()
