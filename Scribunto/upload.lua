-- todo: need to run this twice for `Module:API info/patch/api retail` to update properly. why?
local pathlib = require("path")
local m = {
    enum = require("wowdoc.web.blizres.enum"),
    products = require("wowdoc.products.branches"),
    log = require("wowdoc.util.log"),
    cfg = require("wowdoc.config"),
    latest_product = require("wowdoc.products.latest_product"),
}

local BRANCH = m.products:GetBranch(m.cfg.TACT_PRODUCT)
local latestProducts = m.latest_product:GetLatestProducts()
local SUMMARY = latestProducts.standard.version

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
        m.log.important(string.format("require: %s", v))
        require(v)
    end
end

local function UploadFiles()
    os.execute(".venv/bin/pwb login")
    os.execute(string.format('.venv/bin/python Scribunto/upload.py "%s"', SUMMARY))
end

local function main()
    m.enum:LoadEnumTable({branch = BRANCH})
    WriteFiles()
    -- UploadFiles()
end

main()
