# Cordova InAppBrowser 无障碍支持

本文档描述了cordova-plugin-inappbrowser插件的无障碍支持功能，这些功能确保内嵌WebView中的内容能够被Android的Accessibility Service（如屏幕阅读器TalkBack）正确识别和访问。

## 功能概述

### 1. WebView无障碍配置
- 自动设置WebView为无障碍可见
- 配置适当的焦点和触摸模式
- 设置无障碍内容描述
- 启用无障碍事件处理

### 2. UI元素无障碍支持
- 为所有按钮添加适当的contentDescription
- 为工具栏、页脚等布局元素设置无障碍描述
- 确保所有交互元素对无障碍服务可见

### 3. JavaScript无障碍接口
- 提供`window.accessibility`接口
- 支持无障碍播报功能
- 检测无障碍服务状态

### 4. 自动无障碍增强
- 自动为WebView中的元素添加ARIA标签
- 动态监听DOM变化并应用无障碍支持
- 为可交互元素设置适当的tabindex

## 使用方法

### 基本用法
```javascript
// 打开InAppBrowser
var ref = cordova.InAppBrowser.open('https://example.com', '_blank', 'location=yes');

// 检查无障碍服务是否启用
ref.addEventListener('loadstop', function() {
    ref.executeScript({
        code: "if (window.accessibility && window.accessibility.isAccessibilityEnabled()) { console.log('无障碍服务已启用'); }"
    });
});
```

### JavaScript接口使用
在WebView加载的页面中，可以使用以下JavaScript接口：

```javascript
// 检查无障碍服务是否启用
if (window.accessibility && window.accessibility.isAccessibilityEnabled()) {
    console.log('无障碍服务已启用');
}

// 播报无障碍消息
if (window.accessibility && window.accessibility.announceForAccessibility) {
    window.accessibility.announceForAccessibility('这是一条重要的消息');
}
```

### 自动无障碍增强
插件会自动为WebView中的以下元素添加无障碍支持：
- 按钮 (button)
- 输入框 (input)
- 下拉框 (select)
- 文本域 (textarea)
- 链接 (a)
- 具有role属性的元素

## 测试

### 测试页面
使用提供的测试页面来验证无障碍功能：
```
tests/accessibility-test.html
```

### 测试步骤
1. 在Android设备上启用TalkBack或其他屏幕阅读器
2. 打开测试页面
3. 使用屏幕阅读器导航页面元素
4. 验证所有交互元素都能被正确识别
5. 测试动态内容和无障碍播报功能

### 测试内容
- 基本交互元素（按钮、输入框、链接等）
- 动态内容添加和移除
- 隐藏/显示内容切换
- 表单元素
- 无障碍播报功能

## 技术实现

### Android端实现
- 在`InAppBrowser.java`中添加无障碍支持
- 设置WebView的无障碍属性
- 为UI元素添加无障碍描述
- 实现JavaScript无障碍接口

### JavaScript端实现
- 自动检测和增强WebView内容
- 动态监听DOM变化
- 提供无障碍播报功能
- 自动添加ARIA标签

## 兼容性

- Android 4.1 (API 16) 及以上版本
- 支持所有主要的Android无障碍服务
- 兼容TalkBack、Voice Assistant等屏幕阅读器

## 注意事项

1. 无障碍功能仅在Android设备上可用
2. 需要用户启用无障碍服务才能生效
3. JavaScript接口仅在WebView加载完成后可用
4. 动态内容会自动应用无障碍增强

## 故障排除

### 常见问题
1. **无障碍服务无法识别WebView内容**
   - 确保设备已启用无障碍服务
   - 检查WebView是否正确加载

2. **JavaScript接口不可用**
   - 确保页面已完全加载
   - 检查JavaScript是否启用

3. **动态内容无障碍支持不生效**
   - 等待DOM变化监听器初始化
   - 检查元素是否符合自动增强条件

### 调试方法
```javascript
// 检查无障碍服务状态
console.log('无障碍服务状态:', window.accessibility ? window.accessibility.isAccessibilityEnabled() : '接口不可用');

// 检查元素无障碍属性
var element = document.querySelector('button');
console.log('元素无障碍属性:', {
    'aria-label': element.getAttribute('aria-label'),
    'tabindex': element.getAttribute('tabindex'),
    'contentDescription': element.getAttribute('title')
});
```

## 更新日志

### v1.0.0
- 初始无障碍支持实现
- WebView无障碍配置
- UI元素无障碍描述
- JavaScript无障碍接口
- 自动无障碍增强
- 测试页面和文档
