local hello_world = {}

function hello_world.hello (name)
  local greet = "Hello,"
  if name == nil then
    greet = string.format("%s world!", greet) 
  else
    greet = string.format("%s %s!", greet, name)
  end
  return greet
end

return hello_world
