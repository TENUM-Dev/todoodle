# Todoodle

A full-stack todo application built with TENUM, demonstrating serverless, agentic software development using Lua artifacts.

## Overview

Todoodle showcases how to build a complete, production-ready application using TENUM's artifact-based architecture. The app implements a todo list with real-time updates, event sourcing, and a modern UI—all written in Lua without any infrastructure code.

## Features

- ✅ Create, complete, and delete todos
- ✅ Event-sourced architecture with CQRS pattern
- ✅ Reactive UI with LuAct (Lua + React-like hooks)
- ✅ Chakra UI components for modern design
- ✅ Automated testing with specs
- ✅ No build configuration or DevOps required

## Project Structure

```
root/
  ├── page/
  │   └── initial.uie.lua          # Main page UI element
  └── todo/
      ├── api/
      │   ├── todo.e.lua            # Todo entity (CQRS + Event Sourcing)
      │   ├── todo.e.spec.lua       # Todo entity tests
      │   ├── todoList.e.lua        # TodoList entity
      │   └── todoList.e.spec.lua   # TodoList entity tests
      └── ui/
          ├── CreateTodo.uie.lua    # Todo creation UI component
          ├── TodoItem.uie.lua      # Individual todo item UI
          └── TodoList.uie.lua      # Todo list container UI
```

### Key Artifacts

**Entities** (`.e.lua`)
- `todo.e.lua` - Individual todo item with commands (create, delete, setCompleted, setUncompleted)
- `todoList.e.lua` - Todo list container managing multiple todos

**UI Elements** (`.uie.lua`)
- `initial.uie.lua` - Main application layout with routing
- `CreateTodo.uie.lua` - Input form for creating new todos
- `TodoItem.uie.lua` - Displays individual todo with toggle/delete actions
- `TodoList.uie.lua` - Renders all todos in a list

**Specs** (`.e.spec.lua`)
- Automated tests for entities validating commands, events, and queries

## Getting Started

### Prerequisites

Install the TENUM Development Manager (TDM):

```bash
npm install -g @tenum_dev/tdm-cli
```

### Development

Run the development environment with two terminals:

**Terminal 1 - Test Watcher**
```bash
tdm test --watch
```
This watches for code changes, translates Lua to handlers, and runs test specs automatically.

**Terminal 2 - Live Preview**
```bash
tdm preview
```
Then visit [https://preview.staging.tenum.run/](https://preview.staging.tenum.run/)

Changes to UI elements are reflected immediately in the preview.

## Architecture Patterns

### CQRS & Event Sourcing

Todoodle follows TENUM's CQRS pattern:

- **Commands** - Validate input, enforce business rules, emit events
  - `create`, `delete`, `setCompleted`, `setUncompleted`
- **Events** - Pure state changers with past-tense names
  - `titleSet`, `completedSet`, `listIdSet`, `todoAdded`, `todoRemoved`
- **Queries** - Read-only, always validated
  - `get`, `getTodo`, `getTodos`

### UI Composition

UI elements use LuAct with the `+` operator for composition:

```lua
return Flex{ width = "100%" }
  + Text{ text = "Hello" }
  + Button{ text = "Click me" }
```

All UI elements include `aria-label` for accessibility.

## Testing

Run all tests:
```bash
tdm test
```

Test results are available in `reports/` directory.

## Dependencies

- `tenum/LuAct` (0.1.5) - Reactive UI framework
- `tenum/router` (0.0.1) - Client-side routing
- `tenum/user` (0.1.5) - User management

## Learn More

- [TENUM Documentation](https://tenum.ai)
- [TENUM Storybook](https://storybook.tenum.app) - Chakra UI component reference

## Notes

- The `handler/` and `testHandler/` directories contain compiled runtime binaries—do not edit these directly
- All source code lives in `root/`
- No infrastructure, build scripts, or non-Lua code required
- Focus exclusively on Lua artifacts following TENUM conventions

## License

See [LICENSE](LICENSE) file for details.