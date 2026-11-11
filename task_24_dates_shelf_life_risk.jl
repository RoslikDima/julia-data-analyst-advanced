# ==============================================================================
# Репозиторий: julia-data-analyst-advanced
# Модуль 6. Продвинутая трансформация текста, дат и категориальных признаков
# Задача 24 (Модуль 6, Задача 4): Анализ срока годности (Shelf Life) и риска списания
# Стандарт: julia-analytics (Dates arithmetic, Dates.value, subset risk filtering)
# ==============================================================================

# Авторское решение (Dima Roslik):
using DataFrames, Dates, Chain

warehouse_lots = DataFrame(
    lot_number = ["L-101", "L-102", "L-103", "L-104", "L-105"],
    drug_name = ["Цефтриаксон", "Амоксиклав", "Гепарин", "Цефтриаксон", "Омепразол"],
    expiry_date_str = ["2026-07-15", "2026-12-01", "2026-06-25", "2027-02-10", "2026-08-10"],
    packs = [2500, 1800, 4000, 1200, 3100],
    price_rub = [180.0, 320.0, 250.0, 180.0, 95.0]
)

audit_date = Date("2026-06-01")
fmt = dateformat"yyyy-mm-dd"

expiring_lots_risk = @chain warehouse_lots begin
    transform(:expiry_date_str => ByRow(s -> Date(s, fmt)) => :expiry_date)
    transform(:expiry_date => ByRow(e -> Dates.value(e - audit_date)) => :days_to_expiry)
    transform(
        :days_to_expiry => ByRow(d -> d < 90) => :is_near_expiry,
        [:packs, :price_rub] => ByRow(*) => :risk_value_rub
    )
    subset(:is_near_expiry)
    sort(:days_to_expiry)
end

println("Партии препаратов в зоне риска истечения срока годности (<90 дней):")
println(expiring_lots_risk)
