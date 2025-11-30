# 第一阶段：构建
FROM alpine:3.19 AS builder

# 设置构建参数
ARG TARGETOS
ARG TARGETARCH

# 安装构建工具，下载并解压 nezha-agent（支持多架构）
RUN apk add --no-cache wget unzip ca-certificates && \
    update-ca-certificates && \
    wget -O nezha-agent.zip https://github.com/nezhahq/agent/releases/download/v0.20.5/nezha-agent_linux_${TARGETARCH}.zip && \
    unzip nezha-agent.zip -d /tmp && \
    chmod +x /tmp/nezha-agent

# 第二阶段：运行 (scratch)
FROM scratch

# 从构建阶段复制证书和nezha-agent二进制文件
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=builder /tmp/nezha-agent /nezha-agent

# 设置入口点
ENTRYPOINT ["/nezha-agent"]