-- todo: need to run this twice for `Module:API info/patch/api retail` to update properly. why?
local m = {
    pathlib = require("path"),
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
    local scribunto = m.pathlib.join("Scribunto", "API_info")
    local files = {
        m.pathlib.join(scribunto, "gametype"),
        m.pathlib.join(scribunto, "system"),
        m.pathlib.join(scribunto, "system", "systeminfo"),
        m.pathlib.join(scribunto, "patch", "api"), -- for some reason need to run this twice
        m.pathlib.join(scribunto, "patch", "event"),
        m.pathlib.join(scribunto, "predicates"),
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
