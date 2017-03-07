#!/bin/lua

-- 128 64 32 16 8  4  2 1
--   L  H K2 K1 C P2 P1 D
local DOG  = 1 
local PUPPY1 = 2
local PUPPY2 = 4
local CAT  = 8
local KITTEN1 = 16
local KITTEN2 = 32
local TRAINER  = 64
local LION  = 128
local ALL_TOGETHER = bit32.bor(DOG, PUPPY1, PUPPY2,  CAT, TRAINER, LION, KITTEN1, KITTEN2)
local ALL_PASSENGERS = {
  DOG, PUPPY1, PUPPY2, CAT, KITTEN1, KITTEN2, TRAINER, LION,
}
local PASSENGERS_AS_CHAR = {
  [DOG] = "d",
  [PUPPY1] = "p",
  [PUPPY2] = "p",
  [CAT] = "c",
  [KITTEN1] = "k",
  [KITTEN2] = "k",
  [TRAINER] = "t",
  [LION] = "l"
}

local LEFT = -1
local RIGHT = 1

local function has_passenger(passenger)
  return function(value)
    return bit32.band(value, passenger) ~= 0
  end
end

local has_cat = has_passenger(CAT) 
local has_dog = has_passenger(DOG) 
local has_puppy1 = has_passenger(PUPPY1) 
local has_puppy2 = has_passenger(PUPPY2) 
local has_puppy = function(value)
  return has_puppy1(value) or has_puppy2(value)
end
local has_puppies = function(value)
  return has_puppy1(value) and has_puppy2(value)
end
local has_kitten1 = has_passenger(KITTEN1) 
local has_kitten2 = has_passenger(KITTEN2)
local has_kitten = function(value)
  return has_kitten1(value) or has_kitten2(value)
end
local has_kittens = function(value)
  return has_kitten1(value) and has_kitten2(value)
end
local has_trainer = has_passenger(TRAINER) 
local has_lion = has_passenger(LION) 

-- puppies must be with the dog when around the cat
local function rule1(value)
  if has_cat(value) and has_puppy(value) then
    return has_dog(value)
  end
  return true
end

-- The kittens must be with the cat when around the dog
local function rule2(value)
  if has_dog(value) and has_kitten(value) then
    return has_cat(value)
  end
  return true
end

-- No one except the trainer can be alone with the lion
local function rule3(value)
  if has_lion(value) and value ~= LION then
    return has_trainer(value)
  end
  return true
end

-- puppies cannot cross the river without the dog or the trainer
local function rule4(value, passengers)
  if has_puppy(passengers) then
    return has_dog(passengers) or has_trainer(passengers)
  end
  return true
end

-- kittens cannot cross the river without the cat or the trainer
local function rule5(value, passengers)
  if has_kitten(passengers) then
    return has_cat(passengers) or has_trainer(passengers)
  end
  return true
end

-- The lion cannot cross the river without the trainer
local function rule6(value, passengers)
  if has_lion(passengers) then
    return has_trainer(passengers)
  end
  return true
end

-- the boat cannot cross the river without a dog, a cat or a trainer
local function rule7(value, passengers)
  return has_cat(passengers) or has_dog(passengers) or has_trainer(passengers)
end

local RULES = {rule1, rule2, rule3, rule4, rule5, rule6, rule7}


local State = {}
State.__index = State

function State:__eq(other)
  return self.leftSide == other.leftSide and
         self.rightSide == other.rightSide
end

function State:__tostring()
  local function side_to_string(side)
    local side_as_string = ""
    for _, p in ipairs(self.allPassengers) do
      local c = "_"
      if has_passenger(p)(side) then
        c = self.passengersAsChar[p]
      end
      side_as_string = string.format("%s%s", side_as_string, c)
    end
    return side_as_string
  end
  return string.format("%s | %s", side_to_string(self.leftSide), 
                                  side_to_string(self.rightSide))
end

function State.new(left, right)
  local function passengers_xs(passengers)
    local xs = {}
    for _, passenger in ipairs(ALL_PASSENGERS) do
      if has_passenger(passenger)(passengers) then
        xs[#xs+1] = passenger
      end
    end
    return xs
  end
  return setmetatable({
    rules = RULES,
    allPassengers = ALL_PASSENGERS,
    passengersAsChar = PASSENGERS_AS_CHAR,
    leftSide = left,
    leftPassengers = function () return passengers_xs(left) end,
    rightSide = right,
    rightPassengers = function () return passengers_xs(right) end,
  }, State)
end

local function move_passenger(passenger, passenger2)
  local function check_rules(value, passengers, rules)
    local ok = true
    for _, rule in ipairs(rules) do
      ok = ok and rule(value, passengers)
    end
    return ok
  end
  local passengers = bit32.bor(passenger, passenger2 or 0)
  return function(state, dir)
    local new_left_side = nil
    local new_right_side = nil
    if dir == RIGHT then
      new_left_side = bit32.bxor(state.leftSide, passengers) 
      new_right_side = bit32.bor(state.rightSide, passengers)
    else
      new_left_side = bit32.bor(state.leftSide, passengers)
      new_right_side = bit32.bxor(state.rightSide, passengers)
    end
    if check_rules(new_left_side, passengers, state.rules) and
       check_rules(new_right_side, passengers, state.rules) then
      return State.new(new_left_side, new_right_side)
    end
    return nil
  end
end

local function candidate_states(state, visited_states)
  local function _candidates(passengers, new_states, dir)
    local done_passengers = {}
    -- one passenger movement
    for _, passenger in ipairs(passengers) do
      local new_state = move_passenger(passenger)(state, dir)
      if new_state and not visited_states[tostring(new_state)] then
        new_states[#new_states+1] = new_state
      end
      -- two passengers movement
      for _, passenger2 in ipairs(passengers) do
        if passenger2 ~= passenger and 
           not done_passengers[passenger..","..passenger2] and
           not done_passengers[passenger2..","..passenger] then
          done_passengers[passenger..","..passenger2] = true
          local new_state = move_passenger(passenger, passenger2)(state, dir)
          if new_state and not visited_states[tostring(new_state)] then
            new_states[#new_states+1] = new_state
          end
        end
      end
    end
  end
  local states = {}
  local left_passengers_candidates = state.leftPassengers()
  local right_passengers_candidates = state.rightPassengers()
  _candidates(left_passengers_candidates, states, RIGHT)
  _candidates(right_passengers_candidates, states, LEFT)
  return states
end

local finalState = State.new(0, ALL_TOGETHER, RIGHT)
local function cross_river(next_states, current_state, current_states, n, max_n)
  print(string.format("%s%s", string.rep("  ", n), current_state))
  if current_state == finalState  then
    return true, current_states
  end
  if n == max_n then
    return false, nil
  end
  for _, new_state in ipairs(next_states) do
    current_states[tostring(new_state)] = true
    current_states[#current_states+1] = new_state
    local ok, solution = cross_river(candidate_states(new_state, current_states), new_state, current_states, n+1, max_n)
    if ok then
      return true, solution
    else
      current_states[tostring(new_state)] = nil
      current_states[#current_states] = nil
    end
  end
  return false
end

local function print_states(states)
  if #states == 0 then
    print("Weird!!!! no states!")
  else
    print(string.format("Solution with %s movements", #states-1))
    for _, state in ipairs(states) do
      print(state)
    end
  end
end

local initialState = State.new(ALL_TOGETHER, 0)
local visited_states = {
  initialState,
  [tostring(initialState)] = true
}
max_n = 9
print_states(candidate_states(initialState, visited_states))
local ok, solution = cross_river(candidate_states(initialState, visited_states),
                                 initialState, visited_states, 0, max_n)

if ok then
  print_states(solution)
else
  print(string.format("No solution for n = %s", max_n))
end

