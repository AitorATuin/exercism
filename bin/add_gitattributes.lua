#!/bin/lua
-- nnoremap <silent> <f6> :call REPLSend(['lua $HOME/exercism/bin/exercism_git.lua lua go'])<CR>

local GIT_ATTR_FILE = ".gitattributes"
local GIT_ATTR_REGEX = "([^/]+)/([^/]+)/([^/]+)%.(%w+) filter%=git%-crypt diff%=git%-crypt"

local function file_to_gitattribute(file)
  return string.format("%s/%s/%s.%s filter=git-crypt diff=git-crypt", file.lang,
                       file.exercise, file.filename, file.ext)
end

local function get_files_added()
  local files_added = {}
  local fd = io.open(GIT_ATTR_FILE, "r")
  -- We search for pattern:
  --  lang/exercise/exercise.lua filter=git-crypt diff=git-crypt
  for line in fd:lines() do
		line:gsub(GIT_ATTR_REGEX, function(lang, exercise, filename, ext)
			file = {
        lang = lang,
        exercise = exercise,
        filename = filename,
        ext = ext
      }
      files_added[file_to_gitattribute(file)] = true
		end)
  end
  fd:close()
  return files_added
end

local function get_files_in_exercise(lang, exercise)
  return function()
    local pipe = io.popen(string.format("ls %s/%s", lang, exercise))
    local files_to_add = {}
    for line in pipe:lines() do
      for filename, ext in line:gmatch("([^%.]+).(%w+)") do
        if exercise == filename then
          file = {
            lang = lang,
            exercise = exercise,
            filename = filename,
            ext = ext
          }
          coroutine.yield(file)
        end
      end
    end
    pipe:close()
  end
end

local function get_exercises(lang)
  return function()
    local exercises = {}
    local pipe = io.popen(string.format("ls %s", lang))
    for line in pipe:lines() do
      for exercise in line:gmatch("(%g+)") do
        coroutine.yield(exercise)
      end
    end
    pipe:close()
  end
end

local co_iter = function(co)
  local co = coroutine.create(co)
  return function()
    local code, value = coroutine.resume(co)
    return value
  end
end

local function main(...)
  local langs = arg
  if #langs == 0 then
    os.exit(1)
  end
  local files_added = get_files_added()
  for _, lang in ipairs(langs) do
    for exercise in co_iter(get_exercises(lang)) do
      for file in co_iter(get_files_in_exercise(lang, exercise)) do
        local file_gitattributed = file_to_gitattribute(file)
        if not files_added[file_gitattributed] then
          print(string.format("- Add: %s", file_gitattributed))
        end
      end
    end
  end
end

main(...)
