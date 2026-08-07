import pywikibot

site = pywikibot.Site("en", "warcraftwiki")
page = pywikibot.Page(site, "User:Ketho/Sandbox/bot")

page.text = "hello pywikibot with ketho-test #3"
page.save(summary = "Some test")
