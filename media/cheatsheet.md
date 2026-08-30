- types
<span class="apitype">number</span>
<span class="apitype">boolean</span>
<span class="apitype">string</span>

<span title="optional"><span class="apitype">number</span>?</span>
<span title="optional"><span class="apitype">boolean</span>?</span>
<span title="optional"><span class="apitype">string</span>?</span>

<span title="nilable"><span class="apitype">boolean</span>?</span>

-- code block
<syntaxhighlight lang="lua">
</syntaxhighlight>
<syntaxhighlight lang=xml>
</syntaxhighlight>

<syntaxhighlight lang=lua inline></syntaxhighlight>

- desc
<!--desc-->Sends a message over an addon comm channel.

- font
<font color="#ecbc2a">number</font> <!--- orange -->
<font color="#4ec9b0">hello</font>  <!--- darkgreen -->
<font color="#dda0dd">number</font> <!--- plum -->
<font color="#4169E1">number</font> <!--- royalblue -->

- diff color
+ <font color="#00b400">
- <font color="#ff6767">

- darktable
{| class="sortable darktable zebra" style="margin-left: 2em"
! Key !! Type !! Description
|-
| mapID || <span class="apitype">number</span> || 
|-
| name || <span class="apitype">string</span> || 
|}

{| class="sortable darktable zebra col1-center"

style="padding-right: 1em" 

- arguments/returns
==Arguments==
;item : <span class="apitype">number</span>

==Returns==
;itemName : <span class="apitype">string</span>

- undocumented api like https://wowpedia.fandom.com/wiki/Struct_SetInfo
{{wowapitype|undocumented=1}}

- macros
/run ChatFrame_OpenChat("/spew ")

- emmylua
<!-- emmylua
---@param spell number|string
---@return string link
---@return number spellID
---@overload fun(index: number, bookType: string)
function GetSpellLink(spell) end
-->

- pattern to convert widget api to emmylua
(.*):(.*)\((.*)\)
\n---[Documentation](https://wowpedia.fandom.com/wiki/API_$1_$2)
function $1:$2($3) end

- css
https://wowpedia.fandom.com/wiki/User:Ketho/fandomdesktop.css

-- bullet symbol
•

- apitable
==Details==
{| {{apitable}}
{{apirow | Related API | {{api|UnitHealthMax}} }}
{{apirow | Available after | {{api|t=e|PLAYER_ENTERING_WORLD}} (on login) }}
{{apirow | Related Events | {{api|t=e|UNIT_HEALTH}} }}
|}
local function setCoords(tex, A, B, C, D, E, F)
	local det = A*E - B*D
	local ULx, ULy, LLx, LLy, URx, URy, LRx, LRy

	ULx, ULy = ( B*F - C*E ) / det, ( -(A*F) + C*D ) / det
	LLx, LLy = ( -B + B*F - C*E ) / det, ( A - A*F + C*D ) / det
	URx, URy = ( E + B*F - C*E ) / det, ( -D - A*F + C*D ) / det
	LRx, LRy = ( E - B + B*F - C*E ) / det, ( -D + A -(A*F) + C*D ) / det

	tex:SetTexCoord(ULx, ULy, LLx, LLy, URx, URy, LRx, LRy)
end

local tex = UIParent:CreateTexture()
tex:SetPoint("CENTER")
tex:SetTexture("interface/icons/inv_mushroom_11")

local r = math.pi/6
setCoords(tex, math.cos(r), -math.sin(r), 0, math.sin(r), math.cos(r), 0)

- turn code blocks in to apiname
\|\| <code>(.*?)</code> \|\|
|| {{apiname|$1}} ||

\| <code>(.*?)</code> \|
| {{apiname|$1}} |

- align table header to the left
|+ style="text-align:left; margin-left: 1em" | 

## to remove 20250903
- tttemplatelink
:;appearance:<span class="tttemplatelink"><span style="color:#ecbc21">ContributionAppearance</span>?</span><span style="display:none">Optional, could be <span style="color:#ecbc21">nil</span>.</span>

- structure in wikitext
- Vector2DMixin, etc

## ptr icon
[[File:PTR_client.png|16px|link=]] 

## manually diff
- if github web diff is wonky
`git diff --binary --full-index 11.2.5 12.0.0 > diff-11.2.5..12.0.0.patch`
`git diff --binary --full-index 11.2.7 12.0.0 > diff-11.2.7..12.0.0.patch`

## added in
<font color="green">12.0.5</font>
{{apiname.added|12.1.0}}

==Patch changes==
* {{Patch 12.1.0|note=Added <code>trigger</code> argument.}}

## get deprecated API diff
`git log -p --all --grep="12.1.0" -- "*Blizzard_Deprecated*"`

## pages for testing modules
API_C_ActionBar.GetActionBarPage
API_FrameScriptObject_HasAnySecretAspect
ACHIEVEMENT_EARNED
