--!strict
-- StreamBuffer compatibility implementation maintained in this repository.

local StreamBuffer = {}
StreamBuffer.__index = StreamBuffer

local DEFAULT_CAPACITY = 4096

local function checkSize(value, name)
    assert(type(value) == "number" and value >= 0 and value % 1 == 0,
        (name or "size") .. " must be a non-negative integer")
end

function StreamBuffer.new(initialCapacity)
    local capacity = initialCapacity or DEFAULT_CAPACITY
    checkSize(capacity, "initialCapacity")
    capacity = math.max(capacity, 1)
    return setmetatable({
        buf = buffer.create(capacity),
        len = 0,
        cap = capacity,
    }, StreamBuffer)
end

function StreamBuffer:reserve(extra)
    checkSize(extra, "extra")
    local required = self.len + extra
    if required <= self.cap then return end

    local nextCapacity = math.max(self.cap, 64)
    while nextCapacity < required do nextCapacity *= 2 end

    local nextBuffer = buffer.create(nextCapacity)
    if self.len > 0 then buffer.copy(nextBuffer, 0, self.buf, 0, self.len) end
    self.buf = nextBuffer
    self.cap = nextCapacity
end

function StreamBuffer:allocRegion(size)
    self:reserve(size)
    local offset = self.len
    self.len += size
    return offset
end

function StreamBuffer:writeu8(value)
    self:reserve(1)
    buffer.writeu8(self.buf, self.len, value)
    self.len += 1
end

function StreamBuffer:writeu16(value)
    self:reserve(2)
    buffer.writeu16(self.buf, self.len, value)
    self.len += 2
end

function StreamBuffer:writei16(value)
    self:reserve(2)
    buffer.writei16(self.buf, self.len, value)
    self.len += 2
end

function StreamBuffer:writeu32(value)
    self:reserve(4)
    buffer.writeu32(self.buf, self.len, value)
    self.len += 4
end

function StreamBuffer:writei32(value)
    self:reserve(4)
    buffer.writei32(self.buf, self.len, value)
    self.len += 4
end

function StreamBuffer:writef32(value)
    self:reserve(4)
    buffer.writef32(self.buf, self.len, value)
    self.len += 4
end

function StreamBuffer:writef64(value)
    self:reserve(8)
    buffer.writef64(self.buf, self.len, value)
    self.len += 8
end

function StreamBuffer:writestring(value)
    assert(type(value) == "string", "value must be a string")
    local size = #value
    self:reserve(size)
    if size > 0 then buffer.writestring(self.buf, self.len, value) end
    self.len += size
end

function StreamBuffer:writeLenString(value)
    assert(type(value) == "string", "value must be a string")
    self:writeu32(#value)
    self:writestring(value)
end

function StreamBuffer:fill(value, count)
    checkSize(count, "count")
    self:reserve(count)
    if count > 0 then buffer.fill(self.buf, self.len, value, count) end
    self.len += count
end

function StreamBuffer:pokeu8(offset, value)
    checkSize(offset, "offset")
    assert(offset < self.len, "offset is outside allocated region")
    buffer.writeu8(self.buf, offset, value)
end

function StreamBuffer:tostring()
    return buffer.readstring(self.buf, 0, self.len)
end

return StreamBuffer
