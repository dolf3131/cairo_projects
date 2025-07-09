#[starknet::interface]
pub trait IAgeVerifier<ContractState> { 

    fn verify_age(self: @ContractState, commitment: felt252, min_age: u32, age: felt252, nonce: felt252);
}


#[starknet::contract]
pub mod AgeVerifier {
    use core::poseidon::poseidon_hash_span;
    use core::array::ArrayTrait;
    use core::traits::Into;
    use core::result::ResultTrait; // unwrap()을 위해

    #[storage]
    struct Storage {
    }

    #[abi(embed_v0)]
    impl AgeVerifierImpl of super::IAgeVerifier<ContractState>{
        fn verify_age(self: @ContractState, commitment: felt252, min_age: u32, age: felt252, nonce: felt252) {
            // 1. Commitment Verification: commitment = Hash(age || nonce)
            let mut inputs = ArrayTrait::new();
            inputs.append(age);
            inputs.append(nonce);
            let calculated_commitment = core::poseidon::poseidon_hash_span(inputs.span());
            assert(calculated_commitment == commitment, 'Invalid commitment');

            // 2. Age Condition Verification: age >= min_age
            let u32_age: u32 = age.try_into().unwrap();
            
            let check: bool = u32_age >= min_age;
            assert(check, 'Underage'); // Reverted to simple comparison
        }
    }

    
}

