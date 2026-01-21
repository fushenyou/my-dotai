---
description: 从 Figma 设计稿生成代码
---

# /figma - Figma 设计稿转代码

## 用法

```
/figma <Figma 文件 URL 或节点 ID>
```

## 示例

### 基础用法
```
/figma https://www.figma.com/file/xxxxx/Design-System
```

### 指定目标路径
```
/figma https://www.figma.com/file/xxxxx/Component --path=src/components/Button
```

### 指定框架
```
/figma https://www.figma.com/file/xxxxx/Page --framework=react --ui=tailwind
```

## 工作流程

1. **解析输入**: 获取 Figma URL 和参数
2. **检测项目**: 分析项目的技术栈
3. **获取设计**: 调用 MCP 获取设计数据
4. **生成代码**: 根据规范生成组件代码
5. **创建文件**: 将代码写入适当位置
6. **验证结果**: 确认文件创建成功

## 参数说明

- `--path`: 指定生成文件的路径（可选）
- `--framework`: 强制指定框架（可选：react、vue、svelte、angular）
- `--ui`: 指定 UI 库（可选：tailwind、material-ui、ant-design）
- `--typescript`: 使用 TypeScript（默认自动检测）
- `--force`: 覆盖已存在的文件

## 注意事项

- 确保 Figma 文件有访问权限
- API Key 需要有足够的权限
- 建议在 Git 分支上使用，便于审查和修改
