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
    else cout << "<not found>";
}

int main() {
    constexpr std::size_t CAP = 7;
    MultiHashTable<int, std::string> ht(CAP);

    cout << "=== TEST: insert_or_update without collision ===" << endl;
    ht.insert_or_update(2, "two");
    cout << "insert_or_update(2, \"two\") -> ";
    cout << endl << "find(2) -> ";
    print_opt(ht.find(2));
    cout << "\n";

    cout << "\n=== TEST: update of same key ===" << endl;
    ht.insert_or_update(2, "two-updated");
    cout << "find(2) -> ";
    print_opt(ht.find(2));
    cout << "\n";

    cout << "\n=== TEST: controlled collision ===" << endl;
    int a = 1;
    int b = 1 + CAP;
    cout << "Keys used to test collision: " << a << " i " << b << " (Same idx mod " << CAP << ")\n";
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

    cout << "\n=== TEST: insert after erase ===" << endl;
    ht.insert_or_update(b, "B-after-erase");
    cout << "find(" << b << ") -> ";
    print_opt(ht.find(b));
    cout << "\n";

    return 0;
}
