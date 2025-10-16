// main.cpp
#include <iostream>
#include <optional>
#include <string>
#include "multi_hash_table.hh"

using std::cout;
using std::endl;

template<typename T>
void print_opt(const std::optional<T>& o) {
    if (o) cout << *o;
    else cout << "<no trobat>";
}

int main() {
    constexpr std::size_t CAP = 7; // capacitat petita per forçar col·lisions fàcilment
    MultiHashTable<int, std::string> ht(CAP);

    cout << "=== TEST: insert_or_update sense col·lísió ===" << endl;
    ht.insert_or_update(2, "dos");
    cout << "insert_or_update(2, \"dos\") -> ";
    cout << endl << "find(2) -> ";
    print_opt(ht.find(2));
    cout << "\n";

    cout << "\n=== TEST: update de la mateixa clau ===" << endl;
    ht.insert_or_update(2, "dos-updated");
    cout << "find(2) -> ";
    print_opt(ht.find(2));
    cout << "\n";

    cout << "\n=== TEST: col·lisión controlada ===" << endl;
    int a = 1;
    int b = 1 + CAP; // garantim mateix índex si l'hash és modulo capacity simple
    cout << "Claus usades per testar col·lisió: " << a << " i " << b << " (mateix idx mod " << CAP << ")\n";
    ht.insert_or_update(a, "A");
    cout << "find(" << a << ") -> ";
    print_opt(ht.find(a));
    cout << "\n";
    ht.insert_or_update(b, "B");
    cout << "find(" << b << ") -> ";
    print_opt(ht.find(b));

    cout << "\n=== TEST: erase ===" << endl;
    ht.erase(a);
    cout << "find(" << a << ") -> ";
    print_opt(ht.find(a));
    cout << "\n";
    ht.erase(b);
    cout << "find(" << b << ") -> ";
    print_opt(ht.find(b));
    cout << "\n";

    cout << "\n=== TEST: inserir després d'esborrar ===" << endl;
    ht.insert_or_update(b, "B-after-erase");
    cout << "find(" << b << ") -> ";
    print_opt(ht.find(b));
    cout << "\n";

    return 0;
}
