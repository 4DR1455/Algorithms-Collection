#include<vector>
#include"basic_hash_table.hh"

template<typename K, typename V>
class MultiHashTable {
public:
//s'ha d'arreglar el constructor
    MultiHashTable(std::size_t capacity) : _capacity(capacity), _size(0) {
        expand_tables(_capacity - 1);
    }
    void insert_or_update(const K& key, const V& value) {
        std::size_t idx = index_for(key);
        int n_h_m = idx/_capacity;
        if (n_h_m >= tables.size()) expand_tables(n_h_m);
        tables[n_h_m].insert_or_update(idx%_capacity, value);
        _size++;
    }
    void erase(const K& key) {
        std::size_t idx = index_for(key);
        tables[idx/_capacity].erase(idx%_capacity);
        _size--;
    }
    std::optional<V> find(const K& key) {
        std::size_t idx = index_for(key);
        std::optional<V> r = tables[idx/_capacity].get(idx%_capacity);
        if (r.has_value()) return r;
        return std::nullopt;
    }
private:
std::size_t index_for(const K& key) const {
        return std::hash<K>{}(key);
    }

void expand_tables(int n_h_m) {
        while (tables.size() <= n_h_m) {
            tables.push_back(HashTable<K,V>(_capacity));
        }
    }
    std::vector<HashTable<K,V>> tables;
    int _size;
    int _capacity;
};
