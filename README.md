# Nezha Agent Docker 镜像构建说明

## 项目简介
这是一个用于构建 Nezha Agent Docker 镜像的项目。该镜像基于 scratch（最小基础镜像），支持多架构（amd64/arm64）构建，体积极小且高度安全。

## 功能特点
- 基于 scratch 构建，镜像体积仅 ~7MB
- 支持 amd64 和 arm64 架构
- 哪吒客户端使用 v0 的最终版本 `v0.20.5`
- 支持环境变量配置
- 支持主机系统信息采集

## 环境变量
- `NEZHA_SERVER`: 面板服务器地址
- `NEZHA_PORT`: 面板服务器端口
- `NEZHA_KEY`: 客户端密钥
- `NEZHA_TLS`: 是否启用 TLS（可选值：--tls）

## 使用方法

### Docker 运行
```
docker run -d \
  --name nezha-agent \
  --restart unless-stopped \
  --privileged \
  --pid host \
  -v /:/host:ro \
  -v /proc:/host/proc:ro \
  -v /sys:/host/sys:ro \
  -v /etc:/host/etc:ro \
  -e NEZHA_SERVER=demo.nezha.org \
  -e NEZHA_PORT=5555 \
  -e NEZHA_KEY=your_key \
  -e NEZHA_TLS=--tls \
  fscarmen/nezha-agent:latest
```

### Docker Compose
```
services:
  nezha-agent:
    image: fscarmen/nezha-agent:latest
    container_name: nezha-agent
    privileged: true
    pid: host
    volumes:
      - /:/host:ro
      - /proc:/host/proc:ro
      - /sys:/host/sys:ro
      - /etc:/host/etc:ro
    environment:
      - NEZHA_SERVER=demo.nezha.org
      - NEZHA_PORT=5555
      - NEZHA_KEY=your_key
      - NEZHA_TLS=--tls
    restart: unless-stopped
```

## 构建说明
项目使用 GitHub Actions 自动构建，支持以下特性：
- 每日自动检查更新
- 多架构支持（amd64/arm64）
- 自动推送到 Docker Hub
- 使用 scratch 基础镜像，确保最小体积和安全（无额外依赖）

## 注意事项
1. 需要挂载主机目录以获取准确的系统信息
2. 建议使用 host 网络模式
3. 所有挂载目录均为只读模式，确保安全性
4. 环境变量必须正确配置，否则无法连接面板
5. scratch 镜像无 shell 或调试工具；若需调试，使用 verbose 模式或外部工具检查日志

## 贡献指南
欢迎提交 Issue 和 Pull Request