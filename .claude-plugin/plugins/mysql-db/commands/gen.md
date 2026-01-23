---
description: 基于数据库结构生成高性能、自动建立关联的 SQL 语句
---

# /mysql-db:gen - 生成 SQL 语句

当用户执行此命令时，使用 `mysql-gen` 技能来生成优化的 SQL 语句。

## 执行步骤

1. **验证结构缓存**
   - 检查是否已缓存数据库结构
   - 如果未缓存，提示用户先执行 `/mysql-db:schema`

2. **理解查询需求**
   - 分析用户想要的查询目标
   - 确定需要查询的表和字段
   - 理解筛选条件、排序、分组等需求

3. **设计查询方案**
   - 基于表关系确定 JOIN 类型
   - 选择合适的字段
   - 规划查询顺序

4. **生成 SQL 语句**
   - 编写优化的 SQL 
   - 添加必要的注释
   - 考虑性能优化

5. **提供性能建议**
   - 检查索引使用
   - 提供 EXPLAIN 分析
   - 给出优化建议

6. **多种方案对比**
   - 对于复杂查询，提供多种实现方案
   - 说明每种方案的优缺点
   - 推荐最佳方案

## 用户输入

通过 `$ARGUMENTS` 获取用户输入：
- 查询描述（自然语言）

## 示例

```bash
# 查询用户订单
/mysql-db:gen 查询最近30天的订单，包括用户信息和订单详情

# 统计分析
/mysql-db:gen 按月统计销售额，显示趋势

# 多表关联
/mysql-db:gen 查询购买次数最多的前10名用户
```

## 输出格式

```
✅ SQL 查询语句已生成

**查询目标**: 查询最近30天的订单及用户信息

**SQL 语句**:
```sql
-- 查询最近30天的订单及用户信息
SELECT
  o.id AS order_id,
  o.order_no,
  o.total_amount,
  o.status,
  o.created_at,
  u.username,
  u.email,
  COUNT(oi.id) AS item_count
FROM orders o
INNER JOIN users u ON o.user_id = u.id
LEFT JOIN order_items oi ON o.id = oi.order_id
WHERE o.created_at >= DATE_SUB(NOW(), INTERVAL 30 DAY)
  AND o.status IN (1, 2, 3)
GROUP BY o.id
ORDER BY o.created_at DESC
LIMIT 50;
```

**执行计划**:
- 类型： SIMPLE
- 表： orders → users → order_items
- 索引： idx_created_at, PRIMARY, idx_user_id
- 扫描行数： 约 1,234 行
- 成本： 较低

**性能建议**:
✅ orders.created_at 有索引，查询高效
✅ 使用 INNER JOIN 减少数据量
✅ LIMIT 限制结果集，避免返回过多数据
⚠️ 建议为 orders.status 添加索引以提升筛选性能

**如果需要执行此查询，请确认后运行**
```

## SQL 生成原则

1. **字段选择**
   - ✅ 明确列出需要的字段
   - ❌ 避免 SELECT *
   - ✅ 使用表别名避免冲突

2. **JOIN 优化**
   - ✅ 优先使用 INNER JOIN
   - ✅ JOIN 条件使用索引字段
   - ✅ 小表驱动大表

3. **WHERE 条件**
   - ✅ 索引字段放在左边
   - ✅ 避免 OR，使用 UNION 或 IN
   - ✅ 避免 LIKE '%xxx' 开头

4. **排序和分页**
   - ✅ ORDER BY 字段有索引
   - ✅ 大数据集必须分页
   - ✅ 避免 OFFSET 过大

## 常见查询模式

### 统计查询
```sql
SELECT
  DATE(created_at) AS date,
  COUNT(*) AS count,
  SUM(amount) AS total
FROM orders
WHERE created_at >= DATE_SUB(NOW(), INTERVAL 30 DAY)
GROUP BY DATE(created_at)
ORDER BY date;
```

### 排名查询
```sql
SELECT
  u.username,
  COUNT(o.id) AS order_count,
  SUM(o.total_amount) AS total_amount
FROM users u
LEFT JOIN orders o ON u.id = o.user_id
GROUP BY u.id
ORDER BY order_count DESC
LIMIT 10;
```

### 存在性检查
```sql
-- 推荐使用 EXISTS
SELECT * FROM users u
WHERE EXISTS (
  SELECT 1 FROM orders o
  WHERE o.user_id = u.id
  AND o.status = 1
);
```

## 重要提示

- ⚠️ 生成的 SQL 需要用户确认后才能执行
- ⚠️ 建议先使用 EXPLAIN 查看执行计划
- ⚠️ 生产环境执行前先在测试环境验证
- ⚠️ 注意 SQL 注入，使用参数化查询
