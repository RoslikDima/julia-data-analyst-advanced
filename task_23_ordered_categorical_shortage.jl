# ==============================================================================
# Репозиторий: julia-data-analyst-advanced
# Модуль 6. Продвинутая трансформация текста, дат и категориальных признаков
# Задача 23 (Модуль 6, Задача 3): Мониторинг дефектуры и приоритизация поставок
# Стандарт: julia-analytics (ordered categorical levels, custom hierarchical sorting)
# ==============================================================================

# Авторское решение (Dima Roslik):
using DataFrames, Chain, CategoricalArrays

drug_shortage_registry = DataFrame(
    drug_name = ["Цефтриаксон", "Омепразол", "Амоксиклав", "Гепарин", "Азитромицин"],
    shortage_level = ["Высокий", "Низкий", "Критический", "Высокий", "Средний"],
    shortage_packs = [3500, 800, 5200, 4100, 1900]
)

priority_levels = ["Низкий", "Средний", "Высокий", "Критический"]

prioritized_shortage_plan = @chain drug_shortage_registry begin 
    transform(
        :shortage_level => (s -> categorical(s, levels = priority_levels, ordered = true)) => :shortage_level
    )
    sort([:shortage_level, :shortage_packs], rev = true)
end

println("Приоритизированный план устранения дефектуры:")
println(prioritized_shortage_plan)
