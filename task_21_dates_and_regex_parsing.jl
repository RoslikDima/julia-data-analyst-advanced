# ==============================================================================
# Репозиторий: julia-data-analyst-advanced
# Модуль 6. Продвинутая трансформация текста, дат и категориальных признаков
# Задача 21 (Модуль 6, Задача 1): Очистка регистра отгрузок, парсинг дат и извлечение дозировок
# Стандарт: julia-analytics (DateFormat precompile, Date components, Regex capture parsing)
# ==============================================================================

# Авторское решение (Dima Roslik):
using DataFrames, Dates, Chain

messy_shipments = DataFrame(
    shipment_date_str = ["12.01.2026", "25.02.2026", "14.04.2026", "03.05.2026", "19.06.2026"],
    raw_item = [
        "Цефтриаксон 1000 мг пор.",
        "Амоксиклав 500 мг таб.",
        "Цефтриаксон 1000 мг пор.",
        "Амоксиклав 250 мг таб.",
        "Омепразол 20 мг капс."
    ],
    packs = [4000, 3200, 6000, 1500, 5000]
)

fmt = DateFormat("dd.mm.yyyy")

cleaned_shipments_registry = @chain messy_shipments begin
    transform(:shipment_date_str => ByRow(s -> Date(s, fmt)) => :shipment_date)
    transform(
        :shipment_date => ByRow(quarterofyear) => :quarter,
        :raw_item => ByRow(s -> parse(Int, match(r"(\d+)\s*мг", s)[1])) => :dosage_mg
    )
    transform(
        [:packs, :dosage_mg] => ByRow((p, d) -> (p * d) / 1000.0) => :total_substance_g
    )
    sort(:shipment_date)
end

println("Очищенный реестр отгрузок с парсингом дат и дозировок:")
println(cleaned_shipments_registry)
