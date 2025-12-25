#!/usr/bin/env bash
CONFIG_FILE="hyprland/hyprland.conf"

echo "=== Проверка конфигурации Hyprland ==="
echo "Файл: $CONFIG_FILE"
echo ""

# Проверка существования файла
if [ ! -f "$CONFIG_FILE" ]; then
    echo "❌ Файл конфигурации не найден!"
    exit 1
fi

echo "✅ Файл найден"
echo ""

# Проверка основных секций
echo "=== Проверка основных секций ==="
for section in "monitor" "input" "general" "decoration" "animations" "dwindle" "master"; do
    if grep -q "^$section {" "$CONFIG_FILE"; then
        echo "✅ Секция [$section] найдена"
    else
        echo "⚠️  Секция [$section] отсутствует (не обязательно критично)"
    fi
done
echo ""

# Проверка синтаксиса
echo "=== Проверка синтаксиса ==="
echo "⚠️  hyprctl не имеет команды для проверки синтаксиса, пропускаем."
echo ""

# Проверка путей к исполняемым файлам
echo "=== Проверка путей в exec командах ==="
grep -E "exec-once|bind.*exec" "$CONFIG_FILE" | while read -r line; do
    # Извлекаем команду после exec
    cmd=$(echo "$line" | sed -E 's/.*exec.*=[^,]*,\s*//' | sed -E 's/.*exec-once\s*=\s*//' | awk '{print $1}')

    # expand variables
    if [[ $cmd == "\$terminal" ]]; then
        cmd="alacritty"
    fi
    if [[ $cmd == "\$fileManager" ]]; then
        cmd="dolphin"
    fi
    if [[ $cmd == "\$menu" ]]; then
        cmd="wofi"
    fi
    if [[ $cmd == "\$scr" ]]; then
        cmd="/home/iershov/.config/waybar/scripts" # Assuming this path is correct
    fi

    # Проверяем, существует ли команда
    if command -v "$cmd" &> /dev/null || [ -f "$cmd" ] || [ -d "$cmd" ]; then
        echo "✅ $line"
    else
        echo "❌ Не найдена команда: $cmd"
        echo "   В строке: $line"
    fi
done
