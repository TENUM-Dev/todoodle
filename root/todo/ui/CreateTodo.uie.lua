local todo = require("todo.api.todo")
local LuAct = require("tenum.LuAct")
local uiFactory = require("tenum.LuAct.uiFactory")
local Box = uiFactory("ChakraUi::Box")
local HStack = uiFactory("ChakraUi::HStack")
local Input = uiFactory("ChakraUi::Input")
local Button = uiFactory("ChakraUi::Button")

return LuAct.createComponent(function(props)
  local newTodoTitle, setNewTodoTitle = LuAct.useState("")

  local updateTodoTitle = LuAct.useCallback(
    function(event)
      setNewTodoTitle(event)
    end, {})

  local submit = LuAct.useCallback(
    function(event)
      if newTodoTitle ~= "" then
        setNewTodoTitle("")
        todo.commands.create {
          title = newTodoTitle,
          listId = props.listId
        }
      end
    end, { setNewTodoTitle, props.listId, newTodoTitle })

  local onSubmit = LuAct.useCallback(
    function(text)
      if text ~= "" then
        setNewTodoTitle("")
        todo.commands.create {
          title = text,
          listId = props.listId
        }
      end
    end, { setNewTodoTitle, props.listId })

  local main = HStack {
        width = "100%",
        height = "100%",
        padding = "3px 4px 3px 16px",
        bgColor = "#ffffff",
        borderRadius = "100px",
        gap = "5px",
      }
      + Input {
        fontSize = "18px",
        border = "none",
        _focus = {
          boxShadow = "none"
        },
        placeholder = "Enter todo title",
        value = newTodoTitle,
        onChange = updateTodoTitle,
        onSubmit = onSubmit
      }
      + Button {
        height = "100%",
        text = "Add Todo",
        bgColor = "#FF65E5",
        borderRadius = "100px",
        onClick = submit,
      }

  return Box {
        flex = "0 0 auto",
        width = "100%",
        height = "65px",
        paddingRight = "10px",
        marginBottom = "12px",
      }
      + main
end)
