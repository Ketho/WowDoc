local pathlib = require("path")
local enum = require("wowdoc.web.blizres.enum")
local products = require("wowdoc.products.branches")
local log = require("wowdoc.util.log")
local cfg = require("wowdoc.config")

local BRANCH = products:GetBranch(cfg.TACT_PRODUCT)
local SUMMARY = "12.1.0 (68301)"

local function WriteFiles()
    local scribunto = pathlib.join("Scribunto", "API_info")
    local files = {
        pathlib.join(scribunto, "flavor", "flavor"),
        pathlib.join(scribunto, "elink", "api"),
        pathlib.join(scribunto, "elink", "event"),
        pathlib.join(scribunto, "patch", "api", "api"),
        pathlib.join(scribunto, "patch", "event", "event"),
        pathlib.join(scribunto, "systems", "get_full_list"),
        pathlib.join(scribunto, "systems", "categories", "get_systems"),
        pathlib.join(scribunto, "predicates"),
    }
    for _, v in pairs(files) do
        log.important(string.format("require: %s", v))
        require(v)
    end
end

local function UploadFiles()
    os.execute(".venv/bin/pwb login")
    os.execute(string.format('.venv/bin/python Scribunto/upload.py "%s"', SUMMARY))
end

local function main()
    enum:LoadEnumTable({branch = BRANCH})
    WriteFiles()
    UploadFiles()
end

main()
