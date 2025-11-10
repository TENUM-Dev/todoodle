local todoList = require("todo.api.todoList")
local LuAct = require("tenum.LuAct")
local uiFactory = require("tenum.LuAct.uiFactory")
local Box = uiFactory("ChakraUi::Box")
local VStack = uiFactory("ChakraUi::VStack")
local TodoItem = uiFactory("todo.ui::TodoItem")

return LuAct.createComponent(function(props)
  local todos = todoList.use.getTodos {
    id = props.listId
  } or {}

  local main = VStack {
    width = "100%",
    height = "100%",
    paddingRight = "10px",
    overflowY = "auto",
    alignItems = "stretch",
    justifyContent = "flex-start",
    gap = "4px",
    sx = {
      ["&::-webkit-scrollbar"] = {
        marginLeft = "12px",
        width = '8px',
        backgroundColor = "transparent",
      },
      ['&::-webkit-scrollbar-track'] = {
        backgroundColor = "transparent",
      },
      ['&::-webkit-scrollbar-thumb'] = {
        borderRadius = '24px',
        backgroundColor = "grey",
        backgroundClip = "content-box",
      },
    }
  }

  for _, todoId in pairs(todos) do
    main = main + TodoItem {
      id = todoId,
      listId = props.listId
    }
  end

  return Box {
        flex = 1,
        width = "100%",
        overflowY = "hidden",
      }
      + main
end)
