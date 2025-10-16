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
    bool insert_or_update(const K& key, const V& value) {
        std::size_t idx = index_for(key);
        if (table[idx].has_value() && table[idx]->first != key) return false;
        if (table[idx].has_value() && table[idx]->first == key) {
            table[idx]->second = value;
            return true;
        }
        table[idx] = std::make_pair(key, value);
        _size++;
        return true;
    }

    // Retorna optional amb el valor si la clau és a la taula.
    std::optional<V> get(const K& key) const {
        std::size_t idx = index_for(key);
        if (!table[idx].has_value()) return std::nullopt;
        if (table[idx]->first == key) return table[idx]->second;
        return std::nullopt; // col·lisió no resolta
    }

    // Retorna true si la clau existia i s'ha esborrat.
    bool erase(const K& key) {
        std::size_t idx = index_for(key);
        if (!table[idx].has_value()) return false;
        if (table[idx]->first == key) {
            table[idx].reset();
            return true;
        }
        return false;
    }

    int size() const {return _size;}
    std::size_t capacity() const { return cap; }

private:
    std::size_t index_for(const K& key) const {
        return std::hash<K>{}(key) % cap;
    }

    int _size;
    std::size_t cap;
    std::vector<std::optional<std::pair<K, V>>> table;
};
