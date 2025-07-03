// n번째 피보나치 수를 계산하는 함수, 0번째 포함
// 재귀적으로 구현됩니다.

pub fn fib(n: u32) -> u32 {
    if n == 0 {
        return 0;
    }
    if n == 1 {
        return 1;
    }
    fib(n - 1) + fib(n - 2)
}

#[executable]
fn main() {
    //let n = 10;
    //let result = fib(n);

    println!("Fibonacci result for 10: {}", fib(10));
    
    println!("Fibonacci result for 5: {}", fib(5));
    
}