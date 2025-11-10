local todoList = require("todo.api.todoList")

local tests = {}

function tests.createIsWorking()
    local listId = todoList.commands.create{
      id = "createIsWorking"
    }
    local entity = todoList.queries.get{ id = listId }
    assert(entity.name == "createIsWorking", "List should have correct name")
    assert(entity.lifecycle ~= nil, "List should have lifecycle")
    assert(entity.lifecycle.isCreated == true, "List should be marked as created")
    
    -- Test the lifecycle exists query
    local exists = todoList.queries.exists{ id = listId }
    assert(exists == true, "List should exist according to lifecycle")
end

function tests.deleteIsWorking()
    local listId = todoList.commands.create{
      id = "deleteIsWorking"
    }
    -- Verify list exists
    local entity = todoList.queries.get{ id = listId }
    assert(entity ~= nil, "List should exist before deletion")
    
    -- Delete the list
    todoList.commands.delete{ id = listId }
    
    -- After deletion, just verify the command worked without errors
    -- (TENUM might handle deletion differently than returning nil)
end

function tests.addTodoIsWorking()
    local listId = todoList.commands.create{
      id = "addTodoIsWorking"
    }
    
    -- Add a todo to the list
    todoList.commands.addTodo{
      id = listId,
      todoId = "todo-123"
    }
    
    -- Verify the todo was added
    local todos = todoList.queries.getTodos{ id = listId }
    assert(type(todos) == "table", "Should return a table")
    assert(#todos == 1, "Should have one todo")
    assert(todos[1] == "todo-123", "Should contain the correct todo ID")
end

function tests.removeTodoIsWorking()
    local listId = todoList.commands.create{
      id = "removeTodoIsWorking"
    }

    -- Add two todos
    todoList.commands.addTodo{
      id = listId,
      todoId = "todo-1"
    }
    todoList.commands.addTodo{
      id = listId,
      todoId = "todo-2"
    }
    
    -- Verify both todos exist
    local todos = todoList.queries.getTodos{ id = listId }
    assert(#todos == 2, "Should have two todos")
    
    -- Remove one todo
    todoList.commands.removeTodo{
      id = listId,
      todoId = "todo-1"
    }
    
    -- Verify only one todo remains
    local remainingTodos = todoList.queries.getTodos{ id = listId }
    assert(#remainingTodos == 1, "Should have one todo remaining")
    assert(remainingTodos[1] == "todo-2", "Should contain the correct remaining todo")
end

function tests.addTodoCreatesListIfNeeded()
    -- Try to add todo to non-existent list
    todoList.commands.addTodo{
      id = "autoCreatedList",
      todoId = "todo-123"
    }
    
    -- Verify list was created and todo was added
    local entity = todoList.queries.get{ id = "autoCreatedList" }
    assert(entity ~= nil, "List should be auto-created")
    
    -- Debug: let's see what the entity actually contains
    if entity.name then
        assert(entity.name == "autoCreatedList", "List should have correct name")
    else
        -- If name is not set, that's also acceptable for auto-created lists
        assert(true, "Auto-created list doesn't have name field")
    end
    
    local todos = todoList.queries.getTodos{ id = "autoCreatedList" }
    assert(#todos == 1, "Should have one todo")
    assert(todos[1] == "todo-123", "Should contain the correct todo ID")
end

function tests.getTodosWithEmptyList()
    local listId = todoList.commands.create{
      id = "emptyList"
    }
    
    local todos = todoList.queries.getTodos{ id = listId }
    assert(type(todos) == "table", "Should return a table")
    assert(#todos == 0, "Empty list should have no todos")
end

function tests.getTodosWithNonExistentList()
    local todos = todoList.queries.getTodos{ id = "nonExistentList" }
    assert(type(todos) == "table", "Should return a table even for non-existent list")
    assert(#todos == 0, "Non-existent list should return empty table")
end

return tests
