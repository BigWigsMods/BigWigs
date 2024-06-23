--[[
Copyright (c) 2020 Ross Nichols

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

Credits:
The following projects served as inspiration for aspects of this project:

1. LibDeflate, by Haoqian He. https://github.com/SafeteeWoW/LibDeflate
    For the CreateReader/CreateWriter functions.
2. lua-MessagePack, by François Perrad. https://framagit.org/fperrad/lua-MessagePack
    For the mechanism for packing/unpacking floats and ints.
3. LibQuestieSerializer, by aero. https://github.com/AeroScripts/LibQuestieSerializer
    For the basis of the implementation, and initial inspiration.
]]


-- Latest version can be found at https://github.com/rossnichols/LibSerialize.

--[[ BEGIN_README
# LibSerialize

LibSerialize is a Lua library for efficiently serializing/deserializing arbitrary values.
It supports serializing nils, numbers, booleans, strings, and tables containing these types.

It is best paired with [LibDeflate](https://github.com/safeteeWow/LibDeflate), to compress
the serialized output and optionally encode it for World of Warcraft addon or chat channels.
IMPORTANT: if you decide not to compress the output and plan on transmitting over an addon
channel, it still needs to be encoded, but encoding via `LibDeflate:EncodeForWoWAddonChannel()`
or `LibCompress:GetAddonEncodeTable()` will likely inflate the size of the serialization
by a considerable amount. See the usage below for an alternative.

Note that serialization and compression are sensitive to the specifics of your data set.
You should experiment with the available libraries (LibSerialize, AceSerializer, LibDeflate,
LibCompress, etc.) to determine which combination works best for you.


## Usage

```lua
-- Dependencies: AceAddon-3.0, AceComm-3.0, LibSerialize, LibDeflate
MyAddon = LibStub("AceAddon-3.0"):NewAddon("MyAddon", "AceComm-3.0")
local LibSerialize = LibStub("LibSerialize")
local LibDeflate = LibStub("LibDeflate")

function MyAddon:OnEnable()
    self:RegisterComm("MyPrefix")
end

-- With compression (recommended):
function MyAddon:Transmit(data)
    local serialized = LibSerialize:Serialize(data)
    local compressed = LibDeflate:CompressDeflate(serialized)
    local encoded = LibDeflate:EncodeForWoWAddonChannel(compressed)
    self:SendCommMessage("MyPrefix", encoded, "WHISPER", UnitName("player"))
end

function MyAddon:OnCommReceived(prefix, payload, distribution, sender)
    local decoded = LibDeflate:DecodeForWoWAddonChannel(payload)
    if not decoded then return end
    local decompressed = LibDeflate:DecompressDeflate(decoded)
    if not decompressed then return end
    local success, data = LibSerialize:Deserialize(decompressed)
    if not success then return end

    -- Handle `data`
end

-- Without compression (custom codec):
MyAddon._codec = LibDeflate:CreateCodec("\000", "\255", "")
function MyAddon:Transmit(data)
    local serialized = LibSerialize:Serialize(data)
    local encoded = self._codec:Encode(serialized)
    self:SendCommMessage("MyPrefix", encoded, "WHISPER", UnitName("player"))
end
function MyAddon:OnCommReceived(prefix, payload, distribution, sender)
    local decoded = self._codec:Decode(payload)
    if not decoded then return end
    local success, data = LibSerialize:Deserialize(decoded)
    if not success then return end

    -- Handle `data`
end

-- Async Mode - Used in WoW to prevent locking the game while processing.
-- Serialize data:
local processing = CreateFrame("Frame")
local handler = LibSerialize:SerializeAsync(data_to_serialize)
processing:SetScript("OnUpdate", function()
    local completed, serialized = handler()
    if completed then
        processing:SetScript("OnUpdate", nil)
        -- Do something with `serialized`
    end
end)

-- Deserialize data:
local handler = LibSerialize:DeserializeAsync(serialized)
processing:SetScript("OnUpdate", function()
    local completed, success, deserialized = handler()
    if completed then
        processing:SetScript("OnUpdate", nil)
        -- Do something with `deserialized`
    end
end)
```


## API
* **`LibSerialize:SerializeEx(opts, ...)`**

    Arguments:
    * `opts`: options (see [Serialization Options])
    * `...`: a variable number of serializable values

    Returns:
    * result: `...` serialized as a string

* **`LibSerialize:Serialize(...)`**

    Arguments:
    * `...`: a variable number of serializable values

    Returns:
    * `result`: `...` serialized as a string

    Calls `SerializeEx(opts, ...)` with the default options (see [Serialization Options])

* **`LibSerialize:Deserialize(input)`**

    Arguments:
    * `input`: a string previously returned from a LibSerialize serialization API,
      or an object that implements the [Reader protocol]

    Returns:
    * `success`: a boolean indicating if deserialization was successful
    * `...`: the deserialized value(s) if successful, or a string containing the encountered
      Lua error

* **`LibSerialize:DeserializeValue(input, opts)`**

    Arguments:
    * `input`: a string previously returned from a LibSerialize serialization API,
      or an object that implements the [Reader protocol]
    * `opts`: options (see [Deserialization Options])

    Returns:
    * `...`: the deserialized value(s)

* **`LibSerialize:IsSerializableType(...)`**

    Arguments:
    * `...`: a variable number of values

    Returns:
    * `result`: true if all of the values' types are serializable.

    Note that if you pass a table, it will be considered serializable
    even if it contains unserializable keys or values. Only the types
    of the arguments are checked.

`Serialize()` will raise a Lua error if the input cannot be serialized.
This will occur if any of the following exceed 16777215: any string length,
any table key count, number of unique strings, number of unique tables.
It will also occur by default if any unserializable types are encountered,
though that behavior may be disabled (see [Serialization Options]).

`Deserialize()` and `DeserializeValue()` are equivalent, except the latter
returns the deserialization result directly and will not catch any Lua
errors that may occur when deserializing invalid input.

As of recent releases, the library supports reentrancy and concurrent usage
from multiple threads (coroutines) through the public API. Modifying tables
during the serialization process is unspecified and should be avoided.
Table serialization is multi-phased and assumes a consistent state for the
key/value pairs across the phases.

It is permitted for any user-supplied functions to suspend the current
thread during the serialization or deserialization process. It is however
not possible to yield the current thread if the `Deserialize()` API is used,
as this function inserts a C call boundary onto the call stack. This issue
does not affect the `DeserializeValue()` function.


## Asynchronous API

* **`LibSerialize:SerializeAsyncEx(opts, ...)`**

    Arguments:
    * `opts`: options (optional, see [Serialization Options])
    * `...`: a variable number of serializable values

    Returns:
    * `handler`: function that performs the serialization. This should be called with
      no arguments until the  first returned value is false.
      `handler` returns:
      * `completed`: a boolean indicating whether serialization is finished
      * `result`: once complete, `...` serialized as a string

    Calls `SerializeEx(opts, ...)` with the specified options, as well as setting
    the `async` option to true (see [Serialization Options]). Note that the passed-in
    table is written to when doing so.

* **`LibSerialize:SerializeAsync(...)`**

    Arguments:
    * `...`: a variable number of serializable values

    Returns:
    * `handler`: function that performs the serialization. This should be called with
      no arguments until the  first returned value is false.
      `handler` returns:
      * `completed`: a boolean indicating whether serialization is finished
      * `result`: once complete, `...` serialized as a string

    Calls `SerializeEx(opts, ...)` with the default options, as well as setting
    the `async` option to true (see [Serialization Options]). Note that the passed-in
    table is written to when doing so.

* **`LibSerialize:DeserializeAsync(input, opts)`**

    Arguments:
    * `input`: a string previously returned from a LibSerialize serialization API
    * `opts`: options (optional, see [Deserialization Options])

    Returns:
    * `handler`: function that performs the deserialization. This should be called with
      no arguments until the  first returned value is false.
      `handler` returns:
      * `completed`: a boolean indicating whether deserialization is finished
      * `success`: once complete, a boolean indicating if deserialization was successful
      * `...`: once complete, the deserialized value(s) if successful, or a string containing
        the encountered Lua error

    Calls `DeserializeValue(opts, ...)` with the specified options, as well as setting
    the `async` option to true (see [Deserialization Options]). Note that the passed-in
    table is written to when doing so.

Errors encountered when serializing behave the same way as the synchronous APIs.
Errors encountered when deserializing will always be caught and returned via the
handler's return values, even if `DeserializeValue()` is called directly. This is
different than when calling `DeserializeValue()` in synchronous mode.


## Serialization Options
The following serialization options are supported:
* `errorOnUnserializableType`: `boolean` (default true)
  * `true`: unserializable types will raise a Lua error
  * `false`: unserializable types will be ignored. If it's a table key or value,
     the key/value pair will be skipped. If it's one of the arguments to the
     call to SerializeEx(), it will be replaced with `nil`.
* `stable`: `boolean` (default false)
  * `true`: the resulting string will be stable, even if the input includes
     maps. This option comes with an extra memory usage and CPU time cost.
  * `false`: the resulting string will be unstable and will potentially differ
     between invocations if the input includes maps
* `filter`: `function(t, k, v) => boolean` (default nil)
  * If specified, the function will be called on every key/value pair in every
    table encountered during serialization. The function must return true for
    the pair to be serialized. It may be called multiple times on a table for
    the same key/value pair. See notes on reeentrancy and table modification.
* `async`: `boolean` (default false)
  * `true`: the API returns a coroutine that performs the serialization
  * `false`: the API performs the serialization directly
* `yieldCheck`: `function(t) => boolean` (default impl yields after 4096 items)
  * Only applicable when serializing asynchronously. If specified, the function
    will be called every time an item is about to be serialized. If the function
    returns true, the coroutine will yield. The function is passed a "scratch"
    table into which it can persist state.
* `writer`: `any` (default nil)
  * If specified, the object referenced by this field will be checked to see
    if it implements the [Writer protocol]. If so, the functions it defines
    will be used to control how serialized data is written.


## Deserialization Options
The following deserialization options are supported:
* `async`: `boolean` (default false)
  * `true`: the API returns a coroutine that performs the deserialization
  * `false`: the API performs the deserialization directly
* `yieldCheck`: `function(t) => boolean` (default impl yields after 4096 items)
  * Only applicable when deserializing asynchronously. If specified, the function
    will be called every time an item is about to be deserialized. If the function
    returns true, the coroutine will yield. The function is passed a "scratch"
    table into which it can persist state.

If an option is unspecified in the table, then its default will be used.
This means that if an option `foo` defaults to true, then:
* `myOpts.foo = false`: option `foo` is false
* `myOpts.foo = nil`: option `foo` is true


## Reader Protocol
The library supports customizing how serialized data is provided to the
deserialization functions through the use of the "Reader" protocol. This
enables advanced use cases such as batched or throttled deserialization via
coroutines, or processing serialized data of an unknown-length in a streamed
manner.

Any value supplied as the `input` to any deserialization function will be
inspected and indexed to search for the following keys. If provided, these
will override default behaviors otherwise implemented by the library.

* `ReadBytes`: `function(input, i, j) => string` (optional)
  * If specified, this function will be called every time the library needs
    to read a sequence of bytes as a string from the supplied input. The range
    of bytes is passed in the `i` and `j` parameters, with similar semantics
    to standard Lua functions such as `string.sub` and `table.concat`. This
    function must return a string whose length is equal to the requested range
    of bytes.

    It is permitted for this function to error if the range of bytes would
    exceed the available bytes; if an error is raised it will pass through
    the library back to the caller of Deserialize/DeserializeValue.

    If not supplied, the default implementation will access the contents of
    `input` as if it were a string and call `string.sub(input, i, j)`.

* `AtEnd`: `function(input, i) => boolean` (optional)
  * If specified, this function will be called whenever the library needs to
    test if the end of the input has been reached. The `i` parameter will be
    supplied a byte offset from the start of the input, and should typically
    return `true` if `i` is greater than the length of `input`.

    If this function returns true, the stream is considered ended and further
    values will not be deserialized. If this function returns false,
    deserialization of further values will continue until it returns true.

    If not supplied, the default implementation will compare the offset `i`
    against the length of `input` as obtained through the `#` operator.


## Writer Protocol
The library supports customizing how byte strings are written during the
serialization process through the use of an object that implements the
"Writer" protocol. This enables advanced use cases such as batched or throttled
serialization via coroutines, or streaming the data to a target instead of
processing it all in one giant chunk.

Any value stored on the `writer` key of the options table passed to the
`SerializeEx()` function will be inspected and indexed to search for the
following keys. If the required keys are all found, all operations provided
by the writer will override the default behaviors otherwise implemented by
the library. Otherwise, the writer is ignored and not used for any operations.

* `WriteString`: `function(writer, str)` (required)
  * This function will be called each time the library submits a byte string
    that was created as result of serializing data.

    If this function is not supplied, the supplied `writer` is considered
    incomplete and will be ignored for all operations.

* `Flush`: `function(writer)` (optional)
  * If specified, this function will be called at the end of the serialization
    process. It may return any number of values - including zero - all of
    which will be passed through to the caller of `SerializeEx()` verbatim.

    The default behavior if this function is not specified - and if the writer
    is otherwise valid - is a no-op that returns no values.


## Customizing table serialization
For any serialized table, LibSerialize will check for the presence of a
metatable key `__LibSerialize`. It will be interpreted as a table with
the following possible keys:
* `filter`: `function(t, k, v) => boolean`
  * If specified, the function will be called on every key/value pair in that
    table. The function must return true for the pair to be serialized. It may
    be called multiple times on a table for the same key/value pair. See notes
    on reeentrancy and table modification. If combined with the `filter` option,
    both functions must return true.


## Examples
1. `LibSerialize:Serialize()` supports variadic arguments and arbitrary key types,
   maintaining a consistent internal table identity.
    ```lua
    local t = { "test", [false] = {} }
    t[ t[false] ] = "hello"
    local serialized = LibSerialize:Serialize(t, "extra")
    local success, tab, str = LibSerialize:Deserialize(serialized)
    assert(success)
    assert(tab[1] == "test")
    assert(tab[ tab[false] ] == "hello")
    assert(str == "extra")
    ```

2. Normally, unserializable types raise an error when encountered during serialization,
   but that behavior can be disabled in order to silently ignore them instead.
    ```lua
    local serialized = LibSerialize:SerializeEx(
        { errorOnUnserializableType = false },
        print, { a = 1, b = print })
    local success, fn, tab = LibSerialize:Deserialize(serialized)
    assert(success)
    assert(fn == nil)
    assert(tab.a == 1)
    assert(tab.b == nil)
    ```

3. Tables may reference themselves recursively and will still be serialized properly.
    ```lua
    local t = { a = 1 }
    t.t = t
    t[t] = "test"
    local serialized = LibSerialize:Serialize(t)
    local success, tab = LibSerialize:Deserialize(serialized)
    assert(success)
    assert(tab.t.t.t.t.t.t.a == 1)
    assert(tab[tab.t] == "test")
    ```

4. You may specify a global filter that applies to all tables encountered during
   serialization, and to individual tables via their metatable.
    ```lua
    local t = { a = 1, b = print, c = 3 }
    local nested = { a = 1, b = print, c = 3 }
    t.nested = nested
    setmetatable(nested, { __LibSerialize = {
        filter = function(t, k, v) return k ~= "c" end
    }})
    local opts = {
        filter = function(t, k, v) return LibSerialize:IsSerializableType(k, v) end
    }
    local serialized = LibSerialize:SerializeEx(opts, t)
    local success, tab = LibSerialize:Deserialize(serialized)
    assert(success)
    assert(tab.a == 1)
    assert(tab.b == nil)
    assert(tab.c == 3)
    assert(tab.nested.a == 1)
    assert(tab.nested.b == nil)
    assert(tab.nested.c == nil)
    ```

5. You may perform the serialization and deserialization operations asynchronously,
   to avoid blocking for excessive durations when handling large amounts of data.
   Note that you wouldn't call the handlers in a repeat-until loop like below, because
   then you're still effectively performing the operations synchronously.
    ```lua
    local t = { "test", [false] = {} }
    t[ t[false] ] = "hello"
    local co_handler = LibSerialize:SerializeAsync(t, "extra")
    local completed, serialized
    repeat
        completed, serialized = co_handler()
    until completed

    local completed, success, tab, str
    local co_handler = LibSerialize:DeserializeAsync(serialized)
    repeat
        completed, success, tab, str = co_handler()
    until completed

    assert(success)
    assert(tab[1] == "test")
    assert(tab[ tab[false] ] == "hello")
    assert(str == "extra")
    ```

6. You may use the Reader and Writer protocols to have more control over writing the
   results of serialization, or how those results are read when deserializing. The below
   example implements the default behavior of the library using these protocols.
    ```lua
    local t = { a = 1, b = 2, c = 3 }

    local StandardWriter = {}
    function StandardWriter:Initialize()
        self.buffer = {}
        self.bufferSize = 0
    end
    function StandardWriter:WriteString(str)
        self.bufferSize = self.bufferSize + 1
        self.buffer[self.bufferSize] = str
    end
    function StandardWriter:Flush()
        local flushed = table.concat(self.buffer, "", 1, self.bufferSize)
        self.bufferSize = 0
        return flushed
    end

    local StandardReader = {}
    function StandardReader:Initialize(input)
        self.input = input
    end
    function StandardReader:ReadBytes(startOffset, endOffset)
        return string.sub(self.input, startOffset, endOffset)
    end
    function StandardReader:AtEnd(offset)
        return offset > #self.input
    end

    StandardWriter:Initialize()
    local serialized = LibSerialize:SerializeEx({ writer = StandardWriter }, t)

    StandardReader:Initialize(serialized)
    local success, tab = LibSerialize:Deserialize(StandardReader)

    assert(success)
    assert(tab.a == 1)
    assert(tab.b == 2)
    assert(tab.c == 3)
    ```


## Encoding format
Every object is encoded as a type byte followed by type-dependent payload.

For numbers, the payload is the number itself, using a number of bytes
appropriate for the number. Small numbers can be embedded directly into
the type byte, optionally with an additional byte following for more
possible values. Negative numbers are encoded as their absolute value,
with the type byte indicating that it is negative. Floats are decomposed
into their eight bytes, unless serializing as a string is shorter.

For strings and tables, the length/count is also encoded so that the
payload doesn't need a special terminator. Small counts can be embedded
directly into the type byte, whereas larger counts are encoded directly
following the type byte, before the payload.

Strings are stored directly, with no transformations. Tables are stored
in one of three ways, depending on their layout:
* Array-like: all keys are numbers starting from 1 and increasing by 1.
    Only the table's values are encoded.
* Map-like: the table has no array-like keys.
    The table is encoded as key-value pairs.
* Mixed: the table has both map-like and array-like keys.
    The table is encoded first with the values of the array-like keys,
    followed by key-value pairs for the map-like keys. For this version,
    two counts are encoded, one each for the two different portions.

Strings and tables are also tracked as they are encountered, to detect reuse.
If a string or table is reused, it is encoded instead as an index into the
tracking table for that type. Strings must be >2 bytes in length to be tracked.
Tables may reference themselves recursively.


#### Type byte:
The type byte uses the following formats to implement the above:

* `NNNN NNN1`: a 7 bit non-negative int
* `CCCC TT10`: a 2 bit type index and 4 bit count (strlen, #tab, etc.)
    * Followed by the type-dependent payload
* `NNNN S100`: the lower four bits of a 12 bit int and 1 bit for its sign
    * Followed by a byte for the upper bits
* `TTTT T000`: a 5 bit type index
    * Followed by the type-dependent payload, including count(s) if needed

[Serialization Options]: #serialization-options
[Deserialization Options]: #deserialization-options
[Reader protocol]: #reader-protocol
[Writer protocol]: #writer-protocol
END_README --]]

local MAJOR, MINOR = "LibSerialize", 5
local LibSerialize
if LibStub then
    LibSerialize = LibStub:NewLibrary(MAJOR, MINOR)
    if not LibSerialize then return end -- This version is already loaded.
else
    LibSerialize = {}
end

-- Rev the serialization version when making a breaking change.
-- Make sure to handle older versions properly within LibSerialize:DeserializeValue.
-- NOTE: these normally can be idential, but due to a bug when revving MINOR to 2,
-- we need to support both 1 and 2 as v1 serialization versions.
local SERIALIZATION_VERSION = 1
local DESERIALIZATION_VERSION = 2


--[[---------------------------------------------------------------------------
    Local overrides of otherwise global library functions
--]]---------------------------------------------------------------------------

local assert = assert
local coroutine_create = coroutine.create
local coroutine_resume = coroutine.resume
local coroutine_status = coroutine.status
local coroutine_yield = coroutine.yield
local error = error
local getmetatable = getmetatable
local ipairs = ipairs
local math_floor = math.floor
local math_huge = math.huge
local math_max = math.max
local math_modf = math.modf
local pairs = pairs
local pcall = pcall
local print = print
local select = select
local setmetatable = setmetatable
local string_byte = string.byte
local string_char = string.char
local string_sub = string.sub
local table_concat = table.concat
local table_insert = table.insert
local table_sort = table.sort
local tonumber = tonumber
local tostring = tostring
local type = type

-- Compatibility shim to allow the library to work on Lua 5.4
local unpack = unpack or table.unpack
local frexp = math.frexp or function(num)
    if num == math_huge then return num end
    local fraction, exponent = num, 0
    if fraction ~= 0 then
        while fraction >= 1 do
            fraction = fraction / 2
            exponent = exponent + 1
        end
        while fraction < 0.5 do
            fraction = fraction * 2
            exponent = exponent - 1
        end
    end
    return fraction, exponent
end
local ldexp = math.ldexp or function(m, e)
    return m * 2 ^ e
end

-- If in an environment that supports `require` and `_ENV` (note: WoW does not),
-- then block reading/writing of globals. All needed globals should have been
-- converted to upvalues above.
if require and _ENV then
    _ENV = setmetatable({}, {
        __newindex = function(t, k, v)
            assert(false, "Attempt to write to global variable: " .. k)
        end,
        __index = function(t, k)
            assert(false, "Attempt to read global variable: " .. k)
        end
    })
end


--[[---------------------------------------------------------------------------
    Library defaults.
--]]---------------------------------------------------------------------------

local defaultYieldCheck = function(self)
    self._currentObjectCount = self._currentObjectCount or 0
    if self._currentObjectCount > 4096 then
        self._currentObjectCount = 0
        return true
    end
    self._currentObjectCount = self._currentObjectCount + 1
end
local defaultSerializeOptions = {
    errorOnUnserializableType = true,
    stable = false,
    filter = nil,
    writer = nil,
    async = false,
    yieldCheck = defaultYieldCheck,
}
local defaultAsyncOptions = {
    async = true,
}
local defaultDeserializeOptions = {
    async = false,
    yieldCheck = defaultYieldCheck,
}

local canSerializeFnOptions = {
    errorOnUnserializableType = false
}


--[[---------------------------------------------------------------------------
    Helper functions.
--]]---------------------------------------------------------------------------

-- Returns the number of bytes required to store the value,
-- up to a maximum of three. Errors if three bytes is insufficient.
local function GetRequiredBytes(value)
    if value < 256 then return 1 end
    if value < 65536 then return 2 end
    if value < 16777216 then return 3 end
    error("Object limit exceeded")
end

-- Returns the number of bytes required to store the value,
-- though always returning seven if four bytes is insufficient.
-- Doubles have room for 53bit numbers, so seven bits max.
local function GetRequiredBytesNumber(value)
    if value < 256 then return 1 end
    if value < 65536 then return 2 end
    if value < 16777216 then return 3 end
    if value < 4294967296 then return 4 end
    return 7
end

-- Queries a given object for the value assigned to a specific key.
--
-- If the given object cannot be indexed, an error may be raised by the Lua
-- implementation.
local function GetValueByKey(object, key)
    return object[key]
end

-- Queries a given object for the value assigned to a specific key, returning
-- it if non-nil or giving back a default.
--
-- If the given object cannot be indexed, the default will be returned and
-- no error raised.
local function GetValueByKeyOrDefault(object, key, default)
    local ok, value = pcall(GetValueByKey, object, key)

    if not ok or value == nil then
        return default
    else
        return value
    end
end

-- Returns whether the value (a number) is NaN.
local function IsNaN(value)
    -- With floating point optimizations enabled all comparisons involving
    -- NaNs will return true. Without them, these will both return false.
    return (value < 0) == (value >= 0)
end

-- Returns whether the value (a number) is finite, as opposed to being a
-- NaN or infinity.
local function IsFinite(value)
    return value > -math_huge and value < math_huge and not IsNaN(value)
end

-- Returns whether the value (a number) is fractional,
-- as opposed to a whole number.
local function IsFractional(value)
    local _, fract = math_modf(value)
    return fract ~= 0
end

-- Returns whether the value (a number) needs to be represented as a floating
-- point number due to either being fractional or non-finite.
local function IsFloatingPoint(value)
    return IsFractional(value) or not IsFinite(value)
end

-- Returns true if the given table key is an integer that can reside in the
-- array section of a table (keys 1 through arrayCount).
local function IsArrayKey(k, arrayCount)
    return type(k) == "number" and k >= 1 and k <= arrayCount and not IsFloatingPoint(k)
end

-- Portable no-op function that does absolutely nothing, and pushes no returns
-- onto the stack.
local function Noop()
end

-- Sort compare function which is used to sort table keys to ensure that the
-- serialization of maps is stable. We arbitrarily put strings first, then
-- numbers, and finally booleans.
local function StableKeySort(a, b)
    local aType = type(a)
    local bType = type(b)
    -- Put strings first
    if aType == "string" and bType == "string" then
        return a < b
    elseif aType == "string" then
        return true
    elseif bType == "string" then
        return false
    end
    -- Put numbers next
    if aType == "number" and bType == "number" then
        return a < b
    elseif aType == "number" then
        return true
    elseif bType == "number" then
        return false
    end
    -- Put booleans last
    if aType == "boolean" and bType == "boolean" then
        return (a and 1 or 0) < (b and 1 or 0)
    else
        error(("Unhandled sort type(s): %s, %s"):format(aType, bType))
    end
end

-- Prints args to the chat window. To enable debug statements,
-- do a find/replace in this file with "-- DebugPrint(" for "DebugPrint(",
-- or the reverse to disable them again.
local DebugPrint = function(...)
    print(...)
end


--[[---------------------------------------------------------------------------
    Helpers for reading/writing streams of bytes from/to a string
--]]---------------------------------------------------------------------------

-- Generic writer functions that defer their work to previously defined helpers.
local function Writer_WriteString(self, str)
    if self.opts.async and self.opts.yieldCheck(self.asyncScratch) then
        coroutine_yield()
    end

    self.writeString(self.writer, str)
end

local function Writer_FlushWriter(self)
    return self.flushWriter(self.writer)
end

-- Functions for a writer that will lazily construct a string over multiple writes.
local function BufferedWriter_WriteString(self, str)
    self.bufferSize = self.bufferSize + 1
    self.buffer[self.bufferSize] = str
end

local function BufferedWriter_FlushBuffer(self)
    local flushed = table_concat(self.buffer, "", 1, self.bufferSize)
    self.bufferSize = 0
    return flushed
end

-- Creates a writer object that will be called to write the serialized output.
-- Return values:
-- 1. Writer object
-- 2. WriteString(obj, str)
-- 3. FlushWriter(obj)
local function CreateWriter(opts)
    -- If the supplied object implements the required functions to satisfy
    -- the Writer interface, it will be used exclusively. Otherwise if any
    -- of those are missing, the object is entirely ignored and we'll use
    -- the original buffer-of-strings approach.

    local object = {
        opts = opts,
        asyncScratch = opts.async and {} or nil,
    }

    local writeString = GetValueByKeyOrDefault(opts.writer, "WriteString", nil)

    if writeString == nil then
        -- Configure the object for the BufferedWriter approach.
        object.writer = object
        object.buffer = {}
        object.bufferSize = 0
        object.writeString = BufferedWriter_WriteString
        object.flushWriter = BufferedWriter_FlushBuffer
    else
        -- Note that for custom writers if no Flush implementation is given the
        -- default is a no-op; this means that no values will be returned to the
        -- caller of Serialize/SerializeEx. It's expected in such a case that
        -- you will have written the strings elsewhere yourself; perhaps having
        -- already submitted them for transmission via a comms API for example.

        object.writer = opts.writer
        object.writeString = writeString
        object.flushWriter = GetValueByKeyOrDefault(opts.writer, "Flush", Noop)
    end

    return object, Writer_WriteString, Writer_FlushWriter
end

-- Generic reader functions that defer their work to previously defined helpers.
local function Reader_ReadBytes(self, bytelen)
    if self.opts.async and self.opts.yieldCheck(self.asyncScratch) then
        coroutine_yield()
    end

    local result = self.readBytes(self.input, self.nextPos, self.nextPos + bytelen - 1)
    self.nextPos = self.nextPos + bytelen
    return result
end

local function Reader_AtEnd(self)
    return self.atEnd(self.input, self.nextPos)
end

-- Implements the default end-of-stream check for a reader. This requires
-- that the supplied input object supports the length operator.
local function GenericReader_AtEnd(input, offset)
    return offset > #input
end

-- Creates a reader object that will be called to read the to-be-deserialized input.
-- Return values:
-- 1. Reader object
-- 2. ReadBytes(bytelen)
-- 3. ReaderAtEnd()
local function CreateReader(input, opts)
    -- We allow any type of input to be given and queried for the custom
    -- reader interface; any errors that arise when attempting to index these
    -- fields are swallowed silently with fallbacks to suitable defaults.

    local object = {
        input = input,
        nextPos = 1,
        opts = opts,
        asyncScratch = opts.async and {} or nil,
        readBytes = GetValueByKeyOrDefault(input, "ReadBytes", string_sub),
        atEnd = GetValueByKeyOrDefault(input, "AtEnd", GenericReader_AtEnd),
    }

    return object, Reader_ReadBytes, Reader_AtEnd
end


--[[---------------------------------------------------------------------------
    Helpers for serializing/deserializing numbers (ints and floats)
--]]---------------------------------------------------------------------------

local function FloatToString(n)
    if IsNaN(n) then -- nan
        return string_char(0xFF, 0xF8, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00)
    end

    local sign = 0
    if n < 0.0 then
        sign = 0x80
        n = -n
    end
    local mant, expo = frexp(n)

    -- If n is infinity, mant will be infinity inside WoW, but NaN elsewhere.
    if (mant == math_huge or IsNaN(mant)) or expo > 0x400 then
        if sign == 0 then -- inf
            return string_char(0x7F, 0xF0, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00)
        else -- -inf
            return string_char(0xFF, 0xF0, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00)
        end
    elseif (mant == 0.0 and expo == 0) or expo < -0x3FE then -- zero
        return string_char(sign, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00)
    else
        expo = expo + 0x3FE
        mant = math_floor((mant * 2.0 - 1.0) * ldexp(0.5, 53))
        return string_char(sign + math_floor(expo / 0x10),
                           (expo % 0x10) * 0x10 + math_floor(mant / 281474976710656),
                           math_floor(mant / 1099511627776) % 256,
                           math_floor(mant / 4294967296) % 256,
                           math_floor(mant / 16777216) % 256,
                           math_floor(mant / 65536) % 256,
                           math_floor(mant / 256) % 256,
                           mant % 256)
    end
end

local function StringToFloat(str)
    local b1, b2, b3, b4, b5, b6, b7, b8 = string_byte(str, 1, 8)
    local sign = b1 > 0x7F
    local expo = (b1 % 0x80) * 0x10 + math_floor(b2 / 0x10)
    local mant = ((((((b2 % 0x10) * 256 + b3) * 256 + b4) * 256 + b5) * 256 + b6) * 256 + b7) * 256 + b8
    if sign then
        sign = -1
    else
        sign = 1
    end
    local n
    if mant == 0 and expo == 0 then
        n = sign * 0.0
    elseif expo == 0x7FF then
        if mant == 0 then
            n = sign * math_huge
        else
            n = 0.0/0.0
        end
    else
        n = sign * ldexp(1.0 + mant / 4503599627370496.0, expo - 0x3FF)
    end
    return n
end

local function IntToString(n, required)
    if required == 1 then
        return string_char(n)
    elseif required == 2 then
        return string_char(math_floor(n / 256),
                           n % 256)
    elseif required == 3 then
        return string_char(math_floor(n / 65536),
                           math_floor(n / 256) % 256,
                           n % 256)
    elseif required == 4 then
        return string_char(math_floor(n / 16777216),
                           math_floor(n / 65536) % 256,
                           math_floor(n / 256) % 256,
                           n % 256)
    elseif required == 7 then
        return string_char(math_floor(n / 281474976710656) % 256,
                           math_floor(n / 1099511627776) % 256,
                           math_floor(n / 4294967296) % 256,
                           math_floor(n / 16777216) % 256,
                           math_floor(n / 65536) % 256,
                           math_floor(n / 256) % 256,
                           n % 256)
    end

    error("Invalid required bytes: " .. required)
end

local function StringToInt(str, required)
    if required == 1 then
        return string_byte(str)
    elseif required == 2 then
        local b1, b2 = string_byte(str, 1, 2)
        return b1 * 256 + b2
    elseif required == 3 then
        local b1, b2, b3 = string_byte(str, 1, 3)
        return (b1 * 256 + b2) * 256 + b3
    elseif required == 4 then
        local b1, b2, b3, b4 = string_byte(str, 1, 4)
        return ((b1 * 256 + b2) * 256 + b3) * 256 + b4
    elseif required == 7 then
        local b1, b2, b3, b4, b5, b6, b7, b8 = 0, string_byte(str, 1, 7)
        return ((((((b1 * 256 + b2) * 256 + b3) * 256 + b4) * 256 + b5) * 256 + b6) * 256 + b7) * 256 + b8
    end

    error("Invalid required bytes: " .. required)
end


--[[---------------------------------------------------------------------------
    Internal functionality:
    The `LibSerializeInt` table contains internal, immutable state (functions, tables)
    that is copied to a new table each time serialization/deserialization is
    invoked, so that each invocation has its own state encapsulated. Copying the
    state is preferred to a metatable, since we don't want to pay the cost of the
    indirection overhead every time we access one of the copied keys.
--]]---------------------------------------------------------------------------

local LibSerializeInt = {}

local function CreateSerializer(opts, ...)
    local ser = {}

    -- Copy the state from LibSerializeInt.
    for k, v in pairs(LibSerializeInt) do
        ser[k] = v
    end

    -- Initialize string/table reference storage.
    ser._stringRefs = {}
    ser._tableRefs = {}

    -- Create a combined options table, starting with the defaults
    -- and then overwriting any user-supplied keys.
    ser._opts = {}
    for k, v in pairs(defaultSerializeOptions) do
        ser._opts[k] = v
    end
    for k, v in pairs(opts) do
        ser._opts[k] = v
    end

    -- Create the writer.
    ser._writer, ser._writeString, ser._flushWriter = CreateWriter(ser._opts)

    -- If the input was passed to this function, stash it away.
    if select("#", ...) ~= 0 then
        ser._input = {...}
        ser._inputLen = select("#", ...)
    end

    return ser
end

local function Serialize(ser, ...)
    -- If the input was previously stashed away, use that instead.
    if ser._input then
        assert(select("#", ...) == 0, "Input args should only be passed one way")
        local input = ser._input
        ser._input = nil
        return Serialize(ser, unpack(input, 1, ser._inputLen))
    end

    ser:_WriteByte(SERIALIZATION_VERSION)

    for i = 1, select("#", ...) do
        local input = select(i, ...)
        if not ser:_WriteObject(input) then
            -- An unserializable object was passed as an argument.
            -- Write nil into its slot so that we deserialize a
            -- consistent number of objects from the resulting string.
            ser:_WriteObject(nil)
        end
    end

    return ser._flushWriter(ser._writer)
end

local function CheckSerializationProgress(thread, co_success, result)
    if not co_success then
        return error(result)
    elseif coroutine_status(thread) ~= 'dead' then
        return false
    else
        return true, result
    end
end

local function CreateDeserializer(input, opts)
    local deser = {}

    -- Copy the state from LibSerializeInt.
    for k, v in pairs(LibSerializeInt) do
        deser[k] = v
    end

    -- Initialize string/table reference storage.
    deser._stringRefs = {}
    deser._tableRefs = {}

    -- Create a combined options table, starting with the defaults
    -- and then overwriting any user-supplied keys.
    deser._opts = {}
    for k, v in pairs(defaultDeserializeOptions) do
        deser._opts[k] = v
    end
    for k, v in pairs(opts) do
        deser._opts[k] = v
    end

    -- Create the reader.
    deser._reader, deser._readBytes, deser._readerAtEnd = CreateReader(input, deser._opts)

    return deser
end

local function Deserialize(deser)
    -- Since there's only one compression version currently,
    -- no extra work needs to be done to decode the data.
    local version = deser:_ReadByte()
    assert(version <= DESERIALIZATION_VERSION, "Unknown serialization version!")

    -- Since the objects we read may be nil, we need to explicitly
    -- track the number of results and assign by index so that we
    -- can call unpack() successfully at the end.
    local output = {}
    local outputSize = 0

    while not deser._readerAtEnd(deser._reader) do
        outputSize = outputSize + 1
        output[outputSize] = deser:_ReadObject()
    end

    return unpack(output, 1, outputSize)
end

local function CheckDeserializationProgress(thread, co_success, ...)
    if not co_success then
        return true, false, ...
    elseif coroutine_status(thread) ~= "dead" then
        return false
    else
        return true, true, ...
    end
end


--[[---------------------------------------------------------------------------
    Object reuse:
    As strings/tables are serialized or deserialized, they are stored in a lookup
    table in case they're encountered again, at which point they can be referenced
    by their index into their table rather than repeating the string contents.
--]]---------------------------------------------------------------------------

function LibSerializeInt:_AddReference(refs, value)
    local ref = #refs + 1
    refs[ref] = value
    refs[value] = ref
end


--[[---------------------------------------------------------------------------
    Read (deserialization) support.
--]]---------------------------------------------------------------------------

function LibSerializeInt:_ReadObject()
    local value = self:_ReadByte()

    if value % 2 == 1 then
        -- Number embedded in the top 7 bits.
        local num = (value - 1) / 2
        -- DebugPrint("Found embedded number (1byte):", value, num)
        return num
    end

    if value % 4 == 2 then
        -- Type with embedded count. Extract both.
        -- The type is in bits 3-4, count in 5-8.
        local typ = (value - 2) / 4
        local count = (typ - typ % 4) / 4
        typ = typ % 4
        -- DebugPrint("Found type with embedded count:", value, typ, count)
        return self._EmbeddedReaderTable[typ](self, count)
    end

    if value % 8 == 4 then
        -- Number embedded in the top 4 bits, plus an additional byte's worth (so 12 bits).
        -- If bit 4 is set, the number is negative.
        local packed = self:_ReadByte() * 256 + value
        local num
        if value % 16 == 12 then
            num = -(packed - 12) / 16
        else
            num = (packed - 4) / 16
        end
        -- DebugPrint("Found embedded number (2bytes):", value, packed, num)
        return num
    end

    -- Otherwise, the type index is embedded in the upper 5 bits.
    local typ = value / 8
    -- DebugPrint("Found type:", value, typ)
    return self._ReaderTable[typ](self)
end

function LibSerializeInt:_ReadTable(entryCount, value)
    -- DebugPrint("Extracting keys/values for table:", entryCount)

    if value == nil then
        value = {}
        self:_AddReference(self._tableRefs, value)
    end

    for _ = 1, entryCount do
        local k, v = self:_ReadPair(self._ReadObject)
        value[k] = v
    end

    return value
end

function LibSerializeInt:_ReadArray(entryCount, value)
    -- DebugPrint("Extracting values for array:", entryCount)

    if value == nil then
        value = {}
        self:_AddReference(self._tableRefs, value)
    end

    for i = 1, entryCount do
        value[i] = self:_ReadObject()
    end

    return value
end

function LibSerializeInt:_ReadMixed(arrayCount, mapCount)
    -- DebugPrint("Extracting values for mixed table:", arrayCount, mapCount)

    local value = {}
    self:_AddReference(self._tableRefs, value)

    self:_ReadArray(arrayCount, value)
    self:_ReadTable(mapCount, value)

    return value
end

function LibSerializeInt:_ReadString(len)
    -- DebugPrint("Reading string,", len)

    local value = self._readBytes(self._reader, len)
    if len > 2 then
        self:_AddReference(self._stringRefs, value)
    end
    return value
end

function LibSerializeInt:_ReadByte()
    -- DebugPrint("Reading byte")

    return self:_ReadInt(1)
end

function LibSerializeInt:_ReadInt(required)
    -- DebugPrint("Reading int", required)

    return StringToInt(self._readBytes(self._reader, required), required)
end

function LibSerializeInt:_ReadPair(fn, ...)
    local first = fn(self, ...)
    local second = fn(self, ...)
    return first, second
end

local embeddedIndexShift = 4
local embeddedCountShift = 16
LibSerializeInt._EmbeddedIndex = {
    STRING = 0,
    TABLE = 1,
    ARRAY = 2,
    MIXED = 3,
}
LibSerializeInt._EmbeddedReaderTable = {
    [LibSerializeInt._EmbeddedIndex.STRING] = function(self, c) return self:_ReadString(c) end,
    [LibSerializeInt._EmbeddedIndex.TABLE] =  function(self, c) return self:_ReadTable(c) end,
    [LibSerializeInt._EmbeddedIndex.ARRAY] =  function(self, c) return self:_ReadArray(c) end,
    -- For MIXED, the 4-bit count contains two 2-bit counts that are one less than the true count.
    [LibSerializeInt._EmbeddedIndex.MIXED] =  function(self, c) return self:_ReadMixed((c % 4) + 1, math_floor(c / 4) + 1) end,
}

local readerIndexShift = 8
LibSerializeInt._ReaderIndex = {
    NIL = 0,

    NUM_16_POS = 1,
    NUM_16_NEG = 2,
    NUM_24_POS = 3,
    NUM_24_NEG = 4,
    NUM_32_POS = 5,
    NUM_32_NEG = 6,
    NUM_64_POS = 7,
    NUM_64_NEG = 8,
    NUM_FLOAT = 9,
    NUM_FLOATSTR_POS = 10,
    NUM_FLOATSTR_NEG = 11,

    BOOL_T = 12,
    BOOL_F = 13,

    STR_8 = 14,
    STR_16 = 15,
    STR_24 = 16,

    TABLE_8 = 17,
    TABLE_16 = 18,
    TABLE_24 = 19,

    ARRAY_8 = 20,
    ARRAY_16 = 21,
    ARRAY_24 = 22,

    MIXED_8 = 23,
    MIXED_16 = 24,
    MIXED_24 = 25,

    STRINGREF_8 = 26,
    STRINGREF_16 = 27,
    STRINGREF_24 = 28,

    TABLEREF_8 = 29,
    TABLEREF_16 = 30,
    TABLEREF_24 = 31,
}
LibSerializeInt._ReaderTable = {
    -- Nil
    [LibSerializeInt._ReaderIndex.NIL]  = function(self) return nil end,

    -- Numbers (ones requiring <=12 bits are handled separately)
    [LibSerializeInt._ReaderIndex.NUM_16_POS] = function(self) return self:_ReadInt(2) end,
    [LibSerializeInt._ReaderIndex.NUM_16_NEG] = function(self) return -self:_ReadInt(2) end,
    [LibSerializeInt._ReaderIndex.NUM_24_POS] = function(self) return self:_ReadInt(3) end,
    [LibSerializeInt._ReaderIndex.NUM_24_NEG] = function(self) return -self:_ReadInt(3) end,
    [LibSerializeInt._ReaderIndex.NUM_32_POS] = function(self) return self:_ReadInt(4) end,
    [LibSerializeInt._ReaderIndex.NUM_32_NEG] = function(self) return -self:_ReadInt(4) end,
    [LibSerializeInt._ReaderIndex.NUM_64_POS] = function(self) return self:_ReadInt(7) end,
    [LibSerializeInt._ReaderIndex.NUM_64_NEG] = function(self) return -self:_ReadInt(7) end,
    [LibSerializeInt._ReaderIndex.NUM_FLOAT]  = function(self) return StringToFloat(self._readBytes(self._reader, 8)) end,
    [LibSerializeInt._ReaderIndex.NUM_FLOATSTR_POS]  = function(self) return tonumber(self._readBytes(self._reader, self:_ReadByte())) end,
    [LibSerializeInt._ReaderIndex.NUM_FLOATSTR_NEG]  = function(self) return -tonumber(self._readBytes(self._reader, self:_ReadByte())) end,

    -- Booleans
    [LibSerializeInt._ReaderIndex.BOOL_T] = function(self) return true end,
    [LibSerializeInt._ReaderIndex.BOOL_F] = function(self) return false end,

    -- Strings (encoded as size + buffer)
    [LibSerializeInt._ReaderIndex.STR_8]  = function(self) return self:_ReadString(self:_ReadByte()) end,
    [LibSerializeInt._ReaderIndex.STR_16] = function(self) return self:_ReadString(self:_ReadInt(2)) end,
    [LibSerializeInt._ReaderIndex.STR_24] = function(self) return self:_ReadString(self:_ReadInt(3)) end,

    -- Tables (encoded as count + key/value pairs)
    [LibSerializeInt._ReaderIndex.TABLE_8]  = function(self) return self:_ReadTable(self:_ReadByte()) end,
    [LibSerializeInt._ReaderIndex.TABLE_16] = function(self) return self:_ReadTable(self:_ReadInt(2)) end,
    [LibSerializeInt._ReaderIndex.TABLE_24] = function(self) return self:_ReadTable(self:_ReadInt(3)) end,

    -- Arrays (encoded as count + values)
    [LibSerializeInt._ReaderIndex.ARRAY_8]  = function(self) return self:_ReadArray(self:_ReadByte()) end,
    [LibSerializeInt._ReaderIndex.ARRAY_16] = function(self) return self:_ReadArray(self:_ReadInt(2)) end,
    [LibSerializeInt._ReaderIndex.ARRAY_24] = function(self) return self:_ReadArray(self:_ReadInt(3)) end,

    -- Mixed arrays/maps (encoded as arrayCount + mapCount + arrayValues + key/value pairs)
    [LibSerializeInt._ReaderIndex.MIXED_8]  = function(self) return self:_ReadMixed(self:_ReadPair(self._ReadByte)) end,
    [LibSerializeInt._ReaderIndex.MIXED_16] = function(self) return self:_ReadMixed(self:_ReadPair(self._ReadInt, 2)) end,
    [LibSerializeInt._ReaderIndex.MIXED_24] = function(self) return self:_ReadMixed(self:_ReadPair(self._ReadInt, 3)) end,

    -- Previously referenced strings
    [LibSerializeInt._ReaderIndex.STRINGREF_8]  = function(self) return self._stringRefs[self:_ReadByte()] end,
    [LibSerializeInt._ReaderIndex.STRINGREF_16] = function(self) return self._stringRefs[self:_ReadInt(2)] end,
    [LibSerializeInt._ReaderIndex.STRINGREF_24] = function(self) return self._stringRefs[self:_ReadInt(3)] end,

    -- Previously referenced tables
    [LibSerializeInt._ReaderIndex.TABLEREF_8]  = function(self) return self._tableRefs[self:_ReadByte()] end,
    [LibSerializeInt._ReaderIndex.TABLEREF_16] = function(self) return self._tableRefs[self:_ReadInt(2)] end,
    [LibSerializeInt._ReaderIndex.TABLEREF_24] = function(self) return self._tableRefs[self:_ReadInt(3)] end,
}


--[[---------------------------------------------------------------------------
    Write (serialization) support.
--]]---------------------------------------------------------------------------

-- Returns the appropriate function from the writer table for the object's type.
-- If the object's type isn't supported and opts.errorOnUnserializableType is true,
-- then an error will be raised.
function LibSerializeInt:_GetWriteFn(obj)
    local typ = type(obj)
    local writeFn = self._WriterTable[typ]
    if not writeFn and self._opts.errorOnUnserializableType then
        error(("Unhandled type: %s"):format(typ))
    end

    return writeFn
end

-- Returns true if all of the variadic arguments are serializable.
-- Note that _GetWriteFn will raise a Lua error if it finds an
-- unserializable type, unless this behavior is suppressed via options.
function LibSerializeInt:_CanSerialize(...)
    for i = 1, select("#", ...) do
        local obj = select(i, ...)
        local writeFn = self:_GetWriteFn(obj)
        if not writeFn then
            return false
        end
    end

    return true
end

-- Returns true if the table's key/value pair should be serialized.
-- Both filter functions (if present) must return true, and the
-- key/value types must be serializable. Note that _CanSerialize
-- will raise a Lua error if it finds an unserializable type, unless
-- this behavior is suppressed via options.
function LibSerializeInt:_ShouldSerialize(t, k, v, filterFn)
    return (not self._opts.filter or self._opts.filter(t, k, v)) and
           (not filterFn or filterFn(t, k, v)) and
           self:_CanSerialize(k, v)
end

-- Note that _GetWriteFn will raise a Lua error if it finds an
-- unserializable type, unless this behavior is suppressed via options.
function LibSerializeInt:_WriteObject(obj)
    local writeFn = self:_GetWriteFn(obj)
    if not writeFn then
        return false
    end

    writeFn(self, obj)
    return true
end

function LibSerializeInt:_WriteByte(value)
    self:_WriteInt(value, 1)
end

function LibSerializeInt:_WriteInt(n, threshold)
    self._writeString(self._writer, IntToString(n, threshold))
end

-- Lookup tables to map the number of required bytes to the
-- appropriate reader table index.
local numberIndices = {
    [2] = LibSerializeInt._ReaderIndex.NUM_16_POS,
    [3] = LibSerializeInt._ReaderIndex.NUM_24_POS,
    [4] = LibSerializeInt._ReaderIndex.NUM_32_POS,
    [7] = LibSerializeInt._ReaderIndex.NUM_64_POS,
}
local stringIndices = {
    [1] = LibSerializeInt._ReaderIndex.STR_8,
    [2] = LibSerializeInt._ReaderIndex.STR_16,
    [3] = LibSerializeInt._ReaderIndex.STR_24,
}
local tableIndices = {
    [1] = LibSerializeInt._ReaderIndex.TABLE_8,
    [2] = LibSerializeInt._ReaderIndex.TABLE_16,
    [3] = LibSerializeInt._ReaderIndex.TABLE_24,
}
local arrayIndices = {
    [1] = LibSerializeInt._ReaderIndex.ARRAY_8,
    [2] = LibSerializeInt._ReaderIndex.ARRAY_16,
    [3] = LibSerializeInt._ReaderIndex.ARRAY_24,
}
local mixedIndices = {
    [1] = LibSerializeInt._ReaderIndex.MIXED_8,
    [2] = LibSerializeInt._ReaderIndex.MIXED_16,
    [3] = LibSerializeInt._ReaderIndex.MIXED_24,
}
local stringRefIndices = {
    [1] = LibSerializeInt._ReaderIndex.STRINGREF_8,
    [2] = LibSerializeInt._ReaderIndex.STRINGREF_16,
    [3] = LibSerializeInt._ReaderIndex.STRINGREF_24,
}
local tableRefIndices = {
    [1] = LibSerializeInt._ReaderIndex.TABLEREF_8,
    [2] = LibSerializeInt._ReaderIndex.TABLEREF_16,
    [3] = LibSerializeInt._ReaderIndex.TABLEREF_24,
}

LibSerializeInt._WriterTable = {
    ["nil"] = function(self)
        -- DebugPrint("Serializing nil")
        self:_WriteByte(readerIndexShift * self._ReaderIndex.NIL)
    end,
    ["number"] = function(self, num)
        if IsFloatingPoint(num) then
            -- DebugPrint("Serializing float:", num)
            -- Normally a float takes 8 bytes. See if it's cheaper to encode as a string.
            -- If we encode as a string, though, we'll need a byte for its length.
            --
            -- Note that we only string encode finite values due to potential differences
            -- in encode/decode behaviour with such representations in some
            -- environments.
            local sign = 0
            local numAbs = num
            if num < 0 then
                sign = readerIndexShift
                numAbs = -num
            end
            local asString = tostring(numAbs)
            if #asString < 7 and tonumber(asString) == numAbs and IsFinite(numAbs) then
                self:_WriteByte(sign + readerIndexShift * self._ReaderIndex.NUM_FLOATSTR_POS)
                self:_WriteByte(#asString, 1)
                self._writeString(self._writer, asString)
            else
                self:_WriteByte(readerIndexShift * self._ReaderIndex.NUM_FLOAT)
                self._writeString(self._writer, FloatToString(num))
            end
        elseif num > -4096 and num < 4096 then
            -- The type byte supports two modes by which a number can be embedded:
            -- A 1-byte mode for 7-bit numbers, and a 2-byte mode for 12-bit numbers.
            if num >= 0 and num < 128 then
                -- DebugPrint("Serializing embedded number (1byte):", num)
                self:_WriteByte(num * 2 + 1)
            else
                -- DebugPrint("Serializing embedded number (2bytes):", num)
                local sign = 0
                if num < 0 then
                    sign = 8
                    num = -num
                end
                num = num * 16 + sign + 4
                local upper, lower = math_floor(num / 256), num % 256
                self:_WriteByte(lower)
                self:_WriteByte(upper)
            end
        else
            -- DebugPrint("Serializing number:", num)
            local sign = 0
            if num < 0 then
                num = -num
                sign = readerIndexShift
            end
            local required = GetRequiredBytesNumber(num)
            self:_WriteByte(sign + readerIndexShift * numberIndices[required])
            self:_WriteInt(num, required)
        end
    end,
    ["boolean"] = function(self, bool)
        -- DebugPrint("Serializing bool:", bool)
        self:_WriteByte(readerIndexShift * (bool and self._ReaderIndex.BOOL_T or self._ReaderIndex.BOOL_F))
    end,
    ["string"] = function(self, str)
        local ref = self._stringRefs[str]
        if ref then
            -- DebugPrint("Serializing string ref:", str)
            local required = GetRequiredBytes(ref)
            self:_WriteByte(readerIndexShift * stringRefIndices[required])
            self:_WriteInt(self._stringRefs[str], required)
        else
            local len = #str
            if len < 16 then
                -- Short lengths can be embedded directly into the type byte.
                -- DebugPrint("Serializing string, embedded count:", str, len)
                self:_WriteByte(embeddedCountShift * len + embeddedIndexShift * self._EmbeddedIndex.STRING + 2)
            else
                -- DebugPrint("Serializing string:", str, len)
                local required = GetRequiredBytes(len)
                self:_WriteByte(readerIndexShift * stringIndices[required])
                self:_WriteInt(len, required)
            end

            self._writeString(self._writer, str)
            if len > 2 then
                self:_AddReference(self._stringRefs, str)
            end
        end
    end,
    ["table"] = function(self, tab)
        local ref = self._tableRefs[tab]
        if ref then
            -- DebugPrint("Serializing table ref:", tab)
            local required = GetRequiredBytes(ref)
            self:_WriteByte(readerIndexShift * tableRefIndices[required])
            self:_WriteInt(self._tableRefs[tab], required)
        else
            -- Add a reference before trying to serialize the table's contents,
            -- so that if the table recursively references itself, we can still
            -- properly serialize it.
            self:_AddReference(self._tableRefs, tab)

            local filter
            local mt = getmetatable(tab)
            if mt and type(mt) == "table" and mt.__LibSerialize then
                filter = mt.__LibSerialize.filter
            end

            -- First determine the "proper" length of the array portion of the table,
            -- which terminates at its first nil value. Note that some values in this
            -- range may not be serializable, which is fine - we'll handle them later.
            -- It's better to maximize the number of values that can be serialized
            -- without needing to also serialize their keys.
            local arrayCount, serializableArrayCount = 0, 0
            local entireArraySerializable = true
            local totalArraySerializable = 0
            for i, v in ipairs(tab) do
                arrayCount = i
                if self:_ShouldSerialize(tab, i, v, filter) then
                    totalArraySerializable = totalArraySerializable + 1
                    if entireArraySerializable then
                        serializableArrayCount = i
                    end
                else
                    entireArraySerializable = false
                end
            end

            -- Consider the array portion as a series of zero or more serializable
            -- entries followed by zero or more entries that may or may not be
            -- serializable. For the latter portion, we can either write them in
            -- the array portion, padding the unserializable entries with nils,
            -- or just write them as key/value pairs in the map portion. We'll choose
            -- the former if there are more serializable entries in this portion than
            -- unserializable, or the latter if more are unserializable.
            if arrayCount - totalArraySerializable > totalArraySerializable - serializableArrayCount then
                arrayCount = serializableArrayCount
                entireArraySerializable = true
            end

            -- Next determine the count of all entries in the table whose keys are not
            -- included in the array portion, only counting keys that are serializable.
            local mapCount = 0
            local entireMapSerializable = true
            for k, v in pairs(tab) do
                if not IsArrayKey(k, arrayCount) then
                    if self:_ShouldSerialize(tab, k, v, filter) then
                        mapCount = mapCount + 1
                    else
                        entireMapSerializable = false
                    end
                end
            end

            if mapCount == 0 then
                -- The table is an array. We can avoid writing the keys.
                if arrayCount < 16 then
                    -- Short counts can be embedded directly into the type byte.
                    -- DebugPrint("Serializing array, embedded count:", arrayCount)
                    self:_WriteByte(embeddedCountShift * arrayCount + embeddedIndexShift * self._EmbeddedIndex.ARRAY + 2)
                else
                    -- DebugPrint("Serializing array:", arrayCount)
                    local required = GetRequiredBytes(arrayCount)
                    self:_WriteByte(readerIndexShift * arrayIndices[required])
                    self:_WriteInt(arrayCount, required)
                end

                for i = 1, arrayCount do
                    local v = tab[i]
                    if entireArraySerializable or self:_ShouldSerialize(tab, i, v, filter) then
                        self:_WriteObject(v)
                    else
                        -- Since the keys are being omitted, write a `nil` entry
                        -- for any values that shouldn't be serialized.
                        self:_WriteObject(nil)
                    end
                end
            elseif arrayCount ~= 0 then
                -- The table has both array and dictionary keys. We can still save space
                -- by writing the array values first without keys.

                if mapCount < 5 and arrayCount < 5 then
                    -- Short counts can be embedded directly into the type byte.
                    -- They have to be really short though, since we have two counts.
                    -- Since neither can be zero (this is a mixed table),
                    -- we can get away with not being able to represent 0.
                    -- DebugPrint("Serializing mixed array-table, embedded counts:", arrayCount, mapCount)
                    local combined = (mapCount - 1) * 4 + arrayCount - 1
                    self:_WriteByte(embeddedCountShift * combined + embeddedIndexShift * self._EmbeddedIndex.MIXED + 2)
                else
                    -- Use the max required bytes for the two counts.
                    -- DebugPrint("Serializing mixed array-table:", arrayCount, mapCount)
                    local required = math_max(GetRequiredBytes(mapCount), GetRequiredBytes(arrayCount))
                    self:_WriteByte(readerIndexShift * mixedIndices[required])
                    self:_WriteInt(arrayCount, required)
                    self:_WriteInt(mapCount, required)
                end

                for i = 1, arrayCount do
                    local v = tab[i]
                    if entireArraySerializable or self:_ShouldSerialize(tab, i, v, filter) then
                        self:_WriteObject(v)
                    else
                        -- Since the keys are being omitted, write a `nil` entry
                        -- for any values that shouldn't be serialized.
                        self:_WriteObject(nil)
                    end
                end

                local mapCountWritten = 0
                if self._opts.stable then
                    -- In order to ensure that the output is stable, we sort the map keys and write
                    -- them in the sorted order.
                    local mapKeys = {}
                    for k, v in pairs(tab) do
                        -- Exclude keys that have already been written via the previous loop.
                        if not IsArrayKey(k, arrayCount) and (entireMapSerializable or self:_ShouldSerialize(tab, k, v, filter)) then
                            table_insert(mapKeys, k)
                        end
                    end
                    table_sort(mapKeys, StableKeySort)
                    for _, k in ipairs(mapKeys) do
                        self:_WriteObject(k)
                        self:_WriteObject(tab[k])
                        mapCountWritten = mapCountWritten + 1
                    end
                else
                    for k, v in pairs(tab) do
                        -- Exclude keys that have already been written via the previous loop.
                        if not IsArrayKey(k, arrayCount) and (entireMapSerializable or self:_ShouldSerialize(tab, k, v, filter)) then
                            self:_WriteObject(k)
                            self:_WriteObject(v)
                            mapCountWritten = mapCountWritten + 1
                        end
                    end
                end
                assert(mapCount == mapCountWritten)
            else
                -- The table has only dictionary keys, so we'll write them all.
                if mapCount < 16 then
                    -- Short counts can be embedded directly into the type byte.
                    -- DebugPrint("Serializing table, embedded count:", mapCount)
                    self:_WriteByte(embeddedCountShift * mapCount + embeddedIndexShift * self._EmbeddedIndex.TABLE + 2)
                else
                    -- DebugPrint("Serializing table:", mapCount)
                    local required = GetRequiredBytes(mapCount)
                    self:_WriteByte(readerIndexShift * tableIndices[required])
                    self:_WriteInt(mapCount, required)
                end

                if self._opts.stable then
                    -- In order to ensure that the output is stable, we sort the map keys and write
                    -- them in the sorted order.
                    local mapKeys = {}
                    for k, v in pairs(tab) do
                        if entireMapSerializable or self:_ShouldSerialize(tab, k, v, filter) then
                            table_insert(mapKeys, k)
                        end
                    end
                    table_sort(mapKeys, StableKeySort)
                    for _, k in ipairs(mapKeys) do
                        self:_WriteObject(k)
                        self:_WriteObject(tab[k])
                    end
                else
                    for k, v in pairs(tab) do
                        if entireMapSerializable or self:_ShouldSerialize(tab, k, v, filter) then
                            self:_WriteObject(k)
                            self:_WriteObject(v)
                        end
                    end
                end
            end
        end
    end,
}


--[[---------------------------------------------------------------------------
    API support.
--]]---------------------------------------------------------------------------

local serializeTester = CreateSerializer(canSerializeFnOptions)

function LibSerialize:IsSerializableType(...)
    return serializeTester:_CanSerialize(canSerializeFnOptions, ...)
end

function LibSerialize:SerializeEx(opts, ...)
    opts = opts or defaultSerializeOptions

    if opts.async then
        local ser = CreateSerializer(opts, ...)
        local thread = coroutine_create(Serialize)
        local inputSize = select("#", ...)
        local input = {...}

        -- return coroutine handler
        return function()
            return CheckSerializationProgress(thread, coroutine_resume(thread, ser))
        end
    else
        return Serialize(CreateSerializer(opts), ...)
    end
end

function LibSerialize:Serialize(...)
    return self:SerializeEx(defaultSerializeOptions, ...)
end

function LibSerialize:SerializeAsync(...)
    return self:SerializeEx(defaultAsyncOptions, ...)
end

function LibSerialize:SerializeAsyncEx(opts, ...)
    opts = opts or defaultAsyncOptions
    opts.async = true
    return self:SerializeEx(opts, ...)
end

function LibSerialize:DeserializeValue(input, opts)
    opts = opts or defaultDeserializeOptions
    local deser = CreateDeserializer(input, opts)

    if opts.async then
        local thread = coroutine_create(Deserialize)
        return function()
            return CheckDeserializationProgress(thread, coroutine_resume(thread, deser))
        end
    else
        return Deserialize(deser)
    end
end

function LibSerialize:Deserialize(input)
    return pcall(self.DeserializeValue, self, input)
end

function LibSerialize:DeserializeAsync(input, opts)
    opts = opts or defaultAsyncOptions
    opts.async = true
    return self:DeserializeValue(input, opts)
end

return LibSerialize
