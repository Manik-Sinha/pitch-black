--messenger.lua
--Messenger class: useful for posting messages.

local Messenger = {}
function Messenger.new(cap)
  local self = {}
  local capacity = math.max(1, cap)
  local messages = {}
  local first = 1
  local last = capacity
  local index = 1
  for i = 1, capacity do
    messages[i] = ""
  end
  function self.tostring()
    local string = ""
    local last_index = last
    if index <= capacity then last_index = index - 1 end
    for i = first, last_index do
      if i ~= last_index then
        string = string .. messages[i] .. "\n"
      else
        string = string .. messages[i]
      end
    end
    return string
  end
  function self.print()
    print(self.tostring())
  end
  function self.reset()
    messages = {}
    first = 1
    last = capacity
    index = 1
  end
  function self.post(message)
    if last < 0 then self.reset() end
    if index > capacity then
      messages[first] = nil
      first = first + 1
      last = last + 1
      messages[last] = message
    else
      messages[index] = message
      index = index + 1
    end
  end
  return self
end
return Messenger
