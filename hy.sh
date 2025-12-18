#!/bin/bash
CONFIG_FILE="$HOME/.config/hypr/hyprland.conf"

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
if command -v hyprctl &> /dev/null; then
    hyprctl --config "$CONFIG_FILE" syntax 2>&1
else
    echo "⚠️  hyprctl не найден, пропускаем проверку синтаксиса"
fi
echo ""

# Проверка путей к исполняемым файлам
echo "=== Проверка путей в exec командах ==="
grep -E "^exec|^bind.*exec" "$CONFIG_FILE" | while read line; do
    # Извлекаем команду после exec
    cmd=$(echo "$line" | sed -E 's/.*exec.*=[^,]*,\s*//' | awk '{print $1}')
    
    # Проверяем, существует ли команда
    if command -v "$cmd" &> /dev/null || [ -f "$cmd" ]; then
        echo "✅ $line"
    else
        echo "❌ Не найдена команда: $cmd"
        echo "   В строке: $line"
    fi
done