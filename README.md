# ass-ubuntu

本仓库用于集中管理 **ass** 与 **pingxiaozhu** 两个项目的 **Ubuntu 服务器相关配置**（目前以 Nginx 配置为主）。

## 关联项目

- **ass**：`D:\workspace\GitHub\ass`
- **pingxiaozhu**：`D:\workspace\GitHub\pingxiaozhu`

## 目录说明

- **`nginx/`**：Nginx 站点配置
  - `nginx/sites-available/`：站点配置文件（示例/实际部署使用的 server 配置）
  - `nginx/sites-enabled/`：预留给启用的软链接目录（按 Ubuntu/Nginx 常见约定）

## 使用方式（约定）

本仓库只管理配置文件本身；具体在服务器上的启用/链接/重载流程，按实际环境执行。

