# ==============================================================================
# Репозиторий: julia-data-analyst-advanced
# Модуль 3. Реляционные операции (Joins) и валидация связей
# Задача 09 (Модуль 3, Задача 1): Обогащение отгрузок справочником и маржинальность
# Стандарт: julia-analytics (leftjoin, sequential transform, ByRow margin, sort desc)
# ==============================================================================

# Авторское решение (Dima Roslik):
using DataFrames, Chain

warehouse_shipments = DataFrame(
    shipment_id = [101, 102, 103, 104, 105],
    drug_id = ["D01", "D02", "D01", "D03", "D02"],
    client = ["Аптека Вита", "ГКБ 40", "Планета Здоровья", "ГКБ 1", "Аптека Вита"],
    packs = [300, 1500, 450, 800, 600],
    selling_price = [450.0, 720.0, 460.0, 310.0, 710.0]
)

drug_catalog = DataFrame(
    drug_id = ["D01", "D02", "D03", "D04"],
    drug_name = ["Амоксиклав", "Цефтриаксон", "Омепразол", "Парацетамол"],
    pharma_group = ["Антибиотики", "Антибиотики", "ЖКТ", "Анальгетики"],
    cost_price = [310.0, 480.0, 180.0, 45.0]
)

shipments_margin_analysis = @chain warehouse_shipments begin 
    leftjoin(drug_catalog, on = :drug_id)
    transform(
        [:packs, :selling_price] => ByRow(*) => :revenue,
        [:packs, :cost_price] => ByRow(*) => :total_cost
    )
    transform(
        [:revenue, :total_cost] => ByRow(-) => :gross_profit,
        [:selling_price, :cost_price] => ByRow((s, c) -> round(((s - c) / s) * 100, digits = 1)) => :margin_pct
    )
    sort(:gross_profit, rev = true)
end    

println("Анализ маржинальности складских отгрузок:")
println(shipments_margin_analysis)
