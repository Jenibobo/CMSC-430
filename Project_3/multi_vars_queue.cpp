#include <iostream>
#include <iomanip>
#include <mutex>
#include <queue>
#include <condition_variable>
#include <variant>
#include <vector>

using namespace std;

using MyVariant = variant<bool, int, double>;

template<class> inline constexpr bool always_false_v = false;

class MutliVar_Queue {
public:
    condition_variable ready;
    mutex queue_lock;

    queue<MyVariant> multi_vars;
    uint8_t empty();
    void initialize();
    void put(MyVariant element);
    MyVariant get();
};

void MutliVar_Queue::initialize() {
    /* initialize a queue */
    multi_vars = {};
}

MyVariant MutliVar_Queue::get() {
    unique_lock<mutex> condition_lock(queue_lock);
    if (multi_vars.empty()) {
        /* if a timeout was not hit, but the queue was empty previously this will execute */
        auto element = multi_vars.front();
        multi_vars.pop();
        return element;
    }

    else {
        /* not empty, return an element */
        auto element = multi_vars.front();
        multi_vars.pop();
        return element;
    }
    /* do not need a return value here since empty HAS to be either true/false */
}

void MutliVar_Queue::put(MyVariant element) {
    { lock_guard<mutex> put_guard(queue_lock);
        multi_vars.push(move(element));
    }
    ready.notify_one();
}

uint8_t MutliVar_Queue::empty() {
    lock_guard<mutex> empty_guard(queue_lock);
    if (multi_vars.size() == 0) {
        return 1;
    }
    return 0;
}

int main() {
   MutliVar_Queue q;
    q.put(true);
    q.put(1);
    q.put(2.3);

    while (!q.empty()) {
        auto elem = q.get();
        visit([](auto&& arg) {
            using T = decay_t<decltype(arg)>;
            if constexpr (is_same_v<T, bool>)
                cout << "bool with value " << arg << '\n';
            else if constexpr (is_same_v<T, int>)
                cout << "int with value " << arg << '\n';
            else if constexpr (is_same_v<T, double>)
                cout << "double with value " << arg << '\n';
            else
                static_assert(always_false_v<T>, "non-exhaustive visitor!");
            }, elem);
    }
}
