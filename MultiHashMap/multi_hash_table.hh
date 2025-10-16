#include<list>
#include"basic_hash_table.hh"

template<typename K, typename V>
class MultiHashTable {
public:
//s'ha d'arreglar el constructor
    MultiHashTable(std::size_t capacity) : _capacity(capacity), _size(0) {
        tables.push_back(HashTable<K,V>(_capacity));
    }
    void insert_or_update(const K& key, const V& value) {
        int i = 0;
        for (auto& t : tables) {
            int last_size = t.size();
            if (t.insert_or_update(key, value)) {
                if (last_size + 1 == t.size()) _size++;
                return;
            }
            i++;
        }
        tables.push_back(HashTable<K,V>(_capacity));
        tables.back().insert_or_update(key, value);
        _size++;
    }
    void erase(const K& key) {
        for (auto it = tables.begin(); it != tables.end(); ++it) {
            bool removed = it->erase(key);
            if (removed) {
                --_size;
                if (it->size() == 0) {
                    it=tables.erase(it);
                }
                return;
            }
        }
    }
    std::optional<V> find(const K& key) {
        for (auto& t : tables) {
            auto v = t.get(key);
            if (v != std::nullopt) return v;
        }
        return std::nullopt;
    }
private:
    std::list<HashTable<K,V>> tables;
    int _size;
    int _capacity;
};