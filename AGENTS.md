# AGENTS.md - Cordova InAppBrowser Plugin

Essential information for agentic coding agents working on this Apache Cordova plugin.

## Project Overview

- **Type**: Apache Cordova Plugin for in-app browser functionality
- **Platforms**: Android, iOS, Browser
- **Languages**: JavaScript, Java (Android), Objective-C (iOS)
- **License**: Apache 2.0 (all new files MUST include license header)

## Build & Test Commands

```bash
npm install              # Install dependencies
npm run lint             # Run ESLint on all JS files
npm test                 # Alias for npm run lint
npm run build:android    # Run Android verification script
```

### Running Specific Tests

Tests run via GitHub Actions CI. Manual testing requires a Cordova project:
- **Auto tests**: `tests/tests.js` → `exports.defineAutoTests()` (Jasmine)
- **Manual tests**: `tests/tests.js` → `exports.defineManualTests()`

To run lint on a specific file:
```bash
npx eslint www/inappbrowser.js
npx eslint tests/tests.js
```

## Code Style Guidelines

### ESLint Configuration
- **Root**: `.eslintrc.yml` → extends `@cordova/eslint-config/browser`
- **Tests**: Configured via overrides in root `.eslintrc.yml` → extends `@cordova/eslint-config/node-tests`
- **Test env**: `tests/.eslintrc.yml` → adds `jasmine: true` environment

### JavaScript Module Pattern (IIFE + CommonJS)

All JavaScript files follow this pattern:

```javascript
/* Apache License Header (20 lines including closing comment) */

(function () {
    const exec = require('cordova/exec');
    const channel = require('cordova/channel');
    
    function ConstructorName () {
        this.channels = {
            eventname: channel.create('eventname')
        };
    }
    
    ConstructorName.prototype = {
        method: function (param) {
            // implementation
        },
        addEventListener: function (eventname, f) {
            if (eventname in this.channels) {
                this.channels[eventname].subscribe(f);
            }
        }
    };
    
    module.exports = function (/* args */) {
        return new ConstructorName();
    };
})();
```

### Naming Conventions

| Element | Convention | Example |
|---------|------------|---------|
| Constructors | PascalCase | `InAppBrowser` |
| Methods/Functions | camelCase | `addEventListener`, `executeScript` |
| Variables | camelCase | `strUrl`, `iabInstance` |
| Private methods | underscore prefix | `_eventHandler`, `_loadAfterBeforeload` |
| File names | lowercase | `inappbrowser.js` |

### Error Handling Pattern

```javascript
// Always validate and throw descriptive errors
executeScript: function (injectDetails, cb) {
    if (injectDetails.code) {
        exec(cb, null, 'InAppBrowser', 'injectScriptCode', [injectDetails.code, !!cb]);
    } else if (injectDetails.file) {
        exec(cb, null, 'InAppBrowser', 'injectScriptFile', [injectDetails.file, !!cb]);
    } else {
        throw new Error('executeScript requires exactly one of code or file to be specified');
    }
}
```

### Cordova Exec Pattern

```javascript
// Native bridge calls
exec(successCallback, errorCallback, 'ServiceName', 'actionName', [args]);
exec(cb, null, 'InAppBrowser', 'close', []);  // null for unused callback
```

## File Structure

```
├── www/inappbrowser.js          # Main JS API (IIFE pattern)
├── src/android/*.java           # Android native (3 files)
├── src/ios/*.m                  # iOS native (4 .m + 4 .h files)
├── src/browser/*.js             # Browser proxy
├── types/index.d.ts             # TypeScript definitions
├── tests/tests.js               # Jasmine test suite
├── plugin.xml                   # Cordova plugin manifest
└── package.json                 # npm config
```

## Key Implementation Patterns

### Event System (Cordova Channels)

```javascript
// Creating channels
this.channels = {
    loadstart: channel.create('loadstart'),
    loadstop: channel.create('loadstop'),
    exit: channel.create('exit')
};

// Firing events
this.channels[event.type].fire(event);

// Subscribing/Unsubscribing
this.channels[eventname].subscribe(callback);
this.channels[eventname].unsubscribe(callback);
```

### TypeScript Definitions

Update `types/index.d.ts` when changing the API:

```typescript
interface InAppBrowser {
    open(url: string, target?: string, options?: string): InAppBrowser;
    addEventListener(type: channel, callback: InAppBrowserEventListenerOrEventListenerObject): void;
    close(): void;
    show(): void;
    hide(): void;
    executeScript(script: { code: string } | { file: string }, callback: (result: any) => void): void;
    insertCSS(css: { code: string } | { file: string }, callback: () => void): void;
}
```

## Development Workflow

### Adding a New Feature

1. Add JS API in `www/inappbrowser.js` (follow prototype pattern)
2. Add native implementation in `src/android/` and/or `src/ios/`
3. Update `types/index.d.ts` with new types
4. Add tests in `tests/tests.js`
5. Update `README.md` for user-facing changes
6. Run `npm run lint` before committing

### Test Patterns (Jasmine)

```javascript
describe('cordova.InAppBrowser', function () {
    let iabInstance;
    
    beforeEach(function () {
        jasmine.DEFAULT_TIMEOUT_INTERVAL = 30000;
    });
    
    afterEach(function (done) {
        if (iabInstance !== null && iabInstance.close) {
            iabInstance.close();
        }
        setTimeout(done, 2000);
    });
    
    it('should exist', function () {
        expect(cordova.InAppBrowser).toBeDefined();
    });
});
```

## Platform Quirks

- **Browser**: `loadstart`, `loaderror`, `message` events not fired
- **iOS**: Uses WKWebView; supports `beforeload` interception
- **Android**: Supports `download` event; hardware back button handling

## Quality Checklist

- [ ] All new JS files have Apache license header (20 lines including closing comment)
- [ ] ESLint passes: `npm run lint`
- [ ] TypeScript definitions updated if API changed
- [ ] Backward compatibility maintained
- [ ] Cross-platform behavior verified (or platform-specific handling documented)

## References

- [Cordova Plugin Development](https://cordova.apache.org/docs/en/latest/guide/hybrid/plugins/)
- [Apache License Header](http://www.apache.org/licenses/LICENSE-2.0)
