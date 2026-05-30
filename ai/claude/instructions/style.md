


# Coding Style

## General
- Prioritize clean architecture and clear structure over clever code
- Favour explicit over implicit — readable beats terse
- Consistent naming and folder conventions matter; follow what exists before inventing new patterns
- When suggesting structure, explain the reasoning — I make the final call

## C# / Unity
- Follow standard C# conventions (PascalCase types, camelCase fields, _prefixPrivate)
- Prefer composition over inheritance where practical
- Avoid the Unity lifecycle as much as possible - logic belongs in plain C# classes
- avoid magic strings and hardcoded values
- Do not use regions 

## Node.js (Discord Bot)
- ESModules preferred
- Async/await over callbacks or raw promises
- Keep command handlers and business logic in separate files
- Config via environment variables — never hardcoded
