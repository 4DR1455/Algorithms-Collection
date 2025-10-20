// HashTableSimple.hh
#pragma once

#include <vector>
#include <optional>
#include <functional>
#include <utility>
#include <cstddef>

// Classe plantilla d'una taula de hash senzilla.
// S'utilitza std::hash per calcular l'índex.
// Si la ranura està ocupada, insert torna false i no fa sondatges ni rehash.

template<typename K, typename V>
class HashTable {
public:
    explicit HashTable(std::size_t capacity)
        : cap(capacity), table(capacity), _size(0) {}

    // Retorna true si s'insereix; retorna false si la posició hash està ocupada.
    // Si la mateixa clau ja hi és, insert també retorna false (no actualitza).
    bool insert_or_update(const std::size_t idx, const V& value) {
        if (table[idx].has_value()) {
            table[idx] = value;
            return true;
        }
        table[idx] = value;
        _size++;
        return true;
    }

    // Retorna optional amb el valor si la clau és a la taula.
    std::optional<V> get(const std::size_t idx) const {
        if (!table[idx].has_value()) return std::nullopt;
        return table[idx];
    }

    // Retorna true si la clau existia i s'ha esborrat.
    bool erase(const std::size_t idx) {
        if (!table[idx].has_value()) return false;
        table[idx] = std::nullopt;
        _size--;
        return true;
    }

    int size() const {return _size;}
    std::size_t capacity() const { return cap; }

private:
    int _size;
    std::size_t cap;
    std::vector<std::optional<V>> table;
};
