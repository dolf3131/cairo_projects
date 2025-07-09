#[cfg(test)]
mod tests {
    use prime_prover::is_prime;
    fn test_prime() {
        assert(is_prime(2), '2 should be prime');
        assert(is_prime(3), '3 should be prime');
        assert(!is_prime(4), '4 should not be prime');
        assert(is_prime(13), '13 should be prime');
        assert(!is_prime(21), '21 should not be prime');
    }
}
