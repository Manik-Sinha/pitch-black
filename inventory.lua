--inventory.lua

return function()

  local self = {}
  local storage = {{}}
  local rows = #storage
  local cols = 4
  --grabbed_item is an extra space in the inventory for the item being held
  --by the mouse.
  local grabbed_item = nil

  --Put an item into slot x, y where x is the column, and y is the row.
  function self.put(x, y)
    grabbed_item, storage[y][x] = storage[y][x], grabbed_item
  end
  --Grab an item from slot x, y where x is the column, and y is the row.
  function self.grab(x, y)
    self.put(x, y)
  end
  --Store item into first free slot in storage. If none is found, then store
  --into grabbed_item. Otherwise we don't have any space, so we can't pick up
  --an item. Returns true if successfully picked up an item, false otherwise.
  function self.pickup(item)
    for r = 1, rows do
      for c = 1, cols do
        if storage[r][c] == nil then
          storage[r][c] = item
          return true
        end
      end
    end
    if grabbed_item == nil then
      grabbed_item = item
      return true
    end
    return false
  end

  return self
end
