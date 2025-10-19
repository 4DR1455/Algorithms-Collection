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
        int n_h_m = key/_capacity;
        if (n_h_m >= tables.size()) expand_tables(n_h_m);
        tables[n_h_m].insert_or_update(key, value);
        _size++;
    }
    void erase(const K& key) {
        tables[key/_capacity].erase(key);
        _size--;
    }
    std::optional<V> find(const K& key) {
        std::optional<V> r = tables[key/_capacity].get(key);
        if (r.has_value()) return r;
        return std::nullopt;
    }
private:
void expand_tables(int n_h_m) {
        while (tables.size() <= n_h_m) {
            tables.push_back(HashTable<K,V>(_capacity));
        }
    }
    std::vector<HashTable<K,V>> tables;
    int _size;
    int _capacity;
};
