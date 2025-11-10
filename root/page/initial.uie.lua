local LuAct = require("tenum.LuAct")
local uiFactory = require("uiFactory")
local Flex = uiFactory("ChakraUi::Flex")
local VStack = uiFactory("ChakraUi::VStack")
local Box = uiFactory("ChakraUi::Box")
local Text = uiFactory("ChakraUi::Text")
local Image = uiFactory("ChakraUi::Image")
local CreateTodo = uiFactory("todo.ui::CreateTodo")
local TodoList = uiFactory("todo.ui::TodoList")

local router = require('tenum.router').new()

router:match('', function(params)
  local listId = "default"

  return VStack {
        position = "relative",
        zIndex = "2",
        width = "100%",
        height = "100%",
        padding = {
          base = "75px 15px 65px 15px",
          md = "55px 37% 65px 7%",
          -- md = "55px 30px 65px 30px",
          -- lg = "55px 105px 65px 534px",
        },
        overflowY = "hidden",
        alignItems = "flex-start",
      }
      + Image {
        flex = 0,
        marginBottom = "15px",
        src = "https://assets.tenum.app/todoodle/todoapp-logo.png",
        width = "264px",
        height = "134px",
      }
      + CreateTodo { listId = listId }
      + TodoList { listId = listId }
      + Image {
        display = {
          base = "none",
          md = "block",
        },
        position = "absolute",
        zIndex = -1,
        bottom = "0px",
        right = "0px",
        width = "53%",
        height = "auto",
        src = "https://assets.tenum.app/todoodle/todoapp-image-01.png",
      }
end)

return LuAct.createComponent(function(props)
  local ok, content = router:execute(props.route)

  if not ok then
    content = Text { text = "Page not found" }
  end

  return Flex {
        width = "100vw",
        height = "100vh",
        bgGradient = "linear(180deg, #FFF674 0%, #FF65E5 100%)",
      }
      + content
end)
