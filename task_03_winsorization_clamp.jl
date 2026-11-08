# ==============================================================================
# Репозиторий: julia-data-analyst-advanced
# Модуль 1. Векторная алгебра, статистика и фильтрация выбросов
# Задача 03 (Модуль 1, Задача 3): Двусторонняя винзоризация аптечных чеков через clamp
# Стандарт: julia-analytics (quantile P05/P95, clamp via ByRow, is_capped flag)
# ==============================================================================

# Авторское решение (Dima Roslik):
using DataFrames, Chain, Statistics

pharmacy_receipts = DataFrame(
    receipt_id = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10],
    manager = ["Иванов", "Иванов", "Петров", "Петров", "Иванов", "Сидоров", "Сидоров", "Иванов", "Петров", "Сидоров"],
    receipt_amount = [12.0, 450.0, 520.0, 610.0, 480.0, 550.0, 590.0, 630.0, 490.0, 15400.0]
)

p05 = quantile(pharmacy_receipts.receipt_amount, 0.05)
p95 = quantile(pharmacy_receipts.receipt_amount, 0.95)

winsorized_sales = @chain pharmacy_receipts begin
    transform(
        :receipt_amount => ByRow(a -> clamp(a, p05, p95)) => :winsorized_amount
    )
    transform(
        [:receipt_amount, :winsorized_amount] => ByRow((r, w) -> r != w) => :is_capped
    )
    sort(:receipt_amount)
end

println("Реестр чеков после двусторонней винзоризации:")
println(winsorized_sales)
