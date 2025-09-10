# Shop Core - SourcePawn Plugin Development Guidelines

## Repository Overview
This repository contains **Shop Core**, a comprehensive shop system plugin for SourceMod that provides credit-based purchasing functionality for Source engine games (CS:GO, CS2, TF2, etc.). The plugin features a modular architecture with support for categories, items, player inventory management, database persistence, and multi-language support.

**Key Features:**
- Credit-based economy system
- Item categories and inventory management  
- MySQL/SQLite database support
- Multi-language translation support
- Admin commands for credit management
- Modular plugin architecture
- SteamWorks integration (optional)

## Technical Environment
- **Language**: SourcePawn
- **Platform**: SourceMod 1.10+ (minimum requirement, 1.12+ recommended for latest features)
- **Compiler**: SourcePawn Compiler (spcomp) via SourceKnight build system
- **Database**: MySQL (recommended) or SQLite
- **Build Tool**: SourceKnight 0.1+
- **Optional Dependencies**: SteamWorks extension

## Project Structure
```
addons/sourcemod/
├── scripting/
│   ├── shop.sp                    # Main plugin file
│   ├── shop/                      # Modular plugin components
│   │   ├── admin.sp              # Admin functionality
│   │   ├── db.sp                 # Database operations
│   │   ├── functions.sp          # Core functions
│   │   ├── player_manager.sp     # Player data management
│   │   ├── item_manager.sp       # Item handling
│   │   ├── commands.sp           # Command handlers
│   │   ├── forwards.sp           # Plugin forwards
│   │   ├── helpers.sp            # Helper functions
│   │   ├── colors.sp             # Color definitions
│   │   └── stats.sp              # Statistics
│   └── include/
│       ├── shop.inc              # Main include file
│       └── shop/                 # Native function definitions
│           ├── methodmaps.inc    # CategoryId/ItemId methodmaps
│           ├── functions.inc     # Function natives
│           ├── players.inc       # Player-related natives
│           ├── items.inc         # Item-related natives
│           ├── db.inc            # Database natives
│           ├── admin.inc         # Admin natives
│           └── register.inc      # Registration natives
├── configs/shop/
│   └── settings.txt              # Plugin configuration
├── translations/
│   ├── shop.phrases.txt          # English translations
│   ├── ru/shop.phrases.txt       # Russian translations
│   └── [other languages]/       # Additional language support
└── plugins/
    └── shop.smx                  # Compiled plugin (build output)

cfg/shop/
└── shop.cfg                      # Server configuration
```

## Code Style & Standards

### General Guidelines
- **Indentation**: Use tabs (4 spaces equivalent)
- **Semicolons**: Always required (`#pragma semicolon 1`)
- **New declarations**: Required (`#pragma newdecls required`)
- **Trailing spaces**: Remove all trailing whitespace

### Naming Conventions
- **Global variables**: Prefix with `g_` (e.g., `g_iMaxPageItems`)
- **Local variables/parameters**: camelCase (e.g., `clientId`, `itemName`)
- **Functions**: PascalCase (e.g., `OnPluginStart`, `RegisterCategory`)
- **Constants/Defines**: UPPER_CASE (e.g., `SHOP_VERSION`, `MAXPLAYERS`)
- **Enums**: PascalCase with descriptive names (e.g., `ItemType`, `ShopAction`)

### File Organization
- **Main plugin**: `shop.sp` contains core initialization and includes
- **Modular components**: Separate functionality into logical files in `shop/` directory
- **Include files**: Use `#include "shop/filename.sp"` for modular includes
- **Native definitions**: Place in appropriate files under `include/shop/`

## Database Best Practices

### SQL Query Guidelines
- **Always use async queries**: Never use synchronous database operations
- **Use transactions**: Wrap related queries in transactions for data integrity
- **Escape strings**: Always escape user input to prevent SQL injection
- **Use methodmaps**: Leverage Database methodmap for query execution
- **Error handling**: Implement proper error callbacks for all queries

### Example Patterns
```sourcepawn
// Correct: Async query with transaction
Transaction txn = new Transaction();
char query[256];
h_db.Format(query, sizeof(query), "INSERT INTO `%stable` VALUES ('%s')", g_sDbPrefix, escapedValue);
txn.AddQuery(query);
h_db.Execute(txn, OnTransactionSuccess, OnTransactionFailure);

// Correct: Async query with callback
char query[256];
h_db.Format(query, sizeof(query), "SELECT * FROM `%susers` WHERE `id` = %d", g_sDbPrefix, userId);
h_db.Query(OnQueryCallback, query, clientId);
```

### Memory Management
- **Use `delete` directly**: No need to check for null before calling delete
- **Avoid `.Clear()`**: Use `delete` and create new instances instead (prevents memory leaks)
- **StringMap/ArrayList**: Always use `delete` for cleanup, never `.Clear()`

```sourcepawn
// Correct
delete myStringMap;
myStringMap = new StringMap();

// Incorrect - causes memory leaks
myStringMap.Clear();
```

## Build System

### SourceKnight Configuration
The project uses SourceKnight as the build system. Key configuration in `sourceknight.yaml`:

```yaml
project:
  name: Shop
  dependencies:
    - sourcemod (1.11.0+)
    - ext-steamworks (optional)
  targets:
    - shop
```

### Building
```bash
# Install SourceKnight
pip install sourceknight

# Build the plugin
sourceknight build

# Output will be in .sourceknight/package/
# Compiled .smx files will be in the package structure
```

### CI/CD Pipeline
- **GitHub Actions**: Automated building via `.github/workflows/ci-sourceknight.yml`
- **Build triggers**: Push to main/master, pull requests, tags
- **Artifacts**: Compiled plugins and packaged releases
- **Release**: Auto-generated releases for tags and latest builds

## Development Patterns

### Plugin Initialization
```sourcepawn
public void OnPluginStart()
{
    // Load translations first
    LoadTranslations("shop.phrases");
    
    // Initialize database connection
    DB_OnPluginStart();
    
    // Register commands
    RegConsoleCmd("sm_shop", Command_Shop);
    
    // Load configuration
    LoadConfig();
    
    // Initialize other components
    PlayerManager_OnPluginStart();
    ItemManager_OnPluginStart();
}
```

### Native Function Registration
```sourcepawn
void CreateNatives()
{
    CreateNative("Shop_GetCredits", Native_GetCredits);
    CreateNative("Shop_SetCredits", Native_SetCredits);
    // Use descriptive native names
}

public int Native_GetCredits(Handle plugin, int numParams)
{
    int client = GetNativeCell(1);
    return g_iCredits[client];
}
```

### Event Handling
```sourcepawn
public void OnClientPostAdminCheck(int client)
{
    if (!IsFakeClient(client))
    {
        LoadPlayerData(client);
    }
}

public void OnClientDisconnect(int client)
{
    SavePlayerData(client);
    ResetPlayerVariables(client);
}
```

## Configuration Management

### Settings File Structure
Configuration in `addons/sourcemod/configs/shop/settings.txt`:
- Database prefix settings
- Command definitions  
- Menu configurations
- Credit amount presets

### Translation Support
- Use `LoadTranslations("shop.phrases")` in OnPluginStart
- Support multiple languages in `translations/` directory
- Use descriptive phrase keys (e.g., "Credits_Display", "Item_Purchased")

## Performance Considerations

### Optimization Guidelines
- **Avoid O(n) operations**: Cache results, use efficient data structures
- **Timer usage**: Minimize unnecessary timers, prefer event-driven architecture
- **String operations**: Minimize string manipulations in frequently called functions
- **Database queries**: Batch operations where possible, use appropriate indexes
- **Memory allocation**: Reuse objects when possible, avoid frequent allocations

### Frequent Operation Patterns
```sourcepawn
// Cache expensive lookups
static int cachedValue = -1;
if (cachedValue == -1) {
    cachedValue = ExpensiveCalculation();
}
return cachedValue;

// Use efficient data structures
StringMap itemCache = new StringMap(); // O(1) lookup vs array iteration
```

## Testing and Validation

### Development Testing
1. **Compile check**: Ensure code compiles without warnings using SourceKnight
2. **Server testing**: Test on development server before deployment
3. **Memory profiling**: Use SourceMod's built-in profiler to check for leaks
4. **Database validation**: Verify all queries are async and properly escaped
5. **Translation testing**: Verify all phrases are properly translated
6. **Multi-language support**: Test with different language configurations

### Local Development Setup
```bash
# Set up a local Source engine server for testing
# Install SourceMod 1.10+ 
# Configure database connection in databases.cfg
# Load the plugin and test functionality
```

### Code Quality Checks
- Check for proper error handling in all API calls
- Verify all database operations use async patterns
- Ensure proper memory management (delete vs Clear)
- Validate translation key usage
- Test with minimum SourceMod version (1.10+, validate with 1.12+)

## Common Patterns and Examples

### Item Registration
```sourcepawn
public void OnPluginStart()
{
    CategoryId category = new CategoryId("weapons", "Weapons", "Weapon items");
    category.NewItem("ak47");
    ItemId ak47 = category.GetItemId("ak47");
    ak47.SetName("AK-47");
    ak47.SetPrice(1500);
    ak47.Register();
}
```

### Player Data Management
```sourcepawn
void LoadPlayerData(int client)
{
    char query[256];
    char steamId[32];
    GetClientAuthId(client, AuthId_Steam2, steamId, sizeof(steamId));
    
    h_db.Format(query, sizeof(query), 
        "SELECT credits FROM `%susers` WHERE `steam_id` = '%s'", 
        g_sDbPrefix, steamId);
    h_db.Query(OnPlayerDataLoaded, query, GetClientUserId(client));
}
```

## Documentation Requirements

### Code Documentation
- **Native functions**: Document all parameters, return values, and usage examples
- **Complex logic**: Add comments explaining business logic
- **Database operations**: Document table structures and query purposes
- **Configuration**: Document all configuration options and their effects

### API Documentation
- Document all public natives in include files
- Provide usage examples for complex APIs
- Document forwards and their parameters
- Include error conditions and handling

## Version Control and Releases

### Versioning
- Use semantic versioning (MAJOR.MINOR.PATCH)
- Update version in `#define SHOP_VERSION` 
- Tag releases in format `vX.Y.Z`
- Keep CHANGELOG updated for user-facing changes

### Commit Guidelines
- Clear, descriptive commit messages
- Separate logical changes into different commits
- Reference issue numbers when applicable
- Test changes before committing

---

This plugin follows SourceMod's best practices and provides a solid foundation for shop system functionality. When contributing, always prioritize code quality, performance, and user experience.