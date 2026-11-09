# ==============================================================================
# Репозиторий: julia-data-analyst-advanced
# Модуль 3. Реляционные операции (Joins) и валидация связей
# Задача 10 (Модуль 3, Задача 2): Аудит несогласованных отгрузок и неактивных SKU
# Стандарт: julia-analytics (antijoin data quality audit, key integrity verification)
# ==============================================================================

# Авторское решение (Dima Roslik):
using DataFrames, Chain

sales_transactions = DataFrame(
    tx_id = [501, 502, 503, 504, 505, 506],
    drug_code = ["SKU_10", "SKU_20", "SKU_99", "SKU_10", "SKU_88", "SKU_30"],
    distributor = ["Протек", "Катрен", "Фармкомплект", "Протек", "Пульс", "Катрен"],
    packs = [1200, 800, 300, 1500, 450, 600]
)

master_catalog = DataFrame(
    drug_code = ["SKU_10", "SKU_20", "SKU_30", "SKU_40", "SKU_50"],
    drug_name = ["Азитромицин", "Амоксиклав", "Бисопролол", "Валсартан", "Дротаверин"],
    base_price = [280.0, 450.0, 160.0, 520.0, 95.0]
)

unmatched_sales = @chain sales_transactions begin 
    antijoin(master_catalog, on = :drug_code)
    sort(:tx_id)
end

inactive_drugs = @chain master_catalog begin 
    antijoin(sales_transactions, on = :drug_code)
    sort(:drug_name)
end

println("Транзакции с незарегистрированными SKU (ошибки ввода/новые препараты):")
println(unmatched_sales)

println("
Препараты из каталога без фактических отгрузок:")
println(inactive_drugs)
