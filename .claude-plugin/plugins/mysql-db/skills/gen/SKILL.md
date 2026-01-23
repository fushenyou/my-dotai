---
name: mysql-gen
description: SQL 生成优化技能 - 基于数据库结构生成高性能、自动建立关联的 SQL 语句
---

# SQL Generation - SQL 生成优化

## 概述

此技能基于已缓存的数据库结构，生成优化的 SQL 查询语句。它会自动分析表关系、选择合适的 JOIN 类型、添加必要的索引建议，并确保查询性能最优。

## 何时使用

**使用此技能当**：
- 需要生成复杂的查询语句
- 需要多表关联查询
- 需要优化现有查询性能
- 不确定如何编写高效的 JOIN
- 需要聚合统计数据

**跳过此技能当**：
- ❌ 数据库结构未缓存（先使用 schema-analysis）
- ❌ 只需要简单的单表查询
- ❌ 查询需求不明确

## 执行流程

### 1. 理解用户需求

分析用户想要查询的数据：
- 目标数据：需要哪些字段
- 筛选条件：WHERE 条件
- 排序要求：ORDER BY
- 分组需求：GROUP BY / HAVING
- 分页需求：LIMIT / OFFSET

### 2. 检查结构缓存

```
从记忆中获取数据库结构
如果不存在或过期，提示用户先运行 /mysql-db:schema
```

### 3. 设计查询方案

基于结构分析：

**确定表关系**：
- 识别主表和关联表
- 确定 JOIN 类型（INNER/LEFT/RIGHT）
- 规划 JOIN 顺序

**优化字段选择**：
- 避免 SELECT *
- 只选择需要的字段
- 处理字段冲突（表名.字段名）

**添加索引建议**：
```
如果 WHERE 条件包含字段，检查是否有索引
如果 JOIN 字段没有索引，建议创建
如果 ORDER BY 字段没有索引，建议创建
```

### 4. 生成 SQL 语句

```sql
-- 查询说明
SELECT
  t1.column1,
  t1.column2,
  t2.column3
FROM table1 AS t1
INNER JOIN table2 AS t2
  ON t1.id = t2.table1_id
WHERE t1.status = 'active'
  AND t2.created_at >= '2024-01-01'
ORDER BY t1.created_at DESC
LIMIT 20;

-- 性能建议
-- 1. 确保 t2.table1_id 有索引
-- 2. 考虑为 t1.status 添加索引
-- 3. 如果数据量大，考虑分页优化
```

### 5. 提供多种方案

对于复杂查询，提供多个方案：

```markdown
**方案 1: 标准关联查询**
{SQL with JOINs}
- 优点: 一次性获取数据
- 缺点: 大数据量时可能较慢

**方案 2: 子查询方式**
{SQL with subqueries}
- 优点: 逻辑清晰
- 缺点: 可能需要多次查询

**方案 3: 分步查询（推荐用于大数据量）**
{Multiple queries}
- 优点: 可控、可缓存
- 缺点: 需要多次往返
```

## 最佳实践

1. **使用参数化查询**：防止 SQL 注入
2. **避免 N+1 问题**：合理使用 JOIN
3. **索引优先**：确保 JOIN 和 WHERE 字段有索引
4. **分页处理**：大数据集必须分页
5. **选择合适字段**：避免 SELECT *

## 性能优化检查清单

生成 SQL 时检查：

- [ ] WHERE 条件字段有索引
- [ ] JOIN 字段有索引
- [ ] ORDER BY 字段有索引（或包含在索引中）
- [ ] 避免 SELECT *
- [ ] 使用 LIMIT 限制结果集
- [ ] 避免在索引列上使用函数
- [ ] 避免 LIKE '%xxx' 开头模糊查询
- [ ] 合理使用 EXISTS 代替 IN（子查询）

## 输出格式

```markdown
✅ SQL 查询语句已生成

**查询目标**: {description}

**SQL 语句**:
```sql
{generated_sql}
```

**执行计划分析**:
{使用 EXPLAIN 分析查询计划}

**性能建议**:
1. {suggestion_1}
2. {suggestion_2}

**如果需要执行，请确认后运行**
```

## 常见场景

### 1. 用户列表 + 订单统计

```sql
SELECT
  u.id,
  u.username,
  u.email,
  COUNT(o.id) AS order_count,
  SUM(o.amount) AS total_amount
FROM users u
LEFT JOIN orders o ON u.id = o.user_id
WHERE u.status = 'active'
GROUP BY u.id
ORDER BY total_amount DESC;
```

### 2. 商品分类 + 库存

```sql
SELECT
  c.name AS category_name,
  p.name AS product_name,
  p.stock,
  p.price
FROM categories c
INNER JOIN products p ON c.id = p.category_id
WHERE p.stock > 0
ORDER BY c.sort_order, p.created_at;
```

## 注意事项

⚠️ 生成的 SQL 需要用户确认后才能执行
⚠️ 建议先使用 EXPLAIN 查看执行计划
⚠️ 生产环境执行前先在测试环境验证
