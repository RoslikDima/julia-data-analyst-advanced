# ==============================================================================
# Репозиторий: julia-data-analyst-advanced
# Модуль 3. Реляционные операции (Joins) и валидация связей
# Задача 12 (Модуль 3, Задача 4): Защита от дубликатов и валидация связей validate
# Стандарт: julia-analytics (unique dedup, validate=(false, true), sequential transform)
# ==============================================================================

# Авторское решение (Dima Roslik):
using DataFrames, Chain

tender_orders = DataFrame(
    order_id = [1, 2, 3, 4],
    drug_id = ["D01", "D02", "D03", "D01"],
    packs = [500, 1000, 300, 800],
    contract_sum = [210000.0, 450000.0, 85000.0, 330000.0]
)

price_registry = DataFrame(
    drug_id = ["D01", "D02", "D02", "D03", "D03"],
    drug_name = ["Амоксиклав", "Цефтриаксон", "Цефтриаксон", "Омепразол", "Омепразол"],
    max_price = [460.0, 520.0, 520.0, 310.0, 310.0]
)

clean_price_registry = unique(price_registry, :drug_id)

tender_validation_analysis = @chain tender_orders begin 
    leftjoin(clean_price_registry, on = :drug_id, validate = (false, true))
    transform([:packs, :max_price] => ByRow(*) => :max_allowed_sum)
    transform([:max_allowed_sum, :contract_sum] => ByRow(-) => :savings)
    sort(:savings, rev = true)
end

println("Анализ экономии тендерных закупок относительно предельных цен:")
println(tender_validation_analysis)
