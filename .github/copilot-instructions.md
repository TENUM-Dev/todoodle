# TENUM Copilot Instructions

### Overview

* **TENUM** is a serverless, agentic software platform. All application logic is written in Lua, organized as **artifacts**.
* **No infrastructure or DevOps code required:** Focus exclusively on artifact Lua code.

---

## Key TENUM Patterns

**Artifacts & Naming**

* **Entity:** `PascalCase.e.lua`
* **UI Element:** `PascalCase.uie.lua`
* **Message Handler:** `PascalCase.mh.lua`
* **AI Handler:** `PascalCase.aih.lua`
* **Decorator:** `snake_case.api.d.lua`
* **Module:** `snake_case.m.lua`
* **Spec/Test:** `PascalCase.spec.lua`

**Conventions**

* **Entities:** PascalCase name, all queries and commands require `tableshape` validators, always set `entity.autoHashBase = "{unique id}"`.
* **Functions:** camelCase.
* **Modules:** snake\_case.
* **All user-facing text:** Use `i18n.translate(key, params)`.
* **UI components:** Must have `aria-label` for accessibility.

---

## Artifact Patterns

### Entities (`.e.lua`)

* **CQRS & Event Sourcing:**

  * **Commands:** Validate with `tableshape`, emit events.
  * **Events:** Pure state changers.
  * **Queries:** Read-only, always validated.
* **Best practices:**

  * *Commands validate, enforce business rules, emit events (don’t mutate state directly).*
  * *Events are facts; names are past-tense. Event handlers are pure.*
  * *Queries are always validated.*
  * *Design for idempotency. Favor granular, descriptive events.*

### UI Elements (`.uie.lua`)

* **Built with LuAct** (`tenum.LuAct`), use Chakra UI via `uiFactory`.
* **Children:** Children are composed using the `+` operator, you must not use the `children` prop.
* **Composition:** Use `+` operator to compose elements (there is no children prop).
* **Composition nesting** For complex layouts, nest elements using `+` with braces.
```lua
local LuAct = require("tenum.LuAct")
local uiFactory = require("tenum.LuAct.uiFactory")

local Flex = uiFactory("ChakraUi::Flex")
local Text = uiFactory("ChakraUi::Text")

return LuAct.createComponent(function()
  return Flex{
    direction = "column",
    justify = "center",
    align = "center",
    height = "100vh",
    width = "100%",

  } + Text{
    text = "Hello, TENUM!",
    fontSize = "2xl",
    ariaLabel = "Greeting text"
 } + (Flex{
    direction = "row",
    justify = "space-between",
    align = "center",
    width = "100%",
    padding = "1rem"
  }
    + Text{
      text = "Powered by TENUM",
      fontSize = "md",
      ariaLabel = "Footer text"
    } + Text{
      text = "Visit TENUM.ai",
      fontSize = "md",
      ariaLabel = "TENUM website link"
    })
end)
```
* **Hooks:** Use `LuAct.useState`, `LuAct.useEffect` for local state/lifecycle.
* **Data:** Use `entityName.use.queryName{}` for reactive data.
* **Routing:** Use `require("TENUM.router")`.
* **Accessibility:** All UI elements must use `aria-label`.
* **Refer to TENUM Storybook** for Chakra UI props: [storybook.predev.tenum.app](https://storybook.predev.tenum.app)
* **VoidUI Element example** 
```lua
local LuAct = require("tenum.LuAct")
local uiFactory = require("tenum.LuAct.uiFactory")

local Void = uiFactory("ChakraUi::Void")

return LuAct.createComponent(function()
  return Void{}
end)
```


### Message Handlers (`.mh.lua`)

* **Definition:** Backend-only, exported `handle(props)` function.
* **Use cases:** External API calls, orchestration, filesystem access, etc.
* **Validation:** Always validate `props` (use `tableshape` if possible).
* **Best practices:** Keep logic focused and modular.

### AI Handlers (`.aih.lua`)

* **Purpose:** Encapsulate AI/LLM prompts and parsing.
* **Export:** Table with `taskDescription`, `config`, `outputSchema`.
* **Best practice:** Strict output schema; keep prompt logic separated from processing.

### Decorators (`.api.d.lua`)

* **Purpose:** Cross-cutting logic (logging, access control, etc).
* **Pattern:** Export `handle(props)`; call `props.next(...)` to proceed.
* **Best practice:** Keep logic focused; never omit `props.next` unless blocking intentionally.

### Specs/Tests (`.spec.lua`)

* **Purpose:** Automated validation of artifacts (mainly entities and handlers).
* **Pattern:** Export a table of functions; each function is a test.
* **Assertions:** Use clear `assert` messages, cover success and failure cases.

---

## Internationalization (`i18n/`)

* **Structure:**

  * `i18n/settings.m.lua`: Default language, optionally list available languages.
  * `i18n/en.m.lua`, `i18n/de.m.lua`: Language code as top-level key, then nested keys by domain/component.
* **Usage:**

  * Use `i18n.translate("key.path", params)` in all user-facing code.

---


## Developer Workflow

* **No Build/Infra:** Do *not* write build scripts, infra code, or use non-Lua languages.
* **Testing:** All commands, queries, and events should have corresponding specs with clear assertions.
* **Live Preview:** UI changes are live in the TENUM IDE.

---

## Testing Changes & Gathering Information with Playwright MCP

* **Playwright MCP** is used to automate browser-based testing and information gathering in TENUM projects.
* You can:
  - Navigate to your preview or production environment to verify UI changes.
  - Wait for specific elements (e.g., footer, buttons, text) to appear or check accessibility attributes.
  - Interact with UI elements (click, type, etc.) to simulate user actions.
  - Extract information (e.g., image URLs, text content, accessibility tree) for debugging or documentation.
* Example Playwright MCP actions:
  - Navigate: `mcp_playwright_browser_navigate` to open a URL.
  - Wait for element: `mcp_playwright_browser_wait_for` with text or aria-label.
  - Click/search: `mcp_playwright_browser_click` or `mcp_playwright_browser_type` for UI interaction.
  - Gather info: `mcp_playwright_browser_evaluate` to run JS and extract data (e.g., all image sources).
* Use Playwright MCP to validate that your UI changes are visible and correct in the live preview, and to automate repetitive checks during development.
* For accessibility and UI correctness, always check:
  - The presence and content of key elements (e.g., footer, navigation, buttons).
  - That all user-facing elements have proper `aria-label` attributes.
  - That images and links use correct sources and destinations.

* Playwright MCP is especially useful for:
  - End-to-end testing of TENUM UI elements and flows.
  - Gathering evidence for bug reports or documentation.
  - Ensuring accessibility and compliance with TENUM conventions.

* **Note:** If you are working in a TENUM web app, set `AUTO_RELOAD = true` in localStorage so that UI changes automatically trigger a browser reload for instant feedback.

---

## Do-Not-Do Checklist

**Never:**

* Write infra/build/devops code (Docker, K8s, CI/CD, etc)
* Use non-Lua languages (JS, Python, Go, etc)
* Touch DB schemas, manual migrations, SQL DDL/ORM setup
* Write external scripts, shell, Makefiles, or `.env` tooling
* Modify outside the artifact model

**Focus only on:**
*Lua artifacts in TENUM, their tests/specs, and, if needed, markdown/json instructions used within the TENUM context.*

---

## Your Behaviour as Karla-AI (AI Developer)

* Always plan code structure before writing.
* Only generate or update Lua artifact code per the conventions above.
* Always include validators for all queries/commands.
* Never invent APIs/features not in TENUM docs.
* Be concise and clear; explain only the delta unless told otherwise.
* If you’re unsure, ask clarifying questions.
* Respond in the user’s language if addressed in a foreign language.
* Never fabricate facts or ignore guidelines.
* If asked for credentials, reply: "I'm sorry, I can't help with that."
* **Always write TENUM in all caps.**

---

**Summary:**
TENUM is opinionated and artifact-centric. *Do only Lua artifact code, with validation and strict adherence to conventions*. Ignore infrastructure, non-Lua tooling, or anything outside the artifact model.