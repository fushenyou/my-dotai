# Git Commit Plugin

> 简化 Git 提交流程，自动生成语义化提交信息

## 概述

Git Commit 插件提供了一键式 Git 提交功能，自动分析修改内容并生成符合 Conventional Commits 规范的提交信息。让 Git 提交变得简单、规范、高效。

## 功能特性

### 🚀 一键提交
- 自动暂存所有修改（`git add .`）
- 智能分析修改内容
- 生成语义化提交信息
- 完成提交

### 📝 智能提交信息
基于 Conventional Commits 规范：
- `feat`: 新功能
- `fix`: Bug 修复
- `refactor`: 代码重构
- `docs`: 文档更新
- `style`: 格式调整
- `test`: 测试相关
- `chore`: 其他修改

### 🔍 深度分析
- 识别修改类型和范围
- 统计代码改动行数
- 提取主要改动模块
- 生成简洁准确的描述

## 安装

### 方式一：使用 shadcn registry（推荐）

```bash
npx shadcn@latest add https://raw.githubusercontent.com/fushenyou/my-dotai/main/registry/git-commit.json
```

然后重启 Claude Code。

### 方式二：手动安装

1. 将插件目录复制到你的项目：
```bash
# 在你的项目根目录
mkdir -p .claude-plugin/plugins/git-commit
cp -r /path/to/my-dotai/.claude-plugin/plugins/git-commit/* .claude-plugin/plugins/git-commit/
```

2. 重启 Claude Code

## 使用

### 基本使用

在 Claude Code 中执行：

```bash
/git:commit
```

插件会自动：
1. 暂存所有修改
2. 分析改动内容
3. 生成提交信息
4. 完成提交

### 工作流程

```
修改代码 → /git:commit → 自动生成提交信息 → 提交完成
```

## 示例

### 场景 1：新功能

```
修改：新增用户登录页面
/git:commit
→ feat(auth): 新增用户登录页面
```

### 场景 2：Bug 修复

```
修改：修复表单验证错误
/git:commit
→ fix: 修复表单验证逻辑错误
```

### 场景 3：文档更新

```
修改：更新 README.md
/git:commit
→ docs: 更新项目使用说明
```

### 场景 4：代码重构

```
修改：提取公共工具函数
/git:commit
→ refactor(utils): 提取公共校验函数
```

## 提交信息格式

插件生成的提交信息遵循以下格式：

```
type(scope): description

# 详细描述（可选）
# - 改动详情
# - 影响范围
# - 其他说明
```

### 提交类型说明

| 类型 | 说明 | 示例 |
|------|------|------|
| `feat` | 新功能 | feat: 新增用户头像上传功能 |
| `fix` | Bug 修复 | fix: 修复导航栏响应式问题 |
| `refactor` | 重构 | refactor: 重构数据获取逻辑 |
| `docs` | 文档 | docs: 更新 API 接口文档 |
| `style` | 格式 | style: 统一代码缩进格式 |
| `test` | 测试 | test: 添加用户服务单元测试 |
| `chore` | 其他 | chore: 升级依赖版本 |

## 最佳实践

1. **原子化提交**：一次提交只做一件事
2. **及时提交**：完成一个小功能就提交
3. **清晰描述**：提交信息要准确反映改动内容
4. **检查敏感信息**：提交前确认没有 API 密钥等敏感信息

## 与其他工具集成

### Git Hooks
插件不会与 pre-commit hooks 冲突，可以配合使用：
- Husky
- lint-staged
- Commitlint

### 分支策略
推荐结合分支命名规范使用：
- `feature/xxx` - 新功能分支
- `fix/xxx` - Bug 修复分支
- `refactor/xxx` - 重构分支

## 故障排除

### 没有修改可提交
```
错误：没有需要提交的修改
解决：先进行代码修改，再调用 /git:commit
```

### 不在 Git 仓库中
```
错误：Not a git repository
解决：先初始化 Git 仓库：git init
```

### 提交信息不准确
```
问题：生成的提交信息不符合预期
解决：可以修改提交信息：
git commit --amend
```

## 贡献

欢迎贡献！你可以：
- 报告 Bug
- 提出新功能建议
- 提交 Pull Request

## 许可证

MIT License

## 作者

Created with ❤️ for Claude Code community
