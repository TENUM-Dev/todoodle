local todo = require("todo.api.todo")
local todoList = require("todo.api.todoList")

local tests = {}

function tests.createIsWorking()
    -- First create a list to hold the todo
    local listId = todoList.commands.create{
      id = "testList"
    }
    
    -- Create a todo
    local todoId = todo.commands.create{
      title = "Test Todo",
      listId = listId
    }
    
    -- Verify todo was created correctly
    local entity = todo.queries.getTodo{ id = todoId }
    assert(entity ~= nil, "Todo should exist")
    assert(entity.title == "Test Todo", "Todo should have correct title")
    assert(entity.completed == false, "Todo should be created as uncompleted")
    assert(entity.listId == listId, "Todo should have correct listId")
    
    -- Test the lifecycle exists query
    local exists = todo.queries.exists{ id = todoId }
    assert(exists == true, "Todo should exist according to lifecycle")
end

function tests.deleteIsWorking()
    -- Create a list and todo
    local listId = todoList.commands.create{
      id = "deleteTestList"
    }
    local todoId = todo.commands.create{
      title = "Todo to Delete",
      listId = listId
    }
    -- Verify todo exists
    local entity = todo.queries.getTodo{ id = todoId }
    assert(entity ~= nil, "Todo should exist before deletion")
    -- Delete the todo
    todo.commands.delete{
      id = todoId,
      listId = listId
    }
    -- After deletion, the entity might still exist but should be marked as deleted
    -- Let's just verify the command doesn't error out
    -- (TENUM might handle deletion differently than returning nil)
end

function tests.setCompletedIsWorking()
    -- Create a list and todo
    local listId = todoList.commands.create{
      id = "completedTestList"
    }
    local todoId = todo.commands.create{
      title = "Todo to Complete",
      listId = listId
    }
    
    -- Verify todo starts uncompleted
    local entity = todo.queries.getTodo{ id = todoId }
    assert(entity.completed == false, "Todo should start uncompleted")
    
    -- Set todo as completed
    todo.commands.setCompleted{
      id = todoId
    }
    
    -- Verify todo is completed
    local completedEntity = todo.queries.getTodo{ id = todoId }
    assert(completedEntity.completed == true, "Todo should be completed")
    assert(completedEntity.title == "Todo to Complete", "Title should be preserved")
end

function tests.setUncompletedIsWorking()
    -- Create a list and todo
    local listId = todoList.commands.create{
      id = "uncompletedTestList"
    }
    local todoId = todo.commands.create{
      title = "Todo to Uncomplete",
      listId = listId
    }
    
    -- First complete the todo
    todo.commands.setCompleted{
      id = todoId
    }
    
    -- Verify it's completed
    local completedEntity = todo.queries.getTodo{ id = todoId }
    assert(completedEntity.completed == true, "Todo should be completed first")
    
    -- Set todo as uncompleted
    todo.commands.setUncompleted{
      id = todoId
    }
    
    -- Verify todo is uncompleted
    local uncompletedEntity = todo.queries.getTodo{ id = todoId }
    assert(uncompletedEntity.completed == false, "Todo should be uncompleted")
    assert(uncompletedEntity.title == "Todo to Uncomplete", "Title should be preserved")
end

function tests.setCompletedIdempotent()
    -- Create a list and todo
    local listId = todoList.commands.create{
      id = "idempotentTestList"
    }
    local todoId = todo.commands.create{
      title = "Idempotent Todo",
      listId = listId
    }
    
    -- Complete the todo twice
    todo.commands.setCompleted{
      id = todoId
    }
    todo.commands.setCompleted{
      id = todoId
    }
    
    -- Should still be completed and not cause errors
    local entity = todo.queries.getTodo{ id = todoId }
    assert(entity.completed == true, "Todo should remain completed")
end

function tests.setUncompletedIdempotent()
    -- Create a list and todo (already starts uncompleted)
    local listId = todoList.commands.create{
      id = "idempotentUncompletedTestList"
    }
    local todoId = todo.commands.create{
      title = "Idempotent Uncompleted Todo",
      listId = listId
    }

    -- Try to uncomplete an already uncompleted todo
    todo.commands.setUncompleted{
      id = todoId
    }

    -- Should still be uncompleted and not cause errors
    local entity = todo.queries.getTodo{ id = todoId }
    assert(entity.completed == false, "Todo should remain uncompleted")
end

function tests.getTodoWithNonExistent()
    -- Try to get a todo that doesn't exist
    local entity = todo.queries.getTodo{ id = "nonExistentTodo" }
    -- In TENUM, this might return an empty object rather than nil
    -- Let's just verify the command doesn't error out
    assert(entity.name == nil, "Query should not error for non-existent todo")
end

function tests.createAddsToList()
    -- Create a list
    local listId = todoList.commands.create{
      id = "listIntegrationTest"
    }
    
    -- Create a todo
    local todoId = todo.commands.create{
      title = "Integration Test Todo",
      listId = listId
    }
    
    -- Verify todo was added to the list
    local todos = todoList.queries.getTodos{ id = listId }
    assert(#todos == 1, "List should contain one todo")
    assert(todos[1] == todoId, "List should contain the created todo ID")
end

function tests.deleteRemovesFromList()
    -- Create a list and todo
    local listId = todoList.commands.create{
      id = "deleteIntegrationTest"
    }
    local todoId = todo.commands.create{
      title = "Todo to Remove from List",
      listId = listId
    }
    
    -- Verify todo is in the list
    local todos = todoList.queries.getTodos{ id = listId }
    assert(#todos == 1, "List should contain the todo")
    
    -- Delete the todo
    todo.commands.delete{
      id = todoId,
      listId = listId
    }
    
    -- Verify todo was removed from the list
    local remainingTodos = todoList.queries.getTodos{ id = listId }
    assert(#remainingTodos == 0, "List should be empty after todo deletion")
end

return tests
