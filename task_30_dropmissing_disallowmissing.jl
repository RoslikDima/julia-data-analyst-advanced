# ==============================================================================
# Репозиторий: julia-data-analyst-advanced
# Модуль 8. Продвинутая аналитика пропусков (missing), коалесценция и импутация данных
# Задача 30 (Модуль 8, Задача 2): Очистка дефектных записей и фиксация строгой схемы данных
# Стандарт: julia-analytics (dropmissing! subset, disallowmissing! type tightening, coalesce.)
# ==============================================================================

# Авторское решение (Dima Roslik):
using DataFrames, Chain

raw_warehouse_stock = DataFrame(
    drug_id = [101, missing, 102, 103, 104, missing],
    drug_name = ["Цефтриаксон", "Неизвестно", "Амоксиклав", "Гепарин", "Омепразол", "Азитромицин"],
    stock_packs = [1500, 800, missing, 2200, 3400, 900],
    unit_price = [180.0, 210.0, 320.0, 250.0, 95.0, 140.0],
    note = ["Холодильник", missing, "Карантин", missing, "Основной зал", missing]
)

clean_warehouse_stock = @chain raw_warehouse_stock begin 
    dropmissing!([:drug_id, :stock_packs, :unit_price])
    disallowmissing!([:drug_id, :stock_packs, :unit_price])
    transform!(:note => (n -> coalesce.(n, "Без примечаний")) => :note)
    transform!(
        [:stock_packs, :unit_price] => ((s, p) -> s .* p) => :stock_value_rub
    )
    sort(:stock_value_rub, rev = true)
end

println("Очищенный реестр складских остатков со строгими типами:")
println(clean_warehouse_stock)
