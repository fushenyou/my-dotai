#!/usr/bin/env node

/**
 * 前端框架和项目配置检测脚本
 * 自动识别项目使用的前端框架、UI 库、样式方案等
 */

const fs = require('fs');
const path = require('path');

/**
 * 读取 JSON 文件
 */
function readJson(filePath) {
  try {
    if (fs.existsSync(filePath)) {
      const content = fs.readFileSync(filePath, 'utf-8');
      return JSON.parse(content);
    }
  } catch (error) {
    // 忽略错误
  }
  return null;
}

/**
 * 检测前端框架
 */
function detectFramework(projectRoot = process.cwd()) {
  const packageJsonPath = path.join(projectRoot, 'package.json');
  const packageJson = readJson(packageJsonPath);

  if (!packageJson) {
    return { framework: 'unknown', isTypeScript: false };
  }

  const deps = {
    ...packageJson.dependencies,
    ...packageJson.devDependencies,
  };

  // 检测框架
  let framework = 'vanilla';
  let frameworkVersion = null;

  if (deps.react) {
    framework = 'react';
    frameworkVersion = deps.react;
  } else if (deps.vue) {
    framework = 'vue';
    frameworkVersion = deps.vue;
  } else if (deps.svelte) {
    framework = 'svelte';
    frameworkVersion = deps.svelte;
  } else if (deps['@angular/core']) {
    framework = 'angular';
    frameworkVersion = deps['@angular/core'];
  } else if (deps.solid-js) {
    framework = 'solid';
    frameworkVersion = deps.solid-js;
  } else if (deps['@builder.io/qwik']) {
    framework = 'qwik';
    frameworkVersion = deps['@builder.io/qwik'];
  }

  // 检测 TypeScript
  const isTypeScript = deps.typescript !== undefined ||
    fs.existsSync(path.join(projectRoot, 'tsconfig.json'));

  // 检测元框架（Next.js、Nuxt、SvelteKit 等）
  let metaFramework = null;
  if (deps.next && deps.react) {
    metaFramework = 'nextjs';
  } else if (deps.nuxt && deps.vue) {
    metaFramework = 'nuxt';
  } else if (deps['@sveltejs/kit'] && deps.svelte) {
    metaFramework = 'sveltekit';
  } else if (deps['@astrojs/core']) {
    metaFramework = 'astro';
  } else if (deps.remix && deps.react) {
    metaFramework = 'remix';
  }

  // 检测 UI 库
  const uiLibraries = [];
  if (deps['@mui/material']) uiLibraries.push('material-ui');
  if (deps['@chakra-ui/react']) uiLibraries.push('chakra-ui');
  if (deps['@radix-ui/react']) uiLibraries.push('radix-ui');
  if (deps.antd) uiLibraries.push('ant-design');
  if (deps['@geist-ui/react']) uiLibraries.push('geist-ui');
  if (deps['@mantine/core']) uiLibraries.push('mantine');

  // 检测 shadcn/ui（特殊处理，因为它不是 npm 包）
  const componentsPath = path.join(projectRoot, 'components');
  const uiPath = path.join(projectRoot, 'components/ui');
  if (fs.existsSync(uiPath)) {
    const uiFiles = fs.readdirSync(uiPath);
    if (uiFiles.length > 0) {
      uiLibraries.push('shadcn-ui');
    }
  }

  // 检测样式方案
  let styling = 'css';
  if (deps.tailwindcss) {
    styling = 'tailwind';
  } else if (deps['styled-components']) {
    styling = 'styled-components';
  } else if (deps.emotion) {
    styling = 'emotion';
  } else if (deps['@emotion/styled']) {
    styling = 'emotion';
  }

  // 检测路由
  let routing = null;
  if (deps['react-router']) {
    routing = 'react-router';
  } else if (deps['react-router-dom']) {
    routing = 'react-router-dom';
  } else if (deps['vue-router']) {
    routing = 'vue-router';
  } else if (deps['@angular/router']) {
    routing = 'angular-router';
  }

  // 检测状态管理
  const stateManagement = [];
  if (deps.redux || deps['@reduxjs/toolkit']) {
    stateManagement.push('redux');
  }
  if (deps.zustand) {
    stateManagement.push('zustand');
  }
  if (deps.jotai) {
    stateManagement.push('jotai');
  }
  if (deps.recoil) {
    stateManagement.push('recoil');
  }
  if (deps.pinia) {
    stateManagement.push('pinia');
  }
  if (deps.vuex) {
    stateManagement.push('vuex');
  }

  // 检测项目结构
  let projectStructure = 'default';
  const srcPath = path.join(projectRoot, 'src');
  const appPath = path.join(projectRoot, 'app');
  const pagesPath = path.join(projectRoot, 'pages');

  if (fs.existsSync(appPath) && metaFramework === 'nextjs') {
    projectStructure = 'nextjs-app';
  } else if (fs.existsSync(pagesPath) && metaFramework === 'nextjs') {
    projectStructure = 'nextjs-pages';
  } else if (fs.existsSync(srcPath)) {
    projectStructure = 'src-based';
  }

  return {
    framework,
    frameworkVersion,
    isTypeScript,
    metaFramework,
    uiLibraries,
    styling,
    routing,
    stateManagement,
    projectStructure,
    dependencies: Object.keys(deps),
  };
}

/**
 * 检测代码风格配置
 */
function detectCodeStyle(projectRoot = process.cwd()) {
  const result = {
    eslint: false,
    prettier: false,
    editorconfig: false,
  };

  // 检测 ESLint
  const eslintConfigs = [
    '.eslintrc.js',
    '.eslintrc.json',
    '.eslintrc.yml',
    '.eslintrc.yaml',
    'eslint.config.js',
  ];
  result.eslint = eslintConfigs.some((file) =>
    fs.existsSync(path.join(projectRoot, file))
  );

  // 检测 Prettier
  const prettierConfigs = [
    '.prettierrc',
    '.prettierrc.js',
    '.prettierrc.json',
    '.prettierrc.yml',
    '.prettierrc.yaml',
    'prettier.config.js',
  ];
  result.prettier = prettierConfigs.some((file) =>
    fs.existsSync(path.join(projectRoot, file))
  );

  // 检测 EditorConfig
  result.editorconfig = fs.existsSync(
    path.join(projectRoot, '.editorconfig')
  );

  return result;
}

/**
 * 主函数
 */
function main() {
  const args = process.argv.slice(2);
  const projectRoot = args[0] || process.cwd();

  const frameworkInfo = detectFramework(projectRoot);
  const codeStyle = detectCodeStyle(projectRoot);

  const result = {
    ...frameworkInfo,
    codeStyle,
  };

  // 输出 JSON 格式
  console.log(JSON.stringify(result, null, 2));
}

// 如果直接运行此脚本
if (require.main === module) {
  main();
}

module.exports = { detectFramework, detectCodeStyle };
