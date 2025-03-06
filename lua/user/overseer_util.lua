local M = {}

local task_history = {}
local tasks = {}

function M.register_task(task)
  tasks[task.id] = task
  table.insert(task_history, task.id)
end

function M.get_last_task()
  return tasks[task_history[#task_history]]
end

function M.restart_last_task()
  local task = M.get_last_task()
  if task then
    require("overseer").run_action(task, "restart")
  end
end

function M.unregister_task(task_id)
  tasks[task_id] = nil
  if task_history[#task_history] == task_id then
    task_history[#task_history] = nil
  end
end

return M
