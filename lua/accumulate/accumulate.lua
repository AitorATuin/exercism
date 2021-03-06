local function accumulate(xs, f)
  local ys = {}
  for i, v in ipairs(xs) do
    ys[i] = f(v)
  end
  return ys
end

return accumulate
