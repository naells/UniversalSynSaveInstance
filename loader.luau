-- UniversalSynSaveInstance: one-repository loader
-- Dependencies are rewritten to use the vendor/ directory in this branch.
local BASE_URL = "https://raw.githubusercontent.com/naells/UniversalSynSaveInstance/self-contained-bundle/"

local source = game:HttpGet(BASE_URL .. "saveinstance.luau", true)
assert(type(source) == "string" and #source > 10000, "Unable to download saveinstance.luau")

local function replaceLiteral(text, needle, replacement)
    local count, cursor = 0, 1
    while true do
        local first, last = string.find(text, needle, cursor, true)
        if not first then break end
        text = string.sub(text, 1, first - 1) .. replacement .. string.sub(text, last + 1)
        cursor = first + #replacement
        count += 1
    end
    return text, count
end

local patches = {
    { "https://raw.githubusercontent.com/luau/SomeHub/main/", BASE_URL .. "vendor/SomeHub/", 2 },
    { "https://raw.githubusercontent.com/daily3014/rbx-algorithms/refs/heads/main/src/Encoding/Base64.luau", BASE_URL .. "vendor/rbx-algorithms/Base64.luau", 1 },
    { "https://raw.githubusercontent.com/RiskoZS/llz4/refs/heads/main/llz4.luau", BASE_URL .. "vendor/llz4/llz4.luau", 1 },
    { "https://raw.githubusercontent.com/luau/UniversalSynSaveInstance/main/", BASE_URL, 1 },
}

for _, patch in ipairs(patches) do
    local count
    source, count = replaceLiteral(source, patch[1], patch[2])
    assert(count >= patch[3], "Could not patch dependency URL: " .. patch[1])
end

local compile = loadstring or load
assert(type(compile) == "function", "Executor does not expose loadstring/load")
local chunk, compileError = compile(source, "UniversalSynSaveInstance")
assert(chunk, compileError)

local run = chunk()
assert(type(run) == "function", "Unexpected USSI module return value")

-- XML output is the reliable default while Binary encoder compatibility is unresolved.
return run({
    ShowStatus = true,
    Binary = false,
})