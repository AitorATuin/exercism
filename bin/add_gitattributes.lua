#!/bin/lua

local GIT_ATTR_FILE = ".gitattributes"
--
--  lang/exercise/exercise.lua filter=git-crypt diff=git-crypt
local GIT_ATTR_REGEX = "([^/]+)/([^/]+)/([^/]+)%.(%w+) filter%=git%-crypt diff%=git%-crypt"

local function file_to_gitattribute(file)
  return string.format("%s/%s/%s.%s filter=git-crypt diff=git-crypt", file.lang,
                       file.exercise, file.filename, file.ext)
end

local function get_files_added()
  local files_added = {}
  local fd = io.open(GIT_ATTR_FILE, "r")
  -- We search for pattern:
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
          local file = {
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

local function stage_gitattributes(run_dry, commit_msg)
  local f = os.execute
  if run_dry then
    f = print
  end
  f("git add " .. GIT_ATTR_FILE)
  f("git commit -m \"Add gitattributes for:" .. commit_msg .. "\"")
end

local function add_to_gitattributes(fd, entry, run_dry)
  if not run_dry then
    fd:write(entry)
  end
end

local function main(...)
  local langs = arg
  if #langs == 0 then
    os.exit(1)
  end
  local RUN_DRY = os.getenv("RUN_DRY") ~= nil
  local files_added = get_files_added()
  local fd = io.open(GIT_ATTR_FILE, "a")
  local commit_msg = ""
  for _, lang in ipairs(langs) do
    for exercise in co_iter(get_exercises(lang)) do
      for file in co_iter(get_files_in_exercise(lang, exercise)) do
        local file_gitattributed = file_to_gitattribute(file)
        if not files_added[file_gitattributed] then
          print(string.format("- Add: %s", file_gitattributed))
          add_to_gitattributes(fd, file_gitattributed .. "\n", RUN_DRY)
          commit_msg = string.format("%s\n  - %s", commit_msg, file_gitattributed)
        end
      end
    end
  end
  fd:close()

  if #commit_msg > 0 then
    print("Stagging " .. GIT_ATTR_FILE .. " ...")
    stage_gitattributes(RUN_DRY, commit_msg)
  end
end

main(...)
