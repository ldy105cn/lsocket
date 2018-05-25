local socket = require("lsocket")

function main()
    local addr = "192.168.1.72"
    local port = 39001
    local client, err = socket.connect(addr, port)
    if not client then
        print("connect error ", err)
        return
    end
    socket.select(nil, {client})
    local ok, err = client:status()
    if not ok then
        print("error: "..err)
        return
    end
    print("conntect to ", addr, port, "success")
    print "Socket info:"
    for k, v in pairs(client:info()) do
        io.write(k..": "..tostring(v)..", ")
    end
    io.write("\n")
    local bin = string.pack("<H", 12)
    local smsg = string.pack("<H", 185)
    bin = bin .. smsg
    smsg = string.pack("<I", 100010)
    bin = bin .. smsg
    smsg = string.pack("<I", 32)
    bin = bin .. smsg
    -- local len = 0
    -- print("unpack bin size", bin:len())
    -- local s, offset = string.unpack("<H", bin)
    -- len = len + offset
    -- print(s, len, offset)
    -- s, offset = string.unpack("<H", bin:sub(len))
    -- len = len + offset - 1
    -- print(s, len, offset)
    -- s, offset = string.unpack("<I", bin:sub(len))
    -- len = len + offset - 1
    -- print(s, len, offset)
    -- s, offset = string.unpack("<I", bin:sub(len))
    -- len = len + offset - 1
    -- print(s, len, offset)
    ok, err = client:send(bin)
    if not ok then
        print("error", err)
        return
    end
    socket.select({client})
    print("send msg success")
    local input = ""
    repeat
        input = io.read()
        local msg, err = client:recv()
        if msg then
            print("recv", msg)
        end
    until input == "quit"
end

main()