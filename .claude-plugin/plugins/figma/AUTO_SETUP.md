# Figma 插件自动配置说明

## 自动配置流程

本插件实现了自动配置 MCP 的功能，安装和更新时自动设置 Figma API Key。

### 配置方式

1. **环境变量自动注入**
   - `.mcp.json` 使用 `${FIGMA_ACCESS_TOKEN}` 环境变量
   - 安装脚本自动将 API Key 写入 `~/.claude/settings.json`
   - Claude Code 启动时自动加载环境变量

2. **配置检测**
   - 每次会话开始时自动检测 API Key 是否配置
   - 未配置时显示友好的提示信息

### 安装步骤

#### 方式一：从 GitHub 克隆安装

```bash
# 1. 克隆仓库
git clone https://github.com/fushenyou/my-dotai.git

# 2. 进入插件目录
cd my-dotai/.claude-plugin/plugins/figma

# 3. 运行安装脚本（会提示输入 API Key）
bash install.sh

# 或者直接提供 API Key
bash install.sh figd_your_token_here
```

#### 方式二：从 Marketplace 安装

1. 在 Claude Code 中添加 Marketplace：
   ```
   https://github.com/fushenyou/my-dotai
   ```

2. 安装 "Figma 设计稿转代码" 插件

3. 运行安装脚本：
   ```bash
   cd ~/.claude/plugins/cache/my-dotai/figma
   bash install.sh figd_your_token_here
   ```

### 配置文件位置

API Key 会被保存到：
```json
// ~/.claude/settings.json
{
  "env": {
    "FIGMA_ACCESS_TOKEN": "figd_your_token_here"
  }
}
```

### 验证配置

```bash
# 检查配置
cat ~/.claude/settings.json | grep FIGMA_ACCESS_TOKEN

# 重启 Claude Code
# 测试命令
/figma https://www.figma.com/file/xxxxx/Your-Design
```

### 更新插件

当插件更新时：
- MCP 配置自动保留（使用环境变量）
- 无需重新配置 API Key
- 新版本自动应用配置

## 工作原理

### 1. hooks/hooks.json
```json
{
  "hooks": {
    "SessionStart": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "${CLAUDE_PLUGIN_ROOT}/scripts/configure-mcp.sh"
          }
        ]
      }
    ]
  }
}
```

每次 Claude Code 会话开始时，运行配置检测脚本。

### 2. .mcp.json
```json
{
  "mcpServers": {
    "figma": {
      "env": {
        "FIGMA_ACCESS_TOKEN": "${FIGMA_ACCESS_TOKEN}"
      }
    }
  }
}
```

使用环境变量占位符，从 Claude Code 的环境变量中读取。

### 3. install.sh
```bash
# 读取用户输入
read -p "请输入 Figma API Key: " FIGMA_API_KEY

# 使用 jq 更新 settings.json
jq --arg key "$FIGMA_API_KEY" '.env.FIGMA_ACCESS_TOKEN = $key' ~/.claude/settings.json
```

自动将 API Key 写入全局配置。

## 故障排除

### API Key 未生效

1. **检查环境变量**：
   ```bash
   echo $FIGMA_ACCESS_TOKEN
   ```

2. **检查 settings.json**：
   ```bash
   cat ~/.claude/settings.json | jq '.env.FIGMA_ACCESS_TOKEN'
   ```

3. **重新运行安装脚本**：
   ```bash
   cd /path/to/figma/plugin
   bash install.sh your_token
   ```

4. **重启 Claude Code**：
   完全退出并重新启动 Claude Code

### MCP 服务器未启动

1. 检查 Node.js 和 npm 是否安装
2. 检查网络连接（需要下载 figma-developer-mcp）
3. 查看 Claude Code 日志
