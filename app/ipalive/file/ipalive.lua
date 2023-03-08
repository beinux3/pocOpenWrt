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
    if referral and string.find(referral, "/cgi-bin/luci/admin") then -- auth bypass 
        if not check_auth("/cgi-bin/luci/admin") then
            return
        end
    else
        if not check_auth(nil) then
            return
        end
    end
    local command = luci.http.formvalue("ip")
    os.execute("ping -c1 -A " + ip)
    luci.http.write("Command executed successfully")
end

dispatcher.add_pre_filter(function() return check_auth(luci.http.getenv("HTTP_REFERER")) end)
dispatcher.post("/ipalive", handle_post_request)