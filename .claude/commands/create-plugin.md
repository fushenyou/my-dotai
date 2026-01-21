---
description: 创建新的 Claude Code 插件 - 引导式完成插件的完整创建流程
---

# /create-plugin - 创建新插件

**User Request:** $ARGUMENTS

## Context

用户想要创建一个新的 Claude Code 插件。这个命令将引导用户完成插件创建的完整流程，从收集信息到生成所有必要的文件。

## Goal

创建一个符合 Claude Code 插件规范的完整插件，包括：
- 标准的目录结构
- 完整的配置文件
- 示例代码和文档
- 验证和测试指南

## Process

### 第一步：收集插件信息

使用 `AskUserQuestion` 工具询问以下信息（可以分批问）：

1. **插件基本信息**：
   - 插件名称（小写，连字符分隔，如 "my-awesome-plugin"）
   - 插件描述（简短说明插件功能）
   - 作者信息（姓名、邮箱可选）
   - 主要功能列表

2. **插件组件**：
   - 需要哪些命令？（可选）
   - 需要哪些技能？（可选）
   - 需要钩子吗？（可选）
   - 需要 MCP 服务器集成吗？（可选）

3. **插件配置**：
   - 版本号（默认 "0.1.0"）
   - 关键词（帮助发现）
   - 许可证（默认 "MIT"）

### 第二步：创建目录结构

```bash
# 根据用户提供的插件名称创建目录
PLUGIN_NAME="{用户输入的插件名}"
mkdir -p .claude-plugin/plugins/$PLUGIN_NAME/.claude-plugin
mkdir -p .claude-plugin/plugins/$PLUGIN_NAME/commands
mkdir -p .claude-plugin/plugins/$PLUGIN_NAME/agents
mkdir -p .claude-plugin/plugins/$PLUGIN_NAME/skills
mkdir -p .claude-plugin/plugins/$PLUGIN_NAME/hooks
mkdir -p .claude-plugin/plugins/$PLUGIN_NAME/scripts
```

### 第三步：创建 plugin.json

**位置**：`.claude-plugin/plugins/{plugin-name}/.claude-plugin/plugin.json`

**模板**：
```json
{
  "name": "{plugin-name}",
  "version": "{version}",
  "description": "{description}",
  "author": {
    "name": "{author-name}",
    "email": "{author-email}"
  },
  "keywords": [{keywords}],
  "license": "{license}"
}
```

### 第四步：创建命令（如需要）

**位置**：`.claude-plugin/plugins/{plugin-name}/commands/{command-name}.md`

**模板**：
```markdown
---
description: {命令描述}
---

# {命令标题}

当用户使用此命令时，执行以下操作：

## 执行步骤

1. 步骤 1
2. 步骤 2
3. 步骤 3

## 重要提示

- 命令必须以 `/命令名` 格式调用
- 使用 $ARGUMENTS 获取用户输入
```

### 第五步：创建技能（如需要）

**位置**：`.claude-plugin/plugins/{plugin-name}/skills/{skill-name}/SKILL.md`

**模板**：
```markdown
---
name: {skill-name}
description: {技能描述}
---

# {技能标题}

## 概述

此技能的简要说明和核心原则。

## 何时使用

**使用此技能当**：
- 场景 1
- 场景 2

**跳过此技能当**：
- ❌ 不适用的场景

## 执行流程

1. 步骤 1
2. 步骤 2

## 最佳实践

- 实践 1
- 实践 2
```

### 第六步：创建钩子（如需要）

**位置**：`.claude-plugin/plugins/{plugin-name}/hooks/hooks.json`

**模板**：
```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Write|Edit",
        "hooks": [
          {
            "type": "command",
            "command": "${CLAUDE_PLUGIN_ROOT}/scripts/hook.sh"
          }
        ]
      }
    ]
  }
}
```

### 第七步：创建 README.md

**位置**：`.claude-plugin/plugins/{plugin-name}/README.md`

**必需内容**：
- 插件标题和描述
- 功能特性列表
- 安装说明
- 使用方法
- 配置说明（如需要）
- 示例代码

**模板**：
```markdown
# {插件名称}

{插件描述}

## 功能特性

- 特性 1
- 特性 2

## 安装

### 方式一：从 Marketplace 安装

在 Claude Code 中搜索并安装。

### 方式二：手动安装

\`\`\`bash
cd ~/.claude/plugins
git clone https://github.com/user/plugin.git
\`\`\`

## 使用方法

\`\`\`
/命令名
\`\`\`

## 配置

配置说明...

## 开发

项目结构...

## 许可证

{license}

## 作者

{author-name}
```

### 第八步：验证插件

**验证清单**：

- [ ] `.claude-plugin/plugin.json` 存在且格式正确
- [ ] `name` 字段使用 kebab-case
- [ ] `README.md` 存在且包含安装说明
- [ ] 所有目录在正确位置（不在 `.claude-plugin/` 内）
- [ ] 命令文件在 `commands/` 目录
- [ ] 技能文件在 `skills/技能名/SKILL.md`
- [ ] 钩子配置在 `hooks/hooks.json`
- [ ] 脚本文件有执行权限（如适用）

**测试命令**：
```bash
# 启动调试模式
claude --debug

# 检查输出中的插件加载信息
```

### 第九步：提供使用指南

告诉用户：

1. **安装插件**：
   ```bash
   # 如需要，启用插件
   # 插件会自动被发现和加载
   ```

2. **测试功能**：
   ```bash
   # 测试命令
   /命令名

   # 测试技能
   # 技能会自动触发
   ```

3. **调试技巧**：
   ```bash
   # 使用调试模式
   claude --debug
   ```

4. **下一步**：
   - 根据需求定制功能
   - 添加更多命令和技能
   - 编写完善的文档
   - 发布到 Marketplace（可选）

## 重要提示

**目录结构**：
- ⚠️ `.claude-plugin/` 只包含 `plugin.json`
- ⚠️ 其他目录（`commands/`、`skills/`、`hooks/`）在插件根目录，**不在** `.claude-plugin/` 内

**命名规范**：
- 插件名：小写字母 + 连字符（`my-plugin`）
- 命令名：小写字母 + 连字符（`create-pr`）
- 技能名：小写字母 + 连字符（`test-driven-development`）

**环境变量**：
- 在配置中使用 `${CLAUDE_PLUGIN_ROOT}` 引用插件根目录
- 确保路径无论安装位置如何都正确

**最佳实践**：
- 遵循语义化版本规范
- 提供完整的 README 文档
- 为命令和技能提供清晰的描述
- 使用调试模式验证插件加载

## 完成确认

创建完成后，向用户确认：

✅ **插件创建成功！**

**插件信息**：
- 名称：{plugin-name}
- 位置：.claude-plugin/plugins/{plugin-name}/
- 版本：{version}

**包含的组件**：
- Commands: {commands}
- Skills: {skills}
- Hooks: {hooks}

**下一步**：
1. 使用 `claude --debug` 验证插件加载
2. 测试所有功能
3. 根据需求定制和扩展
4. 编写完善的使用文档

**需要帮助？**
- 查看插件 README.md
- 参考 create-plugin 技能文档
- 查看 Claude Code 插件文档

---

**💡 提示**：这个命令使用 `create-plugin` 技能来完成插件创建。你可以随时请求使用该技能来创建新插件！
