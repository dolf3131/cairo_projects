#[cfg(test)]
mod tests {
    use age_verifier::{IAgeVerifier, IAgeVerifierDispatcher, IAgeVerifierDispatcherTrait};
    use snforge_std::{declare, ContractClassTrait, DeclareResultTrait};
    use starknet::SyscallResultTrait;
    use core::array::ArrayTrait;
    use core::traits::Into;
    use core::poseidon::poseidon_hash_span;

    const MIN_AGE: u32 = 20;

    fn calculate_commitment(age: felt252, nonce: felt252) -> felt252 {
        let mut inputs = ArrayTrait::new();
        inputs.append(age);
        inputs.append(nonce);
        core::poseidon::poseidon_hash_span(inputs.span())
    }

    fn setup() -> starknet::ContractAddress {
        let contract_class = declare("AgeVerifier").unwrap().contract_class();
        let (contract_address, _) = contract_class.deploy(@array![]).unwrap_syscall();
        contract_address
    }

    #[test]
    fn test_age_verification_pass() {
        let contract_address = setup();
        let user_age: felt252 = 25;
        let nonce: felt252 = 12345;
        let commitment = calculate_commitment(user_age, nonce);
        IAgeVerifierDispatcher { contract_address }.verify_age(commitment, MIN_AGE, user_age, nonce);
    }

    #[should_panic(expected: ('Underage',))]
    #[test]
    fn test_age_verification_fail_underage() {
        let contract_address = setup();
        let user_age: felt252 = 18;
        let nonce: felt252 = 67890;
        let commitment = calculate_commitment(user_age, nonce);
        IAgeVerifierDispatcher { contract_address }.verify_age(commitment, MIN_AGE, user_age, nonce);
    }

    #[should_panic(expected: ('Invalid commitment',))]
    #[test]
    fn test_age_verification_fail_invalid_commitment() {
        let contract_address = setup();
        let user_age: felt252 = 25;
        let nonce: felt252 = 12345;
        let wrong_nonce: felt252 = 54321;
        let commitment = calculate_commitment(user_age, wrong_nonce); // Calculate with wrong nonce
        IAgeVerifierDispatcher { contract_address }.verify_age(commitment, MIN_AGE, user_age, nonce);
    }

    #[test]
    fn test_age_verification_edge_case_min_age() {
        let contract_address = setup();
        let user_age: felt252 = 20;
        let nonce: felt252 = 98765;
        let commitment = calculate_commitment(user_age, nonce);
        IAgeVerifierDispatcher { contract_address }.verify_age(commitment, MIN_AGE, user_age, nonce);
    }
}
