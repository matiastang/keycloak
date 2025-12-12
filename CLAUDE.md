# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## 语言偏好 / Language Preference

**重要：默认使用简体中文进行所有回复和交流，除非明确要求使用其他语言。**

**IMPORTANT: Always use Simplified Chinese (简体中文) for all responses and communication by default, unless explicitly asked to use another language.**

## 项目概述 / Project Overview

这是 Keycloak 官方项目的一个 fork，**主要用途是开发和维护自定义主题 `vectorstory`**。

**工作范围**: 仅需关注主题开发，位于 `themes/src/main/resources/theme/vectorstory/`

关键特性：
- 自定义登录主题（Login Theme）
- 基于 PatternFly v5 组件库
- 支持深色模式
- 双语支持（简体中文和英文）
- 自定义样式和布局

## 主题开发不需要构建 / Theme Development Does NOT Require Building

**重要**: 开发 VectorStory 主题时，**无需构建 Keycloak 项目**。

主题文件可以直接通过以下方式使用：
1. Docker 容器 volume 挂载（推荐）
2. 开发服务器实时加载（`-Dresources` 参数）
3. 复制到 Keycloak 部署目录

### 如果需要构建（仅在必要时）

```bash
# 仅在需要完整 Keycloak 发行版时构建
./mvnw clean install -DskipTests -DskipProtoLock=true

# 必要条件
# - JDK 17 或 JDK 21
# - Maven (使用 ./mvnw wrapper)
```

## 主题开发 / Theme Development

### VectorStory 主题目录结构

**主题根目录**: `themes/src/main/resources/theme/vectorstory/`

```
themes/src/main/resources/theme/vectorstory/
└── login/                     # 登录主题（主要工作目录）
    ├── resources/
    │   ├── css/
    │   │   └── styles.css     # 自定义样式（主要修改文件）
    │   ├── js/
    │   │   ├── userProfile.js
    │   │   └── password-policy.js
    │   └── img/
    │       ├── keycloak-logo-text.svg
    │       ├── keycloak-bg.png
    │       └── keycloak-bg-darken.svg
    ├── messages/
    │   ├── messages_en.properties    # 英文翻译
    │   └── messages_zh_CN.properties # 简体中文翻译（主要语言）
    ├── theme.properties       # 主题配置（PatternFly 类映射）
    ├── template.ftl           # 主页面模板
    ├── login.ftl              # 登录页面
    ├── login-username.ftl     # 用户名输入
    ├── login-password.ftl     # 密码输入
    ├── register.ftl           # 注册页面
    ├── phone-verification.ftl # 手机验证
    └── *.ftl                  # 其他 FreeMarker 模板
```

### 主题修改工作流（推荐）

**重要**: 修改主题文件**无需构建或重新编译**。

#### 方式 1: Docker Volume 挂载（推荐用于开发）

```yaml
# docker-compose.yml 示例
services:
  keycloak:
    volumes:
      - ./themes/src/main/resources/theme/vectorstory:/opt/keycloak/themes/vectorstory
```

修改流程：
1. 直接编辑 `themes/src/main/resources/theme/vectorstory/` 下的文件
2. 重启 Keycloak 容器：`docker-compose restart keycloak`
3. 或清除缓存：
   ```bash
   docker-compose exec keycloak /opt/keycloak/bin/kc.sh build
   docker-compose restart keycloak
   ```

#### 方式 2: 开发服务器实时加载

使用 `-Dresources` 参数启动，支持热重载（刷新浏览器即可）：
```bash
cd testsuite/utils
mvn exec:java -Pkeycloak-server -Dresources
```

### 开发服务器（实时编辑）

```bash
cd testsuite/utils

# 基本启动
mvn exec:java -Pkeycloak-server

# 从文件系统加载主题资源（允许实时编辑）
mvn exec:java -Pkeycloak-server -Dresources

# 指定自定义主题目录
mvn exec:java -Pkeycloak-server -Dkeycloak.theme.dir=/path/to/themes

# 导入测试 realm
mvn exec:java -Pkeycloak-server -Dimport=testrealm.json

# 配置端口
mvn exec:java -Pkeycloak-server -Dkeycloak.port=8081 -Dkeycloak.port.https=8443
```

### 默认管理员账户

开发服务器会自动创建：
- 用户名: `admin`
- 密码: `admin`

### 主题配置

主题继承自 `base` 主题并导入 `common/keycloak`，使用：
- PatternFly v5 CSS 框架
- 自定义 `css/styles.css`
- 深色模式支持 (`darkMode=true`)

## 主题技术架构 / Theme Architecture

### 工作目录

**唯一需要关注的目录**: `themes/src/main/resources/theme/vectorstory/`

其他 Keycloak 代码库目录（quarkus/、services/、model/ 等）**不需要修改**。

### 主题系统技术栈

主题使用以下技术：

1. **FreeMarker 模板引擎** (`.ftl` 文件)
   - 模板继承：`theme.properties` 中 `parent=base`
   - 变量插值：`${msg("key")}`、`${url.loginAction}`
   - 条件逻辑：`<#if>`, `<#list>`

2. **PatternFly v5 CSS 框架**
   - 组件类通过 `theme.properties` 映射（`kc*Class` 属性）
   - 预定义样式：`pf-v5-c-button`, `pf-v5-c-form`, `pf-v5-c-login` 等
   - 自定义覆盖：`resources/css/styles.css`

3. **国际化 (i18n)**
   - 翻译文件：`messages/messages_{locale}.properties`
   - 模板中引用：`${msg("keyName")}`
   - 当前支持：`zh_CN`（主要）、`en`

4. **资源文件**
   - CSS: `resources/css/styles.css`
   - JavaScript: `resources/js/*.js`
   - 图片: `resources/img/*.{svg,png,jpg}`

## 常见主题开发任务 / Common Theme Development Tasks

### 修改样式 (CSS)

**文件**: `themes/src/main/resources/theme/vectorstory/login/resources/css/styles.css`

```bash
# 1. 编辑 styles.css
vim themes/src/main/resources/theme/vectorstory/login/resources/css/styles.css

# 2. 应用更改
# - Docker: docker-compose restart keycloak
# - 开发服务器: 刷新浏览器
```

常见样式任务：
- 调整颜色、字体、间距
- 修改登录表单布局
- 自定义按钮和输入框样式
- 响应式设计调整

### 修改页面模板 (FreeMarker)

**常用模板文件**:
- `login.ftl` - 主登录页面
- `login-username.ftl` - 用户名输入步骤
- `login-password.ftl` - 密码输入步骤
- `register.ftl` - 注册页面
- `phone-verification.ftl` - 手机验证（自定义）
- `template.ftl` - 页面布局框架

**FreeMarker 常用语法**:
```ftl
<#-- 条件判断 -->
<#if message?has_content>
    ${message.summary}
</#if>

<#-- 循环 -->
<#list social.providers as p>
    ${p.displayName}
</#list>

<#-- 国际化 -->
${msg("loginTitle")}

<#-- URL 生成 -->
<form action="${url.loginAction}" method="post">
```

### 修改翻译文本

**文件**:
- `messages/messages_zh_CN.properties` - 简体中文（主要）
- `messages/messages_en.properties` - 英文

```properties
# 格式
loginTitle=登录到您的账户
doLogIn=登录
username=用户名
password=密码

# 在模板中使用
${msg("loginTitle")}  # 输出: 登录到您的账户
```

### 添加新图片/资源

```bash
# 1. 添加图片到目录
cp new-logo.svg themes/src/main/resources/theme/vectorstory/login/resources/img/

# 2. 在模板中引用
<img src="${url.resourcesPath}/img/new-logo.svg" alt="Logo" />

# 3. 在 CSS 中引用
background-image: url('../img/new-logo.svg');
```

### 调试主题

```bash
# 启动开发服务器（实时重载）
cd testsuite/utils
mvn exec:java -Pkeycloak-server -Dresources

# 访问地址
# http://localhost:8080/realms/master/account

# 在浏览器中：
# 1. 打开开发者工具 (F12)
# 2. 检查 HTML 结构和 CSS 类
# 3. 实时调整样式
# 4. 修改文件后刷新页面
```

### 测试不同场景

需要测试的主要流程：
1. **登录** - `login.ftl`, `login-username.ftl`, `login-password.ftl`
2. **注册** - `register.ftl`
3. **密码重置** - `login-reset-password.ftl`, `login-update-password.ftl`
4. **手机验证** - `phone-verification.ftl` (自定义功能)
5. **OTP/2FA** - `login-otp.ftl`, `login-config-totp.ftl`
6. **错误消息** - 测试各种错误状态
7. **国际化** - 切换语言测试翻译

## PatternFly 组件类参考 / PatternFly Class Reference

VectorStory 主题使用 PatternFly v5。所有组件类映射在 `theme.properties` 中定义。

### 常用类（来自 theme.properties）

```properties
# 表单相关
kcFormClass=pf-v5-c-form pf-v5-u-w-100
kcFormGroupClass=pf-v5-c-form__group
kcInputClass=pf-v5-c-form-control
kcLabelClass=pf-v5-c-form__label

# 按钮
kcButtonPrimaryClass=pf-v5-c-button pf-m-primary
kcButtonSecondaryClass=pf-v5-c-button pf-m-secondary
kcButtonBlockClass=pf-m-block

# 布局
kcLoginClass=pf-v5-c-login__main
kcLoginMainBody=pf-v5-c-login__main-body

# 警告/错误
kcAlertClass=pf-v5-c-alert pf-m-inline pf-v5-u-mb-md
kcInputErrorMessageClass=pf-v5-c-helper-text__item-text pf-m-error
```

### 在模板中使用

```ftl
<#-- 使用定义好的类 -->
<div class="${properties.kcFormGroupClass}">
    <label class="${properties.kcLabelClass}">${msg("username")}</label>
    <input type="text" class="${properties.kcInputClass}" />
</div>

<#-- 主要按钮 -->
<button class="${properties.kcButtonPrimaryClass}">
    ${msg("doLogIn")}
</button>
```

## 重要注意事项 / Important Notes

### 主题开发最佳实践

1. **不要修改 `base` 主题** - 只修改 `vectorstory` 主题
2. **保持向后兼容** - Keycloak 升级时主题可能需要调整
3. **测试所有流程** - 登录、注册、重置密码、OTP 等
4. **测试国际化** - 确保中英文翻译完整

### 构建性能

使用增量构建缓存加速构建：
```bash
# 单次启用
./mvnw -Dmaven.build.cache.enabled=true clean install

# 永久启用（添加到环境变量）
export MAVEN_OPTS="-Dmaven.build.cache.enabled=true"
```

### Java 版本

- **必须使用 JDK 17 或 JDK 21**
- 不支持更新的 JDK 版本
- 如果安装了多个 JDK，通过 `JAVA_HOME` 指定：
  ```bash
  JAVA_HOME=/path/to/jdk-17/ ./mvnw clean install
  ```

### Maven Wrapper

始终使用 `./mvnw` 而不是系统 Maven，以确保使用项目支持的 Maven 版本。

## 主题配置文件说明 / Theme Configuration

### theme.properties 关键配置

```properties
# 继承基础主题
parent=base
import=common/keycloak

# 样式文件
styles=css/styles.css  # 自定义样式
stylesCommon=vendor/patternfly-v5/patternfly.min.css  # PatternFly

# 功能开关
darkMode=true  # 启用深色模式支持
```

### 可用的模板变量

常见 FreeMarker 变量（在 `.ftl` 模板中使用）：

```ftl
${url.loginAction}           # 登录表单提交 URL
${url.resourcesPath}         # 资源文件路径（CSS/JS/图片）
${url.registrationUrl}       # 注册页面 URL

${realm.name}                # Realm 名称
${realm.displayName}         # Realm 显示名称

${msg("key")}               # 国际化消息
${properties.kcInputClass}   # theme.properties 中定义的类

${message.type}              # 消息类型（success, warning, error）
${message.summary}           # 消息内容

${login.username}            # 登录用户名
${isAppInitiatedAction}      # 是否是应用发起的操作
```

## 相关文档参考 / Documentation Reference

**主题开发相关**:
- [Keycloak 官方主题文档](https://www.keycloak.org/docs/latest/server_development/#_themes)
- [PatternFly v5 组件](https://www.patternfly.org/components/)
- [FreeMarker 模板语法](https://freemarker.apache.org/docs/dgui.html)

**项目文档** (仅在需要完整构建时参考):
- `docs/building.md` - Keycloak 构建说明
- `docs/tests.md` - 测试指南
- `README.md` - 项目概述

## VectorStory 主题特定功能

### 当前实现的页面

1. **登录流程**:
   - `login.ftl` - 统一登录页面
   - `login-username.ftl` - 用户名输入步骤
   - `login-password.ftl` - 密码输入步骤

2. **注册流程**:
   - `register.ftl` - 用户注册表单
   - `register-commons.ftl` - 注册公共组件

3. **手机验证** (自定义功能):
   - `phone-verification.ftl` - 手机号验证页面

4. **密码管理**:
   - `login-reset-password.ftl` - 忘记密码
   - `login-update-password.ftl` - 更新密码
   - `password-commons.ftl` - 密码公共组件
   - `password-validation.ftl` - 密码验证

5. **双因素认证**:
   - `login-otp.ftl` - OTP 验证码输入
   - `login-config-totp.ftl` - TOTP 配置
   - `login-recovery-authn-code-config.ftl` - 恢复码配置
   - `login-recovery-authn-code-input.ftl` - 恢复码输入

6. **WebAuthn 支持**:
   - `webauthn-authenticate.ftl` - WebAuthn 认证
   - `webauthn-register.ftl` - WebAuthn 注册
   - `webauthn-error.ftl` - WebAuthn 错误

7. **其他页面**:
   - `template.ftl` - 页面布局模板
   - `field.ftl` - 表单字段组件
   - `buttons.ftl` - 按钮组件
   - `footer.ftl` - 页脚
   - `social-providers.ftl` - 社交登录

### 自定义样式重点

在 `resources/css/styles.css` 中主要定制：
- 登录页面布局和配色
- 表单输入框样式
- 按钮和链接样式
- 响应式布局
- 深色模式适配

### 国际化支持

- 主要语言: 简体中文 (`messages_zh_CN.properties`)
- 次要语言: 英文 (`messages_en.properties`)
- 所有用户可见文本都应有对应的翻译 key

## 快速开始检查清单 / Quick Start Checklist

修改 VectorStory 主题前：

- [ ] 确认工作目录：`themes/src/main/resources/theme/vectorstory/`
- [ ] 了解主要修改文件：
  - [ ] `login/resources/css/styles.css` - 样式
  - [ ] `login/*.ftl` - 页面模板
  - [ ] `login/messages/*.properties` - 翻译
  - [ ] `login/theme.properties` - 配置
- [ ] 设置开发环境（Docker 或开发服务器）
- [ ] 知道如何应用更改（重启容器或刷新浏览器）
- [ ] 准备测试不同的登录场景
