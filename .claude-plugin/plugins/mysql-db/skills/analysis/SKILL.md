---
name: mysql-analysis
description: 数据分析可视化技能 - 分析数据并使用 ECharts + HTML + CSS 生成交互式可视化页面
---

# Data Visualization - 数据分析与可视化

## 概述

此技能对数据库中的数据进行分析，并生成包含 ECharts 图表的 HTML 可视化页面。提供数据洞察、趋势分析和业务建议。

## 何时使用

**使用此技能当**：
- 需要可视化数据分析结果
- 需要生成数据报表
- 需要发现数据趋势和模式
- 需要制作交互式图表
- 需要业务数据分析和建议

**跳过此技能当**：
- ❌ 只需要简单查询结果
- ❌ 数据量太小（< 10 条）
- ❌ 用户明确不需要可视化

## 执行流程

### 1. 理解分析需求

明确用户想要：
- 分析什么数据（表、字段）
- 分析维度（时间、类别、范围等）
- 可视化类型（趋势图、柱状图、饼图、散点图等）
- 时间范围（如适用）

### 2. 执行数据查询

基于需求生成 SQL：

```sql
-- 示例：按月统计销售额
SELECT
  DATE_FORMAT(order_date, '%Y-%m') AS month,
  COUNT(*) AS order_count,
  SUM(amount) AS total_amount,
  AVG(amount) AS avg_amount
FROM orders
WHERE order_date >= DATE_SUB(NOW(), INTERVAL 12 MONTH)
GROUP BY DATE_FORMAT(order_date, '%Y-%m')
ORDER BY month;
```

### 3. 分析数据

对查询结果进行：
- **趋势分析**：上升、下降、波动
- **异常检测**：突出异常值
- **分布分析**：数据分布情况
- **相关性分析**：字段之间的关系

### 4. 选择图表类型

根据数据类型选择：

| 数据类型 | 推荐图表 |
|---------|---------|
| 时间序列趋势 | 折线图、面积图 |
| 分类对比 | 柱状图、条形图 |
| 占比分布 | 饼图、环形图 |
| 多维关系 | 散点图、气泡图 |
| 地理分布 | 地图 |
| 层级结构 | 树图、矩形树图 |

### 5. 生成 HTML 页面

创建完整的 HTML 文件，包含：

```html
<!DOCTYPE html>
<html lang="zh-CN">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>数据分析报告 - {title}</title>
  <script src="https://cdn.jsdelivr.net/npm/echarts@5.4.3/dist/echarts.min.js"></script>
  <style>
    /* 响应式设计 */
    * { margin: 0; padding: 0; box-sizing: border-box; }
    body { font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif; }
    .container { max-width: 1400px; margin: 0 auto; padding: 20px; }
    .header { text-align: center; margin-bottom: 30px; }
    .header h1 { font-size: 32px; color: #333; margin-bottom: 10px; }
    .summary { display: grid; grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); gap: 20px; margin-bottom: 30px; }
    .card { background: #fff; border-radius: 8px; padding: 20px; box-shadow: 0 2px 8px rgba(0,0,0,0.1); }
    .card h3 { font-size: 14px; color: #666; margin-bottom: 10px; }
    .card .value { font-size: 28px; font-weight: bold; color: #333; }
    .card .trend { font-size: 14px; margin-top: 5px; }
    .card .trend.up { color: #52c41a; }
    .card .trend.down { color: #f5222d; }
    .chart { background: #fff; border-radius: 8px; padding: 20px; margin-bottom: 20px; box-shadow: 0 2px 8px rgba(0,0,0,0.1); }
    .chart h2 { font-size: 18px; color: #333; margin-bottom: 15px; }
    .chart-container { width: 100%; height: 400px; }
    .insights { background: #f0f7ff; border-left: 4px solid #1890ff; padding: 20px; border-radius: 4px; margin-top: 20px; }
    .insights h3 { color: #1890ff; margin-bottom: 10px; }
    .insights ul { list-style-position: inside; }
    .insights li { margin-bottom: 8px; line-height: 1.6; }
  </style>
</head>
<body>
  <div class="container">
    <div class="header">
      <h1>{报告标题}</h1>
      <p style="color: #666;">生成时间: {timestamp}</p>
    </div>

    <!-- 数据摘要 -->
    <div class="summary">
      <div class="card">
        <h3>总记录数</h3>
        <div class="value">{count}</div>
        <div class="trend up">↑ 12.5%</div>
      </div>
      <div class="card">
        <h3>总金额</h3>
        <div class="value">¥{amount}</div>
        <div class="trend up">↑ 8.3%</div>
      </div>
      <div class="card">
        <h3>平均值</h3>
        <div class="value">{avg}</div>
        <div class="trend">-</div>
      </div>
    </div>

    <!-- 图表区域 -->
    <div class="chart">
      <h2>趋势分析</h2>
      <div id="trendChart" class="chart-container"></div>
    </div>

    <div class="chart">
      <h2>分布分析</h2>
      <div id="distributionChart" class="chart-container"></div>
    </div>

    <!-- 洞察和建议 -->
    <div class="insights">
      <h3>💡 数据洞察与建议</h3>
      <ul>
        <li>{insight_1}</li>
        <li>{insight_2}</li>
        <li>{insight_3}</li>
      </ul>
    </div>
  </div>

  <script>
    // 趋势图
    const trendChart = echarts.init(document.getElementById('trendChart'));
    trendChart.setOption({
      title: { text: '{chart_title}' },
      tooltip: { trigger: 'axis' },
      legend: { data: ['系列1', '系列2'] },
      xAxis: { type: 'category', data: [{x_data}] },
      yAxis: { type: 'value' },
      series: [
        { name: '系列1', type: 'line', data: [{series1_data}], smooth: true },
        { name: '系列2', type: 'line', data: [{series2_data}], smooth: true }
      ]
    });

    // 分布图
    const distributionChart = echarts.init(document.getElementById('distributionChart'));
    distributionChart.setOption({
      title: { text: '{chart_title}' },
      tooltip: { trigger: 'item' },
      series: [{
        type: 'pie',
        radius: '70%',
        data: [{pie_data}]
      }]
    });

    // 响应式
    window.addEventListener('resize', () => {
      trendChart.resize();
      distributionChart.resize();
    });
  </script>
</body>
</html>
```

### 6. 提供分析见解

基于数据提供：

**数据洞察**：
- 发现的规律和趋势
- 异常点和特殊情况
- 关联性和相关性

**业务建议**：
- 优化建议
- 风险提示
- 行动建议

## 最佳实践

1. **数据采样**：大数据集先采样分析
2. **响应式设计**：确保图表在不同设备上都能正常显示
3. **交互性**：添加图表交互（缩放、筛选等）
4. **配色方案**：使用专业的配色方案
5. **性能优化**：大量数据使用数据聚合

## 输出格式

```markdown
✅ 数据分析完成

**分析范围**: {description}
**数据量**: {count} 条记录
**分析时间**: {timestamp}

**数据摘要**:
- 总量: {total}
- 平均值: {average}
- 最大值: {max}
- 最小值: {min}

**关键发现**:
1. {finding_1}
2. {finding_2}
3. {finding_3}

**可视化报告**:
已生成 HTML 文件: {file_path}

请在浏览器中打开查看完整的交互式图表。

**建议和行动**:
1. {suggestion_1}
2. {suggestion_2}
```

## 常见分析场景

### 1. 销售趋势分析

- 图表：月度销售额趋势（折线图）
- 维度：时间、订单量、金额
- 洞察：季节性、增长趋势

### 2. 用户行为分析

- 图表：用户活跃度分布（热力图）
- 维度：时间段、活跃度
- 洞察：高峰时段、活跃模式

### 3. 产品分类分析

- 图表：各类别占比（饼图）
- 维度：类别、数量、金额
- 洞察：主要收入来源、长尾产品

## 注意事项

⚠️ HTML 文件需要在浏览器中打开
⚠️ 大数据量会影响图表性能，建议聚合后显示
⚠️ 图表使用 CDN，需要网络连接
⚠️ 敏感数据脱敏处理
