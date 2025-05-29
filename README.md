# 私人 dog 工具

这个仓库包含了用于发布私人 `dog` 工具的所有文件。通过这个私人 Homebrew tap，您可以轻松地安装和管理自定义的 `dog` 命令。

## 使用方法

### 添加 Tap

```bash
brew tap griffinsin/dog
```

这将自动访问 `griffinsin/homebrew-dog` 仓库。

### 安装工具

```bash
brew install griffinsin/dog/dog
```

## 可用命令

- `dog -v`: 显示工具版本信息
- `dog [command]`: 调用系统的 man 命令

## 开发指南

### 创建新的 Formula

1. 在 `Formula` 目录下创建新的 Ruby 文件，命名为 `<formula-name>.rb`
2. 使用 Homebrew Formula 标准格式编写文件
3. 提交并推送更改到仓库

### 测试 Formula

```bash
brew install --build-from-source ./Formula/<formula-name>.rb
```

## 许可证

[MIT](LICENSE)
