local types = require("tableshape").types
local entityLifecycle = require("tenum.entity.lifecycle")

return entityLifecycle({
  autoHashBase = "unique-hash-for-todo-list-entity",
  
  commands = {
    create = {
      validator = types.shape{
        id = types.string,
      },
      call = function(args, context)
        -- Create the todoList entity
        context.events.created{}
        
        -- Set the list name
        context.events.nameSet{
          name = args.id,
        }
        
        -- Initialize empty todo list
        context.events.todoIdsSet{
          todoIds = {},
        }
      end,
    },

    delete = {
      validator = types.shape{
        id = types.string,
      },
      call = function(_, context)
        if not context.entity then error("TodoList does not exist") end
        context.events.deleted{}
      end,
    },

    addTodo = {
      validator = types.shape{
        id = types.string,
        todoId = types.string,
      },
      call = function(args, context)
        if (not context.entity.lifecycle)
          or (not context.entity.lifecycle)
          or (not context.entity.lifecycle.isCreated) then
          -- Auto-create the list if it doesn't exist
          context.events.created{}
          context.events.nameSet{
            name = args.id,
          }
          context.events.todoIdsSet{
            todoIds = {},
          }
        end
        
        context.events.todoAdded{
          todoId = args.todoId,
        }
      end,
    },
    
    removeTodo = {
      validator = types.shape{
        id = types.string,
        todoId = types.string,
      },
      call = function(args, context)
        if not context.entity then error("TodoList does not exist") end
        
        context.events.todoRemoved{
          todoId = args.todoId,
        }
      end,
    },
  },
  
  events = {
    nameSet = {
      validator = types.shape{
        name = types.string,
      },
      call = function(event, context)
        local entity = context.entity or {}
        entity.name = event.name
        return entity
      end,
    },
    
    todoIdsSet = {
      validator = types.shape{
        todoIds = types.array_of(types.string),
      },
      call = function(event, context)
        local entity = context.entity or {}
        entity.todoIds = event.todoIds
        return entity
      end,
    },
    
    todoAdded = {
      validator = types.shape{
        todoId = types.string,
      },
      call = function(event, context)
        local entity = context.entity or {}
        entity.todoIds = entity.todoIds or {}
        table.insert(entity.todoIds, event.todoId)
        return entity
      end,
    },
    
    todoRemoved = {
      validator = types.shape{
        todoId = types.string,
      },
      call = function(event, context)
        local entity = context.entity or {}
        if entity.todoIds then
          for i, id in ipairs(entity.todoIds) do
            if id == event.todoId then
              table.remove(entity.todoIds, i)
              break
            end
          end
        end
        return entity
      end,
    },
  },
  
  queries = {
    get = {
      validator = types.shape{
        id = types.string,
      },
      call = function(args, context)
        return context.entity
      end,
    },
    
    getTodos = {
      validator = types.shape{
        id = types.string,
      },
      call = function(_, context)
        local entity = context.entity or {}
        return entity and entity.todoIds or {}
      end,
    },
  },
  
  eventHandlers = {},
})    