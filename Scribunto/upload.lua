-- todo: need to run this twice for `Module:API info/patch/api retail` to update properly. why?
local pathlib = require("path")
local enum = require("wowdoc.web.blizres.enum")
local products = require("wowdoc.products.branches")
local log = require("wowdoc.util.log")
local cfg = require("wowdoc.config")
local latest_product = require("wowdoc.products.latest_product")

local BRANCH = products:GetBranch(cfg.TACT_PRODUCT)
local products = latest_product:GetLatestProducts()
local SUMMARY = products.wow.version

local function WriteFiles()
    local scribunto = pathlib.join("Scribunto", "API_info")
    local files = {
        pathlib.join(scribunto, "gametype"),
        pathlib.join(scribunto, "system"),
        pathlib.join(scribunto, "system", "systeminfo"),
        pathlib.join(scribunto, "patch", "api"), -- for some reason need to run this twice
        pathlib.join(scribunto, "patch", "event"),
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
