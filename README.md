# my-dotai

> Claude Code 插件集合 - 简化开发工作流

## 概述

这是一个为 Claude Code 提供快捷命令的插件集合，帮助开发者提高工作效率，简化日常开发任务。

## 可用插件

### 🚀 Git Commit Plugin

自动 Git 提交工具，一键生成语义化提交信息。

**安装：**
```bash
npx shadcn@latest add https://raw.githubusercontent.com/YOUR_USERNAME/my-dotai/main/registry/git-commit.json
```

**使用：**
```bash
/git:commit
```

**功能：**
- 自动暂存所有修改
- 智能分析代码改动
- 生成符合 Conventional Commits 规范的提交信息
- 一键完成提交

[查看完整文档 →](./.claude-plugin/plugins/git-commit/README.md)

## 快速开始

### 方式一：使用 Marketplace 安装（推荐）

1. 添加插件市场：
```bash
/plugin marketplace add fushenyou/my-dotai
```

2. 安装插件：
```bash
/plugin install git-commit@my-dotai
```

3. 重启 Claude Code

4. 开始使用：
```bash
/git:commit
```

### 方式二：使用 Registry 安装

1. 安装插件：
```bash
npx shadcn@latest add https://raw.githubusercontent.com/fushenyou/my-dotai/main/registry/git-commit.json
```

2. 重启 Claude Code

3. 开始使用：
```bash
/git:commit
```

### 方式三：手动安装

1. 克隆仓库：
```bash
git clone https://github.com/fushenyou/my-dotai.git
cd my-dotai
```

2. 复制插件到你的项目：
```bash
# 在你的项目根目录
mkdir -p .claude-plugin/plugins
cp -r /path/to/my-dotai/.claude-plugin/plugins/* .claude-plugin/plugins/
```

3. 重启 Claude Code

## 插件开发

### 插件结构

```
.claude-plugin/
└── plugins/
    └── your-plugin/
        ├── README.md           # 插件文档
        └── commands/           # 命令定义
            └── your-command.md # /plugin:command
```

### 创建新插件

1. 创建插件目录：
```bash
mkdir -p .claude-plugin/plugins/your-plugin/commands
```

2. 创建命令文件 `commands/your-command.md`：
```markdown
---
description: 你的命令描述
---

你是一个专家助手...（命令指令）
```

3. 创建插件文档 `README.md`：
```markdown
# Your Plugin

> 插件简介
...
```

4. 重启 Claude Code
5. 使用 `/plugin:your-command` 调用命令

## 命令规范

### 命令文件格式

命令文件必须包含 frontmatter：

```markdown
---
description: 简短的命令描述
---

这里是命令的详细指令...
```

### 命令命名

- 格式：`/plugin-name:command-name`
- 示例：`/git:commit`, `/test:run`
- 使用小写字母和连字符

### 命令最佳实践

1. **清晰的描述**：frontmatter 中的 description 要简明扼要
2. **详细指令**：命令文件中包含完整的工作流程
3. **示例说明**：提供使用示例和注意事项
4. **错误处理**：说明常见问题和解决方案

## 贡献指南

欢迎贡献插件！

### 提交流

1. Fork 本仓库
2. 创建特性分支：`git checkout -b feature/your-plugin`
3. 提交改动：`git commit -m 'feat: 添加新插件'`
4. 推送分支：`git push origin feature/your-plugin`
5. 创建 Pull Request

### 插件要求

- 实用性：解决实际开发问题
- 文档完整：包含详细的使用说明
- 代码质量：命令指令清晰、准确
- 测试验证：在实际项目中测试通过

## 常见问题

### Q: 如何查看已安装的插件？

A: 查看项目的 `.claude-plugin/plugins/` 目录。

### Q: 命令不生效？

A: 确保已重启 Claude Code，并检查命令文件格式是否正确。

### Q: 如何卸载插件？

A: 删除对应的插件目录并重启 Claude Code。

### Q: 可以创建多个命令吗？

A: 可以！在 `commands/` 目录下创建多个 `.md` 文件即可。

## 路线图

- [ ] Git Commit Plugin ✅
- [ ] Test Runner Plugin
- [ ] Code Review Plugin
- [ ] Documentation Generator Plugin
- [ ] 更多实用插件...

## 许可证

MIT License

## 致谢

灵感来自 [udecode/dotai](https://github.com/udecode/dotai) 项目。
