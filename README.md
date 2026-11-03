# 自动记账弹窗分身选择修复

一个小型 root 脚本，解决 **vivo/iQOO 应用分身 + [自动记账](https://github.com/AutoAccountingOrg/AutoAccounting)** 环境下的一个烦人问题：微信付款后弹出"**OCR识别 / II·OCR识别**"双选择框，需要手动选一次才能记账。

原理：双选择框来自自动记账主应用（用户 0）和分身（用户 999）各自的弹窗入口组件。脚本只**禁用分身的 `FloatingWindowTriggerActivity` 组件**，让主应用统一接收账单弹窗——不再出现选择框，账单弹窗直达主应用。

## 作用范围

**只做一件事**：`pm disable --user 999 net.ankio.auto/.ui.activity.FloatingWindowTriggerActivity`

- ✅ 关闭自动记账**分身**的外部弹窗入口（付款选择框消失）
- ❌ 不关闭微信分身，不修改微信主身/分身的 LSPosed 采集作用域
- ❌ 不修改规则、已有账单、自动去重，不重启手机
- ⚠️ 副作用：自动记账分身内的**手动 OCR 快捷入口**可能受影响，需要手动 OCR 时请使用主应用
- 主用户 0 的同名组件保持启用

## 适用条件

| 条件 | 说明 |
| --- | --- |
| 机型 | 当前在 iQOO/vivo 实测（主用户 0，应用分身用户 999） |
| 包名 | 自动记账 `net.ankio.auto` |
| 权限 | 手机已获得 **root** |
| ⚠️ 注意 | **不是通用脚本**：其他手机的分身用户编号、包名可能不同，执行前需先核实（可用 `adb shell pm list users` 查看用户列表） |

## 使用

1. 将 `修复自动记账弹窗分身选择.sh` 复制到手机内部存储的 `Download` 文件夹
2. 在手机终端执行：

   ```bash
   su -c 'sh /sdcard/Download/修复自动记账弹窗分身选择.sh'
   ```

   也可使用支持 Root 执行 .sh 的手机文件管理器工具运行（普通文件管理器点击 .sh 不一定能执行）

3. 看到"已关闭自动记账分身的外部弹窗入口"即执行完成
4. 重复执行不会重复添加规则或账单，无需重启手机

## 恢复原设置

```bash
su -c 'sh /sdcard/Download/修复自动记账弹窗分身选择.sh --restore'
```

恢复后系统可能再次出现主应用/分身选择框。

## 脚本内容

脚本只有 20 行，核心就是两条 `pm` 命令，可直接审计：

```sh
# 修复（禁用分身弹窗入口）
pm disable --user 999 net.ankio.auto/.ui.activity.FloatingWindowTriggerActivity

# 恢复（还原为默认状态）
pm default-state --user 999 net.ankio.auto/.ui.activity.FloatingWindowTriggerActivity
```

## 当前状态

原手机已完成修复且验证正常（付款后不再出现选择框）。本脚本用于：

- 保存备份，需要时重新应用
- 卸载重装分身等导致设置重置后再次应用

## 免责声明

脚本依赖 `pm` 组件管理行为，仅供个人在已 root 的自有设备上使用；自动记账或系统大版本更新后行为可能变化，可用 `--restore` 随时还原。
