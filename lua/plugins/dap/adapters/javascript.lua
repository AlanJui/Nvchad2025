local dap = require "dap"

-- setup adapter
require("dap-vscode-js").setup {
  debugger_path = vim.fn.stdpath "data" .. "/lazy/vscode-js-debug",
  -- debugger_cmd = { "js-debug-adapter" },
  adapters = { "pwa-node", "pwa-chrome", "pwa-msedge", "node-terminal", "pwa-extensionHost" },
  -- log_file_path = os.getenv("HOME") .. "/.cache/dap_vscode_js.log", -- Path for file logging
  -- log_file_level = true, -- Logging level for output to file. Set to false to disable file logging.
  -- log_console_level = vim.log.levels.ERROR, -- Logging level for output to console. Set to false to disable console output.
}

for _, language in ipairs { "typescript", "javascript" } do
  dap.configurations[language] = {
    -- Node.js
    {
      -- use nvim-dap-vscode-js's pwa-node debug adapter
      type = "pwa-node",
      -- launch a new process to attach the debugger to
      request = "launch",
      -- name of the debug action you have to select for this config
      name = "Launch file in new node process",
      -- launch current file
      program = "${file}",
      cwd = "${workspaceFolder}",
    },
    {
      type = "pwa-node",
      request = "attach",
      name = "Attach",
      processId = require("dap.utils").pick_process,
      cwd = "${workspaceFolder}",
    },
    -- attach to a node process that has been started with
    -- `--inspect` for longrunning tasks or `--inspect-brk` for short tasks
    -- npm script -> `node --inspect-brk ./node_modules/.bin/vite dev`
    {
      -- use nvim-dap-vscode-js's pwa-node debug adapter
      type = "pwa-node",
      -- attach to an already running node process with --inspect flag
      -- default port: 9222
      request = "attach",
      -- allows us to pick the process using a picker
      processId = require("dap.utils").pick_process,
      -- name of the debug action you have to select for this config
      name = "Attach debugger to existing `node --inspect` process",
      -- for compiled languages like TypeScript or Svelte.js
      sourceMaps = true,
      -- resolve source maps in nested locations while ignoring node_modules
      resolveSourceMapLocations = {
        "${workspaceFolder}/**",
        "!**/node_modules/**",
      },
      -- path to src in vite based projects (and most other projects as well)
      cwd = "${workspaceFolder}/src",
      -- we don't want to debug code inside node_modules, so skip it!
      skipFiles = { "${workspaceFolder}/node_modules/**/*.js" },
    },
    -- Jest
    {
      type = "pwa-node",
      request = "launch",
      name = "Debug Jest Tests",
      -- trace = true, -- include debugger info
      runtimeExecutable = "node",
      runtimeArgs = {
        "./node_modules/jest/bin/jest.js",
        "--runInBand",
      },
      rootPath = "${workspaceFolder}",
      cwd = "${workspaceFolder}",
      console = "integratedTerminal",
      internalConsoleOptions = "neverOpen",
    },
    -- Mocha
    {
      type = "pwa-node",
      request = "launch",
      name = "Debug Mocha Tests",
      -- trace = true, -- include debugger info
      runtimeExecutable = "node",
      runtimeArgs = {
        "./node_modules/mocha/bin/mocha.js",
      },
      rootPath = "${workspaceFolder}",
      cwd = "${workspaceFolder}",
      console = "integratedTerminal",
      internalConsoleOptions = "neverOpen",
    },
  }
end
