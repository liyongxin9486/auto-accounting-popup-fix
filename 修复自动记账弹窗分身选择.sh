#!/system/bin/sh
# 仅适用于当前 vivo/iQOO：自动记账主应用 user 0，分身 user 999。
# 只切换分身的弹窗入口，不修改规则、账单、微信或 LSPosed 作用域。
set -eu
MODE="${1:-fix}"
case "$MODE" in fix|--restore) ;; *) echo '用法：sh 本脚本 [--restore]'; exit 2;; esac
if [ "$(id -u)" != 0 ]; then
  echo '请使用 Root 运行本脚本。'
  exit 1
fi
TARGET='net.ankio.auto/.ui.activity.FloatingWindowTriggerActivity'
if [ "$MODE" = '--restore' ]; then
  pm default-state --user 999 "$TARGET"
  echo '已恢复分身弹窗入口的默认状态，系统可能再次弹出分身选择框。'
else
  pm disable --user 999 "$TARGET"
  echo '已关闭自动记账分身的外部弹窗入口，由主应用接收账单弹窗。'
  echo '微信分身及其 LSPosed 采集作用域没有改变，无需重启手机。'
fi
