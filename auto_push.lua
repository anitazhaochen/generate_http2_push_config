

function match_file(file_path, pattern, as_type)
    local file = io.open(file_path,"r")
    local str1 = file:lines()
    local res = ""
    for str in str1 do
        for s in str.gmatch(str, pattern) do
            s = string.format("<%s>; as=%s; rel=preload,",s, as_type)
            
            res = res..s
        end
    end
    return res
end

function get_link(file_path)
local res = match_file(file_path, "/js/src/.+%.js", "script")
-- ngx.header["Link"] = res
return res
end


function get_url()
    local root = "/usr/local/nginx1.15.8/conf/html"
    -- HTTP2 不支持 raw_header
    -- local raw_header = ngx.req.raw_header()
    -- file_name = string.match(raw_header,'GET (.-) ')
    file_name = ngx.var.request_uri
    if (file_name=="/") then
        file_name = "/index.html"
    end
    if (string.sub(file_name,-string.len("html"))=="html") then
        local file_path = root..file_name
        return get_link(file_path)
    end
end


return get_url()
-- ngx.header["Link"] = "</images/myself.jpg>; as=image; rel=preload"
--
