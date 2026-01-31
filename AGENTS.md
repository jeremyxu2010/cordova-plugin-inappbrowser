# AGENTS.md - Cordova InAppBrowser Plugin

This document provides essential information for agentic coding agents working on the Apache Cordova InAppBrowser plugin repository.

## Project Overview

**Type**: Apache Cordova Plugin for in-app browser functionality  
**Platforms**: Android, iOS, Browser  
**Language**: JavaScript (with platform-specific Java/Objective-C implementations)  
**License**: Apache 2.0  
**Repository**: https://github.com/apache/cordova-plugin-inappbrowser

## Build & Development Commands

### Package Management
```bash
npm install          # Install dependencies
npm ci               # Clean install (CI)
```

### Linting & Code Quality
```bash
npm run lint         # Run ESLint on all files
npm test             # Alias for `npm run lint`
```

### Platform-Specific Testing
The project uses GitHub Actions for platform-specific testing:
- `android.yml` - Android testsuite
- `ios.yml` - iOS testsuite  
- `chrome.yml` - Browser testsuite
- `lint.yml` - Lint validation

### Running Tests
```bash
# Manual test execution depends on Cordova test framework
# See tests/tests.js for test definitions
```

## Code Style Guidelines

### ESLint Configuration
- **Config File**: `.eslintrc.yml`
- **Base Config**: `@cordova/eslint-config/browser`
- **Test Override**: `@cordova/eslint-config/node-tests` for test files

### JavaScript Patterns

#### Module Structure
- **Immediate Invoked Function Expression (IIFE)** pattern for main module
- **CommonJS** `require()` for dependencies
- **Module exports** using `module.exports`

Example from `www/inappbrowser.js`:
```javascript
(function () {
    const exec = require('cordova/exec');
    const channel = require('cordova/channel');
    
    function InAppBrowser() {
        // Constructor
    }
    
    InAppBrowser.prototype = {
        // Methods
    };
    
    module.exports = function (strUrl, strWindowName, strWindowFeatures, callbacks) {
        // Factory function
    };
})();
```

#### Naming Conventions
- **Constructor Functions**: PascalCase (`InAppBrowser`)
- **Methods**: camelCase (`addEventListener`, `executeScript`)
- **Variables**: camelCase (`strUrl`, `iabInstance`)
- **Constants**: camelCase (no ALL_CAPS convention observed)

#### Error Handling
- Use `throw new Error()` with descriptive messages
- Check parameters before execution
- Example: `executeScript` validates `injectDetails` parameter

#### Function Patterns
- Prototype-based inheritance for object methods
- Factory function pattern for creating instances
- Event-driven architecture using Cordova channels

### TypeScript Definitions
- **Location**: `types/index.d.ts`
- **Version**: TypeScript 2.3+
- **Purpose**: Type definitions for plugin API
- **Key Interfaces**: `InAppBrowser`, `InAppBrowserEvent`, `Cordova`

### Platform-Specific Code
- **Android**: Java files in `src/android/`
- **iOS**: Objective-C files in `src/ios/`
- **Browser**: JavaScript proxy in `src/browser/`

## File Structure

```
.
├── www/
│   └── inappbrowser.js          # Main JavaScript API
├── src/
│   ├── android/                 # Android implementation
│   ├── ios/                     # iOS implementation  
│   └── browser/                 # Browser implementation
├── types/
│   └── index.d.ts              # TypeScript definitions
├── tests/
│   ├── tests.js                # Test suite
│   ├── package.json           # Test package config
│   └── .eslintrc.yml          # Test ESLint config
├── plugin.xml                  # Cordova plugin manifest
├── package.json               # NPM package config
├── .eslintrc.yml              # ESLint configuration
└── .github/workflows/         # CI/CD pipelines
```

## Key Implementation Patterns

### 1. Event System
- Uses Cordova's `channel` module for event management
- Events: `loadstart`, `loadstop`, `loaderror`, `exit`, `message`, `download`
- Event handlers attached via `addEventListener`

### 2. Platform Bridge
- Uses `cordova/exec` for native communication
- Method signatures follow Cordova plugin pattern
- Platform-specific implementations handle native browser functionality

### 3. Configuration
- `plugin.xml` defines platform configurations, resources, and dependencies
- Preference settings for platform-specific behavior
- Resource files for platform UI elements

## Development Workflow

### 1. Making Changes
1. Ensure ESLint passes: `npm run lint`
2. Follow existing patterns in similar files
3. Update TypeScript definitions if API changes
4. Add/update tests in `tests/tests.js`

### 2. Testing
- Platform tests run via GitHub Actions
- Manual testing requires Cordova project setup
- Test coverage includes API methods and event handling

### 3. Code Review Considerations
- **API Compatibility**: Changes must maintain backward compatibility
- **Cross-Platform Consistency**: Behavior should be consistent across platforms
- **Error Handling**: Proper error messages and handling
- **Documentation**: Update README.md for user-facing changes

## Plugin Configuration

### Preferences (config.xml)
```xml
<preference name="InAppBrowserStatusBarStyle" value="lightcontent" />
```

### Platform-Specific Options
See `README.md` for complete list of `open()` method options for each platform.

## Common Tasks

### Adding New Feature
1. Add JavaScript API in `www/inappbrowser.js`
2. Implement platform-specific code in `src/` directories
3. Update TypeScript definitions in `types/index.d.ts`
4. Add tests in `tests/tests.js`
5. Update documentation in `README.md`

### Fixing Bug
1. Reproduce issue across platforms
2. Identify root cause in platform-specific code
3. Fix with minimal changes
4. Add regression test if applicable
5. Verify fix on all platforms

### Performance Optimization
1. Profile platform-specific implementations
2. Optimize native code (Java/Objective-C)
3. Reduce JavaScript overhead
4. Test on target devices

## Quality Standards

### Code Quality
- ESLint must pass with no errors
- Follow Apache Cordova coding conventions
- Consistent error handling patterns
- Clear, descriptive variable and function names

### Documentation
- Public API documented in README.md
- TypeScript definitions complete and accurate
- Code comments for complex logic
- JSDoc for public methods (where applicable)

### Testing
- Platform tests pass in CI
- Edge cases covered
- Cross-platform behavior verified

## Notes for Agentic Coding

1. **Context Awareness**: This is an Apache Foundation project with strict licensing requirements
2. **Cross-Platform**: Changes must consider Android, iOS, and Browser implementations
3. **Backward Compatibility**: API changes should maintain existing behavior
4. **Event System**: Understand Cordova's channel-based event architecture
5. **Native Bridge**: Familiarity with `cordova/exec` pattern required for platform work

## References
- [Apache Cordova Documentation](https://cordova.apache.org/docs/)
- [Cordova Plugin Development Guide](https://cordova.apache.org/docs/en/latest/guide/hybrid/plugins/)
- [ESLint Configuration](https://eslint.org/docs/user-guide/configuring/)
- [TypeScript Definition Files](https://www.typescriptlang.org/docs/handbook/declaration-files/introduction.html)