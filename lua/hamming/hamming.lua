local Compute = {}

-- A simple recursive version, much nicer than the iterative one :)
local function compute_rec(xs, ys, i, distance)
  -- Strings are immutable in lua so indexing a string should be cheap
  local xs_v = xs:byte(i)
  local ys_v = ys:byte(i)
  if not xs_v or not ys_v then
    return distance
  end
  return compute_rec(xs, ys, i+1, (xs_v == ys_v and distance) or distance+1)
end

Compute.compute = function (xs, ys)
  return compute_rec(xs, ys, 1, 0)
end
return Compute
