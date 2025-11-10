local types = require("tableshape").types
local entityLifecycle = require("tenum.entity.lifecycle")
local todoList = require("todo.api.todoList")

return entityLifecycle({
  autoHashBase = "unique-hash-for-todo-entity",

  commands = {
    create = {
      validator = types.shape{
        id = types.string:is_optional(),
        title = types.string,
        listId = types.string,
      },
      call = function(args, context)
        -- Create the todo entity
        context.events.created{}

        -- Set the todo properties
        context.events.titleSet{
          title = args.title,
        }
        context.events.completedSet{
          completed = false,
        }
        context.events.listIdSet{
          listId = args.listId,
        }
        
        -- Add to the todo list
        todoList.commands.addTodo{
          id = args.listId,
          todoId = context.entityId,
        }
      end,
    },
    
    delete = {
      validator = types.shape{
        id = types.string,
        listId = types.string,
      },
      call = function(args, context)
        if not context.entity then error("Todo does not exist") end
        
        -- Remove from the todo list
        todoList.commands.removeTodo{
          id = args.listId,
          todoId = context.entityId,
        }
        
        context.events.deleted{}
      end,
    },
    
    setCompleted = {
      validator = types.shape{
        id = types.string,
      },
      call = function(args, context)
        if not context.entity then error("Todo does not exist") end
        
        local entity = context.entity or {}
        if entity.completed ~= true then
          context.events.completedSet{
            completed = true,
          }
        end
      end,
    },
    
    setUncompleted = {
      validator = types.shape{
        id = types.string,
      },
      call = function(args, context)
        if not context.entity then error("Todo does not exist") end
        
        local entity = context.entity or {}
        if entity.completed ~= false then
          context.events.completedSet{
            completed = false,
          }
        end
      end,
    },
  },
  
  events = {
    titleSet = {
      validator = types.shape{
        title = types.string,
      },
      call = function(event, context)
        local entity = context.entity or {}
        entity.title = event.title
        return entity
      end,
    },
    
    completedSet = {
      validator = types.shape{
        completed = types.boolean,
      },
      call = function(event, context)
        local entity = context.entity or {}
        entity.completed = event.completed
        return entity
      end,
    },
    
    listIdSet = {
      validator = types.shape{
        listId = types.string,
      },
      call = function(event, context)
        local entity = context.entity or {}
        entity.listId = event.listId
        return entity
      end,
    },
  },
  
  queries = {
    getTodo = {
      validator = types.shape{
        id = types.string,
      },
      call = function(_, context)
        return context.entity
      end,
    },
    
    get = {
      validator = types.shape{
        id = types.string,
      },
      call = function(_, context)
        return context.entity
      end,
    },
  },
  
  eventHandlers = {},
})
