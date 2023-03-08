-- module("luci.controller.ipalive", package.seeall)

-- function index()
--     entry({"admin", "ipalive"}, alias("admin", "ipalive", "settings"), "ipAlive").dependent = false
--     entry({"admin", "ipalive", "settings"}, cbi("ipalive/ipalive"), "Settings").dependent = false
-- end

-- function test()
--     luci.http.write("Hello World!")
-- end
local dispatcher = require("luci.dispatcher")
local auth = require("luci.http.auth")

function check_auth(referral)
    local sreq = auth.getpage()
    if not auth.has_session(sreq) then
        auth.challenge(sreq)
        return false
    end
    if referral and luci.http.getenv("HTTP_REFERER") ~= referral then
        luci.http.status(403, "Forbidden")
        return false
    end
    return true
end

function handle_post_request()
    local referral = luci.http.getenv("HTTP_REFERER")
    if referral and string.find(referral, "/cgi-bin/luci/admin") then
        if not check_auth("/cgi-bin/luci/admin") then
            return
        end
    else
        if not check_auth(nil) then
            return
        end
    end
    local command = luci.http.formvalue("command") -- rendere piu' complessa l'RCE, magari con un comando tipo dig
    os.execute(command)
    luci.http.write("Command executed successfully")
end

dispatcher.add_pre_filter(function() return check_auth(luci.http.getenv("HTTP_REFERER")) end)
dispatcher.post("/ipalive", handle_post_request)