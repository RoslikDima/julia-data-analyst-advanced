# ==============================================================================
# Репозиторий: julia-data-analyst-advanced
# Модуль 8. Продвинутая аналитика пропусков (missing), коалесценция и импутация данных
# Задача 32 (Модуль 8, Задача 4): Комплексный аудит качества (describe) и защита от нулей
# Стандарт: julia-analytics (describe audit, batch coalesce., disallowmissing!, safe ifelse. division)
# ==============================================================================

# Авторское решение (Dima Roslik):
using DataFrames, Chain

contract_executions = DataFrame(
    contract_id = ["C-01", "C-02", "C-03", "C-04", "C-05"],
    region = ["Центр", missing, "Юг", "Сибирь", missing],
    contract_sum = [500_000.0, 320_000.0, missing, 450_000.0, 0.0],
    shipped_packs = [2000, 0, 1500, missing, 0]
)

println("Аудит исходной таблицы:")
println(describe(contract_executions, :nmissing, :eltype))

clean_contracts = @chain contract_executions begin 
    transform!(
        :region => (r -> coalesce.(r, "Не указан")) => :region,
        :contract_sum => (s -> coalesce.(s, 0.0)) => :contract_sum,
        :shipped_packs => (p -> coalesce.(p, 0)) => :shipped_packs
    )
    disallowmissing!([:region, :contract_sum, :shipped_packs])
    transform!(
        [:contract_sum, :shipped_packs] => ((s, p) -> ifelse.(p .> 0, s ./ p, 0.0)) => :actual_pack_price
    )
    sort(:contract_sum, rev = true)
end

println("\nОчищенная витрина исполнения контрактов:")
println(clean_contracts)

println("\nАудит конечной таблицы:")
println(describe(clean_contracts, :nmissing, :eltype))
