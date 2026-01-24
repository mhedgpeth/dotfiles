-- Test file for reproducing LSP diagnostics issue
-- This file has intentional errors for lua_ls to catch

-- ERROR 1: Undefined global variable
local x = undefined_variable

-- ERROR 2: Wrong type assignment
local num = "this should be a number"
local result = num + 5

-- ERROR 3: Missing parameter
local function greet(name)
	return "Hello, " .. name
end
greet() -- missing argument

-- ERROR 4: Unused variable
local unused = "this variable is never used"

-- To test:
-- 1. Open this file: nvim --clean -u minimal.lua test_lsp.lua
-- 2. Wait for lua_ls to load (check :LspInfo)
-- 3. Press <leader>aa to open CodeCompanion Actions
-- 4. Select "Explain LSP Diagnostics"
-- 5. Check if the chat shows the ACTUAL CODE or just diagnostic metadata
