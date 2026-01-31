local Path = require("path")
local util = require("wowdoc")
local enum = require("wowdoc.enum")
local products = require("wowdoc.products")
local log = require("wowdoc.log")

local PRODUCT = CONFIG.TACT_PRODUCT
local gethe_branch = products:GetBranch(PRODUCT)

local SUMMARY = "12.0.1 (65617)"

local function WriteFiles()
    local scribunto = Path.join("Scribunto", "API_info")
    local files = {
        Path.join(scribunto, "flavor", "flavor"),
        Path.join(scribunto, "elink", "api"),
        Path.join(scribunto, "elink", "event"),
        Path.join(scribunto, "patch", "api", "api"),
        Path.join(scribunto, "patch", "event", "event"),
        Path.join(scribunto, "systems", "get_full_list"),
        Path.join(scribunto, "systems", "categories", "get_systems"),
        Path.join(scribunto, "predicates"),
    }
    for _, v in pairs(files) do
        log:important(string.format("require: %s", v))
        require(v)
    end
end

local function UploadFiles()
    os.execute(".venv/bin/pwb login")
    os.execute(string.format('.venv/bin/python Scribunto/upload.py "%s"', SUMMARY))
end

local function main()
    enum:LoadLuaEnums(gethe_branch)
    WriteFiles()
    UploadFiles()
end

main()
