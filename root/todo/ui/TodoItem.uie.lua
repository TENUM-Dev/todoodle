local todo = require("todo.api.todo")
local LuAct = require("tenum.LuAct")
local uiFactory = require("tenum.LuAct.uiFactory")
local EventContainer = uiFactory("Basic::EventContainer")
local HStack = uiFactory("ChakraUi::HStack")
local Checkbox = uiFactory("ChakraUi::Checkbox")
local Text = uiFactory("ChakraUi::Text")
local Image = uiFactory("ChakraUi::Image")
local Button = uiFactory("ChakraUi::Button")

return LuAct.createComponent(function(props)
  local todoItem = todo.use.getTodo { id = props.id }
  if not todoItem then
    return HStack {}
  end

  local toggleComplete = LuAct.useCallback(function()
    if (todoItem.completed) then
      todo.commands.setUncompleted {
        id = props.id,
      }
    else
      todo.commands.setCompleted {
        id = props.id,
      }
    end
  end, { todoItem.completed, props.id })

  local deleteTodo = LuAct.useCallback(function()
    todo.commands.delete {
      id = props.id,
      listId = props.listId
    }
  end, { props.id, props.listId })

  return HStack {
        flex = "0 0 auto",
        width = "100%",
        height = "50px",
        paddingX = "20px",
        bgColor = "white",
        borderRadius = "30px",
        alignItems = "center",
        justifyContent = "space-between",
        gap = "10px"
      }
      + Checkbox {
        size = "lg",
        width = "24px",
        height = "24px",
        iconColor = "black",
        iconSize = "14px",
        sx = {
          [".chakra-checkbox__control"] = {
            width = "100%",
            height = "100%",
            borderRadius = "3px",
            bgColor = "#F1F1F1",
            borderColor = "transparent",
            _checked = {
              bgColor = "#D9ED24",
              borderColor = "transparent",
            },
          }
        },
        isChecked = todoItem.completed,
        onChange = toggleComplete,
      }
      + Text {
        flex = 1,
        text = todoItem.title,
        fontSize = "16px",
        fontWeight = "500",
        lineHeight = "100%",
        textDecoration = todoItem.completed and "line-through" or "none",
      }
      + (
        EventContainer {
          onClickEvent = deleteTodo
        }
        + Image {
          src = "https://assets.tenum.app/todoodle/todoapp-trash-icon.svg",
          width = "20px",
          height = "27px",
        }
      -- + Button {
      --   text = "Delete",
      --   onClick = deleteTodo,
      -- }
      )
end)
